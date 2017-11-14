#!/usr/bin/python
#coding: utf-8

import datetime, os, time
import smbus

i2c = smbus.SMBus(1)
address = 0x5c

def get_data():
    try:
        i2c.write_i2c_block_data(address,0x00,[])
    except:
        pass
    time.sleep(0.003)
    i2c.write_i2c_block_data(address,0x03,[0x00,0x04])

    time.sleep(0.015)
    block = i2c.read_i2c_block_data(address,0,6)
    hum = float(block[2] << 8 | block[3])/10
    tmp = float(block[4] << 8 | block[5])/10

    return [tmp,0,hum]

def get_url_params():
  t,p,h = get_data()
  # Python's datetmie doesn't have timezone info.
  # You may need to set system timezone as JST. (hint: sudo raspi-config)
  ts = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S%z")
  s = "dt=%s" % (ts)
  s += "&temperature=%f" % (t)
  # s += "&pressure=%f" % (p)
  s += "&humidity=%f" % (h)
  # s += "&illuminance=#{lux}"
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
