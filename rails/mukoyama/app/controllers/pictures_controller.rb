class PicturesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:upload,:upload_needed]

  # sudo mkdir -p /opt/mukoyama.lmlab.net/data
  # sudo chmod 777 /opt/mukoyama.lmlab.net/data
  BASEDIR = "/opt/mukoyama.lmlab.net/data/pictures"

  # TODO: 自分以外のユーザ、tokenを持っていないアクセスは弾く
  def index
    @id = params[:raspi_id]
    # TODO: 日付でも絞り込みしたい、（日付選択されてる場合、ページ番号は、その日付の中だけで採番するのがシンプル？）
    @date = ""
    @dates = ["TODO 日付絞り込み"]
    @page = (params[:page] || "1").to_i
    pagesize = 24
    skipped = 0
    @total = 0
    @files = []
    @n_pages = 0

    dir = BASEDIR+"/#{@id}"
    logger.debug(dir)
    return unless File.directory? dir
    Dir.entries(dir).sort.reverse.each do |f|
      next if f.start_with? "."
      next unless f.end_with? ".jpg"
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
  end

  def show
    f = BASEDIR+"/"+params[:raspi_id]+"/"+params[:time_stamp]+".jpg"
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
    raspi_id = params[:raspi_id]
    raise "raspi id is not set." unless raspi_id
    dir = "#{BASEDIR}/#{raspi_id}"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    f = "#{BASEDIR}/#{raspi_id}/upload-needed.status"
    `touch #{f}`
    render text: "Touch #{f}", status: 200
  end
end
