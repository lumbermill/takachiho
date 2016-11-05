#! /usr/local/bin/ruby
# 日次、月次の記録を更新します
require 'date'
require 'mysql2'
require 'optparse'

Version = '1.0.0'

opt = OptionParser.new
opt.on('--all') { |v| OPTS[:all] = true }
opt.on('-e env') { |v| OPTS[:e] = v }

OPTS = {}
opt.parse!(ARGV)

env = OPTS[:e] || "development"
@client = Mysql2::Client.new(host:"localhost",username:"root",database:"mukoyama_#{env}")

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
  puts @client.affected_rows
end

def insert_monthly(date)
  if date.nil?
    where = ""
  else
    begin_date = Date.new(date.year,date.month,1) - 1.month
    end_date = begin_date + 1.month - 1.day
    where = year_month.nil? ? "" : "WHERE time_stamp BETWEEN '#{begin_date}' AND '#{end_date}'"
  end
  monthly_sql = <<EOT
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
  @client.query(monthly_sql)
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
  end
end

if $0 == __FILE__
  main
end
