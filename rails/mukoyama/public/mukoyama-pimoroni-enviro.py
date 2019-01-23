import datetime, os, time
from envirophat import weather, light

def get_url_params():
  t = weather.temperature()
  p = weather.pressure(unit='hPa')
  h = None
  l = light.light()
  # Python's datetmie doesn't have timezone info.
  # You may need to set system timezone as JST. (hint: sudo raspi-config)
  # FIXME: the code will post wrong datetime. should be keep in UTC??(is the hint wrong?)
  ts = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S%z")
  s = "dt=%s" % (ts)
  s += "&temperature=%f" % (t)
  s += "&pressure=%f" % (p)
  # s += "&humidity=%f" % (h)
  s += "&illuminance=%f" % (l)
  # s += "&voltage=#{v}"
  return s

if __name__ == '__main__':
  try:
    url = os.environ["MUKOYAMA_URL"]
    id = os.environ["MUKOYAMA_ID"]
    token = os.environ["MUKOYAMA_TOKEN"]
    u = (url+"/temps/upload?id=%s&token=%s&"+get_url_params()) % (id,token)
    cmd = 'curl -s -S "'+u+'"'
    os.system(cmd)
  except KeyboardInterrupt:
    pass
