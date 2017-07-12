# Copy weathers and weathers_cities records from the host.
src_host = "ks05" # source host

dst_user = Rails.configuration.database_configuration[Rails.env]["username"]
dst_host = Rails.configuration.database_configuration[Rails.env]["host"] || "localhost"
dst_db = Rails.configuration.database_configuration[Rails.env]["database"]

require 'optparse'
opt = OptionParser.new
opt.on('--all') { |v| OPTS[:all] = true }
opt.on('--dry-run') { |v| OPTS[:dry_run] = true }
opt.on('-e env') { |v| OPTS[:e] = v }

OPTS = {}
opt.parse!(ARGV)

db = "-u#{dst_user} -h#{dst_host} #{dst_db}"

# Not allowed to run on the source host.
exit if ENV["HOSTNAME"] == src_host

cmds = []
cmds += ["ssh #{src_host} mysqldump -uroot k_exports weathers_cities | mysql #{db}"]
if OPTS[:all]
  cmds += ["ssh #{src_host} mysqldump -uroot k_exports weathers | mysql #{db}"]
else
  # Fetch only latest(within a day) records.
  cmds += ["ssh #{src_host} \"mysqldump -uroot k_exports weathers -t --replace --where 'modified_at >= date_add(now(),interval -1 day)'\" | mysql #{db}"]
end
cmds.each do |cmd|
  puts cmd
  next if OPTS[:dry_run]
  o = `#{cmd}`
  unless $? == 0
    puts o
    exit
  end
end
