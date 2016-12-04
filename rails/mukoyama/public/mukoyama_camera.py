#coding: utf-8
# Print temp,pressure,hum,timestamp in a line.

from datetime import datetime, timedelta
import os

def take_picture(filename):
    # no preview, timeout 1sec(because it's impossible to set 0)
    cmd = 'raspistill -n -t 1 -o '+filename
    os.system(cmd)

if __name__ == '__main__':
  try:
    url = os.environ["MUKOYAMA_URL"]
    id = os.environ["MUKOYAMA_ID"]
    token = os.environ["MUKOYAMA_TOKEN"]
    filename = "/tmp/photo.jpg"
    take_picture(filename)
    # Python's datetime doesn't have timezone info.
    # You may need to set system timezone as JST. (hint: sudo raspi-config)
    ts = datetime.now().strftime("%Y-%m-%dT%H:%M:%S%z")
    u = (url+"/pictures/upload?id=%s&token=%s&time_stamp=%s") % (id,token,ts)
    cmd = 'curl -s -S -X POST -F file=@'+filename+' "'+u+'"'
    os.system(cmd)
  except KeyboardInterrupt:
    pass
