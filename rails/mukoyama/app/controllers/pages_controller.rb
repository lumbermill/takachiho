class PagesController < ApplicationController
  def root
    render layout: 'root'
  end

  def dashboard
    @raspi_list = Setting.where(user_id: current_user.id).order("id")
  end

  def dashboard_stat1
    conn = ActiveRecord::Base.connection
    id = params[:raspi_id]
    sql = "SELECT count(1) AS c, min(time_stamp) AS first, max(time_stamp) AS last FROM tmpr_logs WHERE raspi_id = #{id}"
    h = conn.select_one(sql).to_hash
    h["raspi_id"] = id
    render text: h.to_json
  end
end
