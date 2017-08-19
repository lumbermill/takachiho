#! /usr/local/bin/ruby
# 日次、月次の記録を更新します
require 'date'
require 'mysql2'
require 'optparse'
require 'fileutils'

Version = '1.0.0'

opt = OptionParser.new
opt.on('--all') { |v| OPTS[:all] = true }
opt.on('-e env') { |v| OPTS[:e] = v }

OPTS = {}
opt.parse!(ARGV)

LOG_RETENTION_PERIOD = 90 # 3months
IMG_RETENTION_PERIOD = 90 # 3months

dst_user = Rails.configuration.database_configuration[Rails.env]["username"]
dst_host = Rails.configuration.database_configuration[Rails.env]["host"] || "localhost"
dst_db = Rails.configuration.database_configuration[Rails.env]["database"]

@client = Mysql2::Client.new(host:dst_host,username:dst_user,database:dst_db)

def insert_daily(date)
  print "Inserting into temps_dailies "
  where = date.nil? ? "" : "WHERE DATE(dt) = '#{date}'"
  daily_sql = <<EOT
  INSERT IGNORE INTO temps_dailies
    (device_id,d,
    temperature_average,pressure_average,humidity_average,
    temperature_max,pressure_max,humidity_max,
    temperature_min,pressure_min,humidity_min,
    created_at,updated_at)
  SELECT device_id,date(dt),
  avg(temperature),avg(pressure),avg(humidity),
  max(temperature),max(pressure),max(humidity),
  min(temperature),min(pressure),min(humidity),
  now(),now()
  FROM temps #{where} GROUP BY device_id,date(dt);
EOT
  @client.query(daily_sql)
  puts @client.affected_rows
end

def insert_monthly(date)
  if date.nil?
    where = ""
  else
    begin_date = Date.new(date.year,date.month,1)
    end_date = begin_date + 1.month - 1.day
    where = "WHERE d BETWEEN '#{begin_date}' AND '#{end_date}'"
  end
  print "Inserting into temps_monthlies "
  monthly_sql = <<EOT
  INSERT IGNORE INTO temps_monthlies
    (device_id,`year_month`,
    temperature_average,pressure_average,humidity_average,
    temperature_max,pressure_max,humidity_max,
    temperature_min,pressure_min,humidity_min,
    created_at,updated_at)
  SELECT device_id,year(d)*100 + month(d),
  avg(temperature_average),avg(pressure_average),avg(humidity_average),
  max(temperature_max),max(pressure_max),max(humidity_max),
  min(temperature_min),min(pressure_min),min(humidity_min),
  now(),now()
  FROM temps_dailies #{where} GROUP BY device_id,year(d)*100+month(d);
EOT
  @client.query(monthly_sql)
  puts @client.affected_rows
end

def clean_logs
  b = Date.today - LOG_RETENTION_PERIOD
  print "Cleaning up logs older than #{b} .. temps:"
  sql = "DELETE FROM temps WHERE dt < '#{b}'"
  @client.query(sql)
  print @client.affected_rows
  print " mail:"
  sql = "DELETE FROM notifications WHERE updated_at < '#{b}'"
  @client.query(sql)
  puts @client.affected_rows
end

def main
  if OPTS[:all]
    insert_daily(nil)
    insert_monthly(nil)
  else
    yesterday = Date.today - 1
    insert_daily(yesterday)
    insert_monthly(yesterday) if Date.today.day == 1
    clean_logs
  end
end

if $0 == __FILE__
  main
end
