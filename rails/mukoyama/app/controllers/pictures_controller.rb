class PicturesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:upload,:upload_needed]
  before_action :set_raspi_id, only: [:index,:show]
  before_action :set_access_log, only: [:index]
  include ApplicationHelper

  # sudo mkdir -p /var/www/mukoyama/data
  # sudo chmod 777 /var/www/mukoyama/data
  BASEDIR = "/var/www/mukoyama/data/pictures"

  def index
    @id = params[:raspi_id]
    @setting = Setting.find_by(raspi_id: params[:raspi_id])
    @date = params[:date] || Date.today.strftime("%y%m%d")
    @page = (params[:page] || "1").to_i
    pagesize = 24
    @colsize = 2 # col-sm-#{@colsize}, the size for bootstrap column.

    skipped = 0
    @total = PictureGroup.where(raspi_id: @setting.raspi_id).count
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

    @groups = PictureGroup.where("raspi_id = #{@setting.raspi_id} #{cond_date}").order("head desc")
    @total = @groups.count
    @n_pages = @total / pagesize + (@total % pagesize == 0 ? 0 : 1)

    @dates = load_index(dir)

    @n_watchers = get_access_log
  end

  # Show every pictures taken. (former index action)
  def index_all
    @id = params[:raspi_id]
    @setting = Setting.find_by(raspi_id: params[:raspi_id])
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
    ts = params[:time_stamp] # 123123_456456 or 123123456456
    if ts.match /[0-9]{12}/
      ts = ts[0,6]+"_"+ts[6,6]
    end
    f = BASEDIR+"/"+params[:raspi_id]+"/"+ts+".jpg"
    # TODO: Check current_user's permission.
    unless File.file? f
      render text: f+" not found.", status: 404
      return
    end
    send_file(f, type: "image/jpeg")
    # render file: f, content_type: "image/jpeg", layout: false
  end

  def upload
    setting = Setting.find_by(raspi_id: params[:id])
    if setting.nil?
      render status:404, text: "Device not found for raspi_id="+params[:id].to_s
      return
    elsif setting.token4write != params[:token]
      render status:404, text: "Token did not match for raspi_id="+params[:id].to_s
      return
    end
    raspi_id = params[:id]
    file = params[:file]
    time_stamp = DateTime.parse(params[:time_stamp])
    filename = time_stamp.strftime "%y%m%d_%H%M%S.jpg"

    if params[:motion_sensor] == "true"
      msg = "#{time_stamp.hour}時#{time_stamp.min}分 センサーに反応あり"
      addresses = Address.where(raspi_id: raspi_id,active: true,motion_sensor: true)
      send_message(addresses, msg, false)
    end

    dir = "#{BASEDIR}/#{raspi_id}"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    File.open("#{dir}/#{filename}", 'wb'){|f| f.write(file.read)}

    render text: "Saved to #{filename}.", status: 200
  end

  # Render whether upload is needed or not. By checking the timestamp of file.
  def upload_needed
    setting = Setting.find_by(raspi_id: params[:id])
    if setting.nil?
      render status:404, text: "Device not found for raspi_id="+params[:id].to_s
      return
    elsif setting.token4write != params[:token]
      render status:404, text: "Token did not match for raspi_id="+params[:id].to_s
      return
    end
    raspi_id = params[:id]

    f = "#{BASEDIR}/#{raspi_id}/upload-needed.status"
    if File.file?(f) && File.mtime(f) > Time.now - 30.second
      render text: "Yes", status: 200
    else
      render text: "No", status: 200
    end
  end

  def request_upload
    raise 'need to login' unless current_user
    raspi_id = params[:raspi_id]
    raise "raspi id is not set." unless raspi_id
    dir = "#{BASEDIR}/#{raspi_id}"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    f = "#{BASEDIR}/#{raspi_id}/upload-needed.status"
    `touch #{f}`
    render text: "Touch #{f}", status: 200
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

    def set_raspi_id
      @id = params[:raspi_id]
      setting = Setting.find(@id)
      unless has_token4read? setting
        authenticate_user!
      end
    end
end
