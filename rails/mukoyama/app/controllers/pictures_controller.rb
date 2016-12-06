class PicturesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:upload]

  # sudo mkdir -p /opt/mukoyama.lmlab.net/data
  # sudo chmod 777 /opt/mukoyama.lmlab.net/data
  BASEDIR = "/opt/mukoyama.lmlab.net/data/pictures"

  def index
    @id = params[:raspi_id]
    @page = (params[:page] || "1").to_i
    pagesize = 60
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
      render status:404, text: "Device not found for raspi_id="+params[:id]
      return
    elsif setting.token != params[:token]
      render status:404, text: "Token did not match for raspi_id="+params[:id]
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
end
