# Copy weathers and weathers_cities records from the host.
hostname = "ks05" # source host

require 'optparse'
opt = OptionParser.new
opt.on('--all') { |v| OPTS[:all] = true }
opt.on('--dry-run') { |v| OPTS[:dry_run] = true }
opt.on('-e env') { |v| OPTS[:e] = v }

OPTS = {}
opt.parse!(ARGV)

db = "mukoyama_" + (OPTS[:e] || "development")

# Not allowed to run on the source host.
exit if ENV["HOSTNAME"] == hostname

cmds = []
cmds += ["ssh #{hostname} mysqldump -uroot k_exports weathers_cities | mysql -uroot #{db}"]
if OPTS[:all]
  cmds += ["ssh #{hostname} mysqldump -uroot k_exports weathers | mysql -uroot #{db}"]
else
  # Fetch only latest(within a day) records.
  cmds += ["ssh #{hostname} mysqldump -uroot k_exports weathers -t --replace --where \"modified_at >= date_add(now(),interval -1 day)\" | mysql -uroot #{db}"]
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
