class Bme280Controller < ApplicationController
  def index
    # TODO: list all raspi_id on logs table.
  end

  def show_graph
    id = params[:id]
    db = connect_bme280
    st = (DateTime.now - 1.days).strftime("%F %T")
    en = DateTime.now.strftime("%F %T")
    # Get stat.
    sql = "SELECT count(1) AS c,min(ts) AS mi,max(ts) AS ma FROM bme280_logs WHERE raspi_id = #{id}"
    results = db.query(sql)
    row = results.first
    @count = row["c"]
    raise "No record found for raspi_id=#{id}" if @count == 0
    @min = row["mi"].strftime("%F")
    @max = row["ma"].strftime("%F %T")
    @days = ((row["ma"] -  row["mi"]) / 64800).floor
    st,en = get_span
    @span = "from "+st+" to "+en
    @id = id

    # Taking over parameter to show_graph_data action.
    @p = {id: params[:id], day_offset: params[:day_offset]}
    @p = @p.to_json.html_safe
  end

  def show_graph_data
    id = params[:id]
    src = params[:src] || "temperature"
    unit = params[:unit] || "10min"
    db = connect_bme280
    if unit == "day" # 1day
      @data = {avg: [], max: [], min: [], diff: []}
      sql = "SELECT ts,#{src}_avg,#{src}_max,#{src}_min FROM bme280_logs_dailies WHERE raspi_id = #{id} ORDER BY ts"
      results = db.query(sql)
      results.each do |row|
        ts = (row["ts"].to_time.to_i + 9 * 60 * 60) * 1000
        @data[:avg] += [[ts,row[src+"_avg"]]]
        @data[:max] += [[ts,row[src+"_max"]]]
        @data[:min] += [[ts,row[src+"_min"]]]
        @data[:diff] += [[ts,row[src+"_max"] - row[src+"_min"]]]
      end
    else # 10min
      @data = []
      st,en = get_span
      sql = "SELECT ts,#{src} FROM bme280_logs WHERE raspi_id = #{id} AND ts BETWEEN '#{st}' AND '#{en}' ORDER BY ts"
      db = connect_bme280
      results = db.query(sql)
      results.each do |row|
        # @data += [["Date.parse('"+row["ts"].to_s+"')",row[src]]]
        @data += [[(row["ts"].to_i + 9 * 60 * 60) * 1000,row[src]]]
      end
    end
    respond_to do |format|
      format.json { render json: @data }
    end
  end

  def show_raw
    id = params[:id]
    db = connect_bme280
    st = (DateTime.now - 30.days).strftime("%F %T")
    en = DateTime.now.strftime("%F %T")
    sql = "SELECT * FROM bme280_logs WHERE raspi_id = #{id} AND ts BETWEEN '#{st}' AND '#{en}' ORDER BY ts"
    @results = db.query(sql)
    respond_to do |format|
      format.html
      format.csv do
        filename = "bme280_#{id}.csv"
        headers["Content-Type"] ||= 'text/csv'
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
        render layout: false
      end
    end
  end

  private
    def connect_bme280
      client = Mysql2::Client.new(host:"localhost",username:"root",database:"sandbox-rails_"+Rails.env)
    end

    def get_span
      day_offset = (params[:day_offset] || "0").to_i
      st = (DateTime.now - (day_offset + 1).days).strftime("%F %T")
      en = (DateTime.now - day_offset.days).strftime("%F %T")
      return [st, en]
    end
end
