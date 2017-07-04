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
IMG_PATH = "/var/www/mukoyama/data/pictures"

env = OPTS[:e] || "development"
@client = Mysql2::Client.new(host:"localhost",username:"root",database:"mukoyama_#{env}")

def insert_daily(date)
  print "Inserting into tmpr_daily_logs "
  where = date.nil? ? "" : "WHERE DATE(time_stamp) = '#{date}'"
  daily_sql = <<EOT
  INSERT IGNORE INTO tmpr_daily_logs
    (device_id,time_stamp,
    temperature_average,pressure_average,humidity_average,
    temperature_max,pressure_max,humidity_max,
    temperature_min,pressure_min,humidity_min,
    created_at,updated_at)
  SELECT device_id,date(time_stamp),
  avg(temperature),avg(pressure),avg(humidity),
  max(temperature),max(pressure),max(humidity),
  min(temperature),min(pressure),min(humidity),
  now(),now()
  FROM tmpr_logs #{where} GROUP BY device_id,date(time_stamp);
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
    where = "WHERE time_stamp BETWEEN '#{begin_date}' AND '#{end_date}'"
  end
  print "Inserting into tmpr_monthly_logs "
  monthly_sql = <<EOT
  INSERT IGNORE INTO tmpr_monthly_logs
    (device_id,`year_month`,
    temperature_average,pressure_average,humidity_average,
    temperature_max,pressure_max,humidity_max,
    temperature_min,pressure_min,humidity_min,
    created_at,updated_at)
  SELECT device_id,year(time_stamp)*100 + month(time_stamp),
  avg(temperature_average),avg(pressure_average),avg(humidity_average),
  max(temperature_max),max(pressure_max),max(humidity_max),
  min(temperature_min),min(pressure_min),min(humidity_min),
  now(),now()
  FROM tmpr_daily_logs #{where} GROUP BY device_id,year(time_stamp),month(time_stamp);
EOT
  @client.query(monthly_sql)
  puts @client.affected_rows
end

def clean_logs
  b = Date.today - LOG_RETENTION_PERIOD
  print "Cleaning up logs older than #{b} .. tmpr:"
  sql = "DELETE FROM tmpr_logs WHERE time_stamp < '#{b}'"
  @client.query(sql)
  print @client.affected_rows
  print " mail:"
  sql = "DELETE FROM mail_logs WHERE time_stamp < '#{b}'"
  @client.query(sql)
  puts @client.affected_rows
end

def remove_image
  EXTENSION = ".jpg"
  b = (Date.today - IMG_RETENTION_PERIOD)
  print "Cleaning up images older than #{b.strftime("%Y/%m/%d")} .. "
  c = 0
  Dir.glob("#{IMG_PATH}/**/*") do |f|
    next unless f.end_with? EXTENSION
    date = File.basename(f, EXTENSION).split("_")[0]
    next if date.to_i > b.strftime("%y%m%d").to_i
    FileUtils.rm(f)
    c += 1
  end
  puts "ok(#{c})"
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
    # TODO:画像の削除を実装する場合、コメントインしてください。
    # remove_image
  end
end

if $0 == __FILE__
  main
end
