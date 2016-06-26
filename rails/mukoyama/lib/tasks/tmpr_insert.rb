#! /usr/local/bin/ruby
require 'date'
require 'mysql2'
require 'optparse'

Version = '1.0.0'
DIR = '/opt/bme280logs'

opt = OptionParser.new
opt.on('--all') { |v| OPTS[:all] = true }
opt.on('--daily') { |v| OPTS[:daily] = true }
opt.on('-e env') { |v| OPTS[:e] = v }

OPTS = {}
opt.parse!(ARGV)

env = OPTS[:e] || "development"
@client = Mysql2::Client.new(host:"localhost",username:"root",database:"mukoyama_#{env}")

def get_id_from_dirname(dir)
  b = File.basename(dir)
  # DIR/id_name/yymmdd.log
  b.split("_")[0]
end

def parsefile(f,id)
  print f+" "
  n = 0
  fh = open(f,"r")
  fh.each do |line|
    row = line.split(",").map { |v| v.strip }
    temp = row[0]
    press = row[1]
    humid = row[2]
    ts = row[3]
    sql = "INSERT IGNORE INTO tmpr_logs"
    sql += " (raspi_id,time_stamp,temperature,pressure,humidity,created_at,updated_at)"
    sql += " VALUES (#{id},'#{ts}',#{temp},#{press},#{humid},now(),now())"
    begin
      @client.query(sql)
      n += @client.affected_rows
    rescue => e
      $stderr.puts e
    end
  end
  fh.close
  puts "(%d)" % [n]
  return n
end


def parsedir(dir)
  id = get_id_from_dirname(dir)

  files = []
  Dir.entries(dir).sort.each do |f|
    next unless f.end_with? ".log"
    files += [f]
  end
  if OPTS[:all]
    n_rows = 0
    n_files = 0
    files.each do |f|
      n_rows += parsefile(dir+"/"+f,id)
      n_files += 1
    end
    puts "%d files scanned, %d rows added." % [n_files,n_rows]
    insert_daily(nil)
  elsif OPTS[:daily]
    # Expected to run the first of the day.
    n_rows = parsefile(dir+"/"+files[-2],id)
    yesterday = Date.today - 1
    insert_daily(yesterday)
  else
    n_rows = parsefile(dir+"/"+files[-1],id)
  end


  results = @client.query("SELECT max(time_stamp) AS time_stamp FROM tmpr_logs")
  results.each do |row|
    puts "Latest timestamp: %s" % [row["time_stamp"]]
  end
end

def insert_daily(date)
  where = date.nil? ? "" : "WHERE DATE(time_stamp) = '#{date}'"
  daily_sql = <<EOT
  INSERT IGNORE INTO tmpr_daily_logs
    (raspi_id,time_stamp,
    temperature_average,pressure_average,humidity_average,
    temperature_max,pressure_max,humidity_max,
    temperature_min,pressure_min,humidity_min,
    created_at,updated_at)
  SELECT raspi_id,date(time_stamp),
  avg(temperature),avg(pressure),avg(humidity),
  max(temperature),max(pressure),max(humidity),
  min(temperature),min(pressure),min(humidity),
  now(),now()
  FROM tmpr_logs #{where} GROUP BY raspi_id,date(time_stamp);
EOT

  @client.query(daily_sql)
end

def insert_monthly(date)
  begin_date = Date.new(date.year,date.month,1) - 1.month
  end_date = begin_date + 1.month - 1.day
  where = year_month.nil? ? "" : "WHERE time_stamp BETWEEN '#{begin_date}' AND '#{end_date}'"
  daily_sql = <<EOT
  INSERT IGNORE INTO tmpr_monthly_logs
    (raspi_id,`year_month`,
    temperature_average,pressure_average,humidity_average,
    temperature_max,pressure_max,humidity_max,
    temperature_min,pressure_min,humidity_min,
    created_at,updated_at)
  SELECT raspi_id,year(time_stamp)*100 + month(time_stamp),
  avg(temperature_average),avg(pressure_average),avg(humidity_average),
  max(temperature_max),max(pressure_max),max(humidity_max),
  min(temperature_min),min(pressure_min),min(humidity_min),
  now(),now()
  FROM tmpr_daily_logs #{where} GROUP BY raspi_id,year(time_stamp),month(time_stamp);
EOT

  @client.query(daily_sql)
end

def main
  Dir.entries(DIR).sort.each do |d|
    next if d.start_with? "."
    next unless File.directory? DIR+"/"+d
    puts d
    parsedir(DIR+"/"+d)
  end
end

main
