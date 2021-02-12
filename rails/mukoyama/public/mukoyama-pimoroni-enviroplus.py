import datetime, os, time
from bme280 import BME280
from ltr559 import LTR559

def get_url_params():
  bme280 = BME280()
  t = bme280.get_temperature()
  p = bme280.get_pressure()
  h = bme280.get_humidity()
  ltr559 = LTR559()
  l = ltr559.get_lux()
  # Python's datetmie doesn't have timezone info.
  # You may need to set system timezone as JST. (hint: sudo raspi-config)
  ts = time.strftime("%Y-%m-%dT%H:%M:%S%z")
  s = "dt=%s" % (ts)
  s += "&temperature=%f" % (t)
  s += "&pressure=%f" % (p)
  s += "&humidity=%f" % (h)
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
