class PicturesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:upload]

  def index
    # TODO:
  end

  def show_picture
    # TODO:
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
    file = params[:upfile]
    time_stamp = DateTime.parse(params[:time_stamp])
    filename = time_stamp.strftime "%y%m%d_%H%M%S.jpg"

    dir = "/opt/mukoyama.lmlab.net/data/pictures/#{raspi_id}"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    File.open("#{dir}/#{filename}", 'wb'){|f| f.write(file.read)}

    render text: "save #{filename}.", status: 200
  end
end
