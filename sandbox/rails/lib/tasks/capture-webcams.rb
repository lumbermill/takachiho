#! /usr/local/bin/ruby
require 'date'

BASEDIR = "/opt/webcamlogs"
FILE = DateTime.now().strftime("%y%m%d_%H%M%S")+".jpg"

CAMS = {kunimi: "118.21.109.43",gorge: "118.21.109.46"}

CAMS.each do |k,ip|
  dir = "#{BASEDIR}/#{k.to_s}"
  `mkdir -p #{dir}`
  `curl "http://#{ip}:50000/SnapshotJpeg?Resolution=640x480&Quality=Standard" > #{dir}/#{FILE}`
end

# Referred from Panasonic network camera Ver 23 manual
# http://ssbu-t.psn-web.net/Japanese/netwkcam/technic/ntwrkcam_cgi_intrfs1_v23.pdf

# Crontab
# */15 5-8 * * * /usr/local/bin/ruby ./bin/capture-webcams.rb


# Schema
# CREATE TABLE webcam_logs ()
