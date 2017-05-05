#! /usr/local/bin/ruby
require 'date'
require 'mysql2'
require 'optparse'

Version = '1.0.0'
DIR = '/opt/webcamlogs'

opt = OptionParser.new
opt.on('--clean') { |v| OPTS[:clean] = true }
opt.on('-e env') { |v| OPTS[:e] = v }
OPTS = {}
opt.parse!(ARGV)

env = OPTS[:e] || "development"
@client = Mysql2::Client.new(host:"localhost",username:"root",database:"sandbox-rails_#{env}")

def to_jst(f)
  # yymmdd_hhmmss.jpg
  y = "20"+f[0,2]
  mo = f[2,2]
  d = f[4,2]
  h = f[7,2]
  mi = f[9,2]
  s = f[11,2]
  return "#{y}-#{mo}-#{d} #{h}:#{mi}:#{s}"
end

Dir.entries(DIR).sort.each do |id|
  next if id.start_with? "."
  next unless File.directory? DIR+"/"+id
  print id+": "
  n_rows = 0
  n_files = 0
  Dir.entries(DIR+"/"+id).sort.each do |f|
    next unless f.end_with? ".jpg"
    ts = to_jst(f)
    sql = "INSERT IGNORE INTO webcam_logs"
    sql += " (webcam_id,ts)"
    sql += " VALUES ('#{id}','#{ts}')"
    @client.query(sql)
    n_rows += @client.affected_rows
    n_files += 1
  end
  puts "%d files scanned, %d rows added." % [n_files,n_rows]
end

# TODO: --clean

sql_daily = <<EOT
INSERT IGNORE INTO webcam_logs_dailies SELECT webcam_id,date(ts),count(1),
sum(marks),max(marks),max(id),now()
FROM webcam_logs GROUP BY webcam_id,date(ts);
EOT
# TODO: update max_marks_id
sql_daily2 = <<EOT
UPDATE webca_logs_dailies d SET max_marks_id = (SELECT max(id) FROM webcam_logs l WHERE l.webcam_id = d.webcam_id)
EOT

@client.query(sql_daily)

results = @client.query("SELECT max(ts) AS ts FROM webcam_logs")
results.each do |row|
  puts "Latest timestamp: %s" % [row["ts"]]
end
