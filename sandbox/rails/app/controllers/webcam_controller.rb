class WebcamController < ApplicationController
  DIR = "/opt/webcamlogs"

  def show_images
    id = params[:id]
    db = ActiveRecord::Base.connection
    st = (DateTime.now - 1.days).strftime("%F %T")
    en = DateTime.now.strftime("%F %T")
    # Get stat.
    sql = "SELECT ts,n,(SELECT ts FROM webcam_logs WHERE id = max_marks_id) AS mts FROM webcam_logs_dailies WHERE webcam_id = '#{id}' ORDER BY ts DESC"
    @data = []
    results = db.execute(sql)
    results.each do |row|
      @data += [{ts: row[0], n: row[1], path: to_path(id,row[2])}]
    end
    @id = id
  end

  def show_images_day
    id = params[:id]
    date = params[:date]
    db = ActiveRecord::Base.connection
    sql = "SELECT ts,marks,memo FROM webcam_logs WHERE webcam_id = '#{id}' AND date(ts) = '#{date}' ORDER BY ts DESC"
    @data = []
    results = db.execute(sql)
    results.each do |row|
      @data += [{ts: row[0], marks: row[1], path: to_path(id,row[0]),memo: row[2]}]
    end
    @id = id
  end

  private
    def to_path(id,ts)
      "/webcamlogs/#{id}/"+ts.strftime("%y%m%d_%H%M%S")+".jpg"
    end
end
