class PicturesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:upload,:upload_needed]
  before_action :set_device_id, only: [:index]
  before_action :set_picture, only: [:show]
  before_action :set_access_log, only: [:index]
  include ApplicationHelper

  # sudo mkdir -p /var/www/mukoyama/data
  # sudo chmod 777 /var/www/mukoyama/data
  BASEDIR = "/var/www/mukoyama/data/pictures"

  def index
    pict_per_page = 60
    @id = params[:device_id]
    @device = Device.find_by(id: @id)
    @date = params[:date] || "" # Date.today.strftime("%Y-%m-%d")
    @colsize = 2 # col-sm-#{@colsize}, the size for bootstrap column.

    if @date == ""
      @pictures = Picture.where("device_id = ?", @device.id).order("dt desc").page(params[:page]).per(pict_per_page)
    else
      time_start = Time.zone.parse(@date) # ex. Time.zone.parse('2017-11-07') => 2017-11-07 00:00:00 +0900
      time_end = time_start.tomorrow
      @pictures = Picture.where("device_id = ? and ? <= dt and dt < ?", @device.id, time_start, time_end).order("dt desc").page(params[:page]).per(pict_per_page)
    end

    # 日付セレクトボックス用の日付配列
    @dates = Picture.where("device_id = ?", @device.id).order("dt DESC").pluck(:dt).map{|dt| dt.strftime('%Y-%m-%d')}.uniq
    @dates.unshift("")
    @n_watchers = get_access_log
  end

  def download_this
    @id = params[:device_id]
    @date = params[:date] || ""
    zip_path = ""
    if @date == ""
      zip_path = Picture.save_to_zip(@id, @date, 120) #日付指定がない場合は120件までにする
    else
      zip_path = Picture.save_to_zip(@id, @date)
    end
    send_file(zip_path, type: "application/zip", disposition: "inline", length:File.size(zip_path))
  end

  def index_grouped
    # picture_groupsの代表写真を並べる(motionの登場で要らなくなった…)
    @id = params[:device_id]
    @device = Device.find_by(id: params[:device_id])
    @date = params[:date] || Date.today.strftime("%y%m%d")
    @page = (params[:page] || "1").to_i
    pagesize = 24
    @colsize = 2 # col-sm-#{@colsize}, the size for bootstrap column.

    skipped = 0
    @total = PictureGroup.where(device_id: @device.id).count
    @n_pages = 0

    dir = BASEDIR+"/#{@id}"
    return unless File.directory? dir
    if @date == ""
      cond_date = ""
    else
      dmin = @date.to_i * 1000000
      dmax = dmin + 999999
      cond_date = "and head between #{dmin} and #{dmax}"
    end

    @groups = PictureGroup.where("device_id = #{@device.id} #{cond_date}").order("head desc")
    @total = @groups.count
    @n_pages = @total / pagesize + (@total % pagesize == 0 ? 0 : 1)

    @dates = load_index(dir)

    @n_watchers = get_access_log
  end

  # Show every pictures taken. (former index action)
  def index_all
    @id = params[:device_id]
    @setting = Device.find_by(device_id: params[:device_id])
    @date = params[:date] || ""
    @page = (params[:page] || "1").to_i
    pagesize = 24
    @colsize = 2 # col-sm-#{@colsize}, the size for bootstrap column.

    if params[:head] && params[:tail]
      head = params[:head].to_i
      tail = params[:tail].to_i
    end

    skipped = 0
    @total = 0
    @files = []
    @n_pages = 0

    dir = BASEDIR+"/#{@id}"
    return unless File.directory? dir
    Dir.entries(dir).sort.reverse.each do |f|
      next if f.start_with? "."
      next unless f.end_with? ".jpg"
      next unless f.start_with? @date
      if head.is_a? Fixnum
        m = f.sub("_","").match(/([0-9]{12}).jpg/)
        seq = m[1].to_i
        raise "#{f}" if seq.nil?
        break if seq < tail
        next if head < seq
      end
      @total += 1
      if skipped < (@page - 1) * pagesize
        skipped += 1
        next
      end
      if @files.length < pagesize
        @files += [f]
      end
    end
    @n_pages = @total / pagesize + (@total % pagesize == 0 ? 0 : 1)

    @dates = load_index(dir)

    @n_watchers = get_access_log
  end

  def show
    unless @picture.data
      render text: 'data is empty.', status: 404
      return
    end
    response.headers['Content-Length'] = @picture.data.length.to_s
    send_data(@picture.data, type: @picture.data_type, disposition: "inline")
  end

  def upload
    device = Device.find_by(id: params[:id])
    if device.nil?
      render status:404, text: "Device not found for device_id="+params[:id].to_s
      return
    elsif device.token4write != params[:token]
      render status:404, text: "Token did not match for device_id="+params[:id].to_s
      return
    end
    file = params[:file] || params[:data]
    begin
      dt = DateTime.parse(params[:dt] || params[:time_stamp])
    rescue
      dt = DateTime.now.to_s
      render status:500, text: "dt=#{dt}&file=(file)&data_type=image/jpeg&detected=false&info=(optional)"
      return
    end

    if params[:motion_sensor] == "true" # deprecated. use detected flag instead.
      msg = "#{time_stamp.hour}時#{time_stamp.min}分 センサーに反応あり"
      addresses = Address.where(device_id: device.id,active: true,motion_sensor: true)
      send_message(addresses, msg, false)
    end

    @picture = Picture.find_or_initialize_by(device_id: device.id, dt: dt)
    insert_or_update = @picture.id.nil? ? "Inserted" : "Updated"
    @picture.detected = params[:detected] || false
    @picture.data = file.tempfile.read # TODO: need to type check?
    if params[:data_type]
      @picture.data_type = params[:data_type]
    else
      @picture.data_type = file.content_type
    end
    @picture.info = params[:info] if params[:info]

    if @picture.save
      render text: "#{insert_or_update} #{@picture.id}", status: 200
    else
      render text: @picture.errors, status: 500
    end
  end

  # Render whether upload is needed or not. By checking the timestamp of file.
  def upload_needed
    setting = Device.find_by(id: params[:id])
    if setting.nil?
      render status:404, text: "Device not found for device_id="+params[:id].to_s
      return
    elsif setting.token4write != params[:token]
      render status:404, text: "Token did not match for device_id="+params[:id].to_s
      return
    end
    device_id = params[:id]

    f = "#{BASEDIR}/#{device_id}/upload-needed.status"
    if File.file?(f) && File.mtime(f) > Time.now - 30.second
      render text: "Yes", status: 200
    else
      render text: "No", status: 200
    end
  end

  def request_upload
    raise 'need to login' unless current_user
    device_id = params[:device_id]
    raise "raspi id is not set." unless device_id
    dir = "#{BASEDIR}/#{device_id}"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    f = "#{BASEDIR}/#{device_id}/upload-needed.status"
    `touch #{f}`
    render text: "Touch #{f}", status: 200
  end

  def download
    raise 'need to login.' unless current_user
    device_id = params[:device_id]
    raise "device_id is not set." unless device_id
    path_zip = Mukoyama::DOWNLOAD_DIR+"/#{device_id}-pictures.zip"
    path_lock = path_zip.sub(".zip","") # directory
    if params[:exec] == "true"
      # exec=trueの場合、状態に合わせた処理を実行
      if File.file? path_zip
        # ダウンロード
        send_file(path_zip, type: "application/zip", disposition: "inline", length:File.size(path_zip))
        return
      elsif File.directory? path_lock
        # 何もしない
      else
        # アーカイブタスクをバックグラウンド起動。これでいいのかな… active_job?
        Thread.new { `cd #{Rails.root} && rails runner lib/tasks/zip-pictures.rb #{device_id}` }
        sleep(1)
      end
    end

    # ボタン文字列の表示切り替えに利用
    if File.file? path_zip
      render text: "ready"
    elsif File.directory? path_lock
      render text: "archiving"
    else
      render text: "idle"
    end
  end

  private
    def load_index(dir)
      f = "#{dir}/index_all.json"
      if !File.file?(f) || File.mtime(f).day != Date.today.day
        # Generate index.json
        dates = []
        Dir.entries(dir).sort.reverse.each do |f|
          next if f.start_with? "."
          next unless f.end_with? ".jpg"
          d = f[0,6]
          dates += [d] unless dates[-1] == d
        end
        File.open(f,"w") do |fh|
          fh.write(dates.to_json)
        end
      end
      JSON.parse(File.read(f))
    end

    def has_token4read?(setting)
      if params[:token]
        # トークンはセッションにセットして使いまわせるようにする
        session[:token4read] = params[:token]
      end
      return false unless setting.readable?
      return setting.token4read == session[:token4read]
    end

    def set_device_id
      @id = params[:device_id]
      setting = Device.find(@id)
      unless has_token4read? setting
        authenticate_user!
      end
    end

    def set_picture
      @picture = Picture.find(params[:id])
      unless @picture.device.readable?
        authenticate_user!
      end
    end
end
