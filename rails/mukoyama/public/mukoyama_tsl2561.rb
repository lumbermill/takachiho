# coding: utf-8
#----------------------------------------------------------------------
# TSL2561照度センサのデータをmukoyamaへアップするスクリプト
#----------------------------------------------------------------------

require 'i2c' # http://rubydoc.info/gems/i2c/0.2.22/I2C/Dev
require 'uri'

class LightSensor
  # Lightsensor: TAOS TSL2561
  DEV_ADDR = 0x39
  # registers
  REG_CONTROL = 0x00
  REG_TIMING = 0x01
  REG_THRESHLOWLOW = 0x02
  REG_THRESHLOWHIGH = 0x03
  REG_THRESHHIGHLOW = 0x04
  REG_THRESHHIGHHIGH = 0x05
  REG_INTERRUPT = 0x06
  REG_DATA0LOW = 0x0C
  REG_DATA0HIGH = 0x0D
  REG_DATA1LOW = 0x0E
  REG_DATA1HIGH = 0x0F
  # command register
  VAL_CMD_SELECT = 0x08
  VAL_CMD_CLEAR = 0x04
  VAL_CMD_WORD = 0x02
  VAL_CMD_BLOCK = 0x01
  # control register
  VAL_CTRL_ON = 0x03
  VAL_CTRL_OFF = 0x00
  class Luminosity
    class Channel
      attr_accessor :val
    end
    # channel0: visible & infrared light
    # channel1: infrared light
    attr_accessor :channel0, :channel1
    def calcLux
      if @channel0 > 0
        if (@channel1/@channel0).between?(0.0, 0.52)
          return (0.0315*@channel0)-(0.0593*@channel0*((@channel1/@channel0)**1.4))
        elsif (@channel1/@channel0).between?(0.52, 0.65)
          return (0.0229*@channel0)-(0.0291*@channel1)
        elsif (@channel1/@channel0).between?(0.65, 0.80)
          return (0.0157*@channel0)-(0.0180*@channel1)
        elsif (@channel1/@channel0).between?(0.80, 1.30)
          return (0.00338*@channel0)-(0.00260*@channel1)
        elsif @channel1/@channel0 > 1.30
          return 0
        end
      else
        return 0
      end
    end
  end
  def initialize(bus)
    @bus = I2C.create(bus)
  end
  def turnOn
    @bus.write(DEV_ADDR, REG_CONTROL, VAL_CTRL_ON)
  end
  def turnOff
    @bus.write(DEV_ADDR, REG_CONTROL, VAL_CTRL_OFF)
  end
  def getLuminosity
    # default conversion time is 402 ms, so make sure you wait this time after each measure
    l = Luminosity.new
    l.channel0 = @bus.read(DEV_ADDR, 2, ((VAL_CMD_SELECT ^ VAL_CMD_WORD) << 4) ^ REG_DATA0LOW).unpack('S').first
    l.channel1 = @bus.read(DEV_ADDR, 2, ((VAL_CMD_SELECT ^ VAL_CMD_WORD) << 4) ^ REG_DATA1LOW).unpack('S').first
    return l
  end
end

class TmprSensor
  # TemparatureSensor: BME280
  DEV_ADDR = 0x76

  # registers
  REG_DIG_T1   = 0x88
  REG_DIG_P1   = 0x8E
  REG_DIG_H1   = 0xA1
  REG_DIG_H2   = 0xE1

  REG_PRESS_MSB = 0xF7
  REG_CTRL_HUM = 0xF2
  REG_CTRL_MEAS = 0xF4
  REG_CONFIG = 0xF5

  def initialize(bus)
    @bus = I2C.create(bus)
    @sensors = {}
    setup
  end

  def update
    adc = adc_read
    t_fine = calc_t_fine(adc[:t])

    @sensors[:t] = compensate_t(t_fine)
    @sensors[:p] = compensate_p(adc[:p], t_fine)
    @sensors[:h] = compensate_h(adc[:h], t_fine)
  end

  def temperature
    update if @sensors.empty? # just in case update was not previously called
    @sensors[:t].round(2)
  end

  def pressure
    update if @sensors.empty? # just in case update was not previously called
    @sensors[:p].round(2)
  end

  def humidity
    update if @sensors.empty? # just in case update was not previously called
    @sensors[:h].round(2)
  end

  private

  def setup
    osrs_t = 1      #Temperature oversampling x 1
    osrs_p = 1      #Pressure oversampling x 1
    osrs_h = 1      #Humidity oversampling x 1
    mode   = 3      #Normal mode
    t_sb   = 5      #Tstandby 1000ms
    filter = 0      #Filter off
    spi3w_en = 0    #3-wire SPI Disable

    ctrl_meas_reg = (osrs_t << 5) | (osrs_p << 2) | mode
    config_reg    = (t_sb << 5) | (filter << 2) | spi3w_en
    ctrl_hum_reg  = osrs_h

    @bus.write(DEV_ADDR, REG_CTRL_HUM, ctrl_hum_reg)
    @bus.write(DEV_ADDR, REG_CTRL_MEAS, ctrl_meas_reg)
    @bus.write(DEV_ADDR, REG_CONFIG, config_reg)
  end


  def calib
    return @cdata if defined?(@cdata)

    t_data = @bus.read(DEV_ADDR,  6, REG_DIG_T1)
    p_data = @bus.read(DEV_ADDR, 18, REG_DIG_P1)
    h_data = ""
    h_data << @bus.read(DEV_ADDR, 1, REG_DIG_H1)
    h_data << @bus.read(DEV_ADDR, 7, REG_DIG_H2)
    h_data = patch_h_data(h_data)

    @cdata = {t: t_data.unpack("S<s<2"), p: p_data.unpack("S<s<8"), h: h_data.unpack("Cs<Cs<2c")}
  end

  def patch_h_data(h_data)
    bytes = h_data.bytes
    e5 = bytes[5]
    h4 = (bytes[4] << 4) + (e5 & 0x0f)
    bytes[4] = h4 & 0xff
    bytes[5] = h4 >> 8
    h5 = (e5 >> 4) + (bytes[6] << 4)
    bytes.insert(6, h5 & 0xff)
    bytes[7] = h5 >> 8
    bytes.pack("C*")
  end

  def adc_read
    data = @bus.read(DEV_ADDR, 8, REG_PRESS_MSB)
    data = patch_adc_data(data)
    p, t, h = data.unpack("L>L>S>")

    {p: p >> 12, t: t >> 12, h: h}
  end

  def patch_adc_data(adc_data)
    bytes = adc_data.bytes
    bytes.insert(3, 0)
    bytes.insert(7, 0)
    bytes.pack("C*")
  end

  def calc_t_fine(adc_t)
    var1 = (adc_t / 16384.0 - calib[:t][0] / 1024.0) * calib[:t][1]
    var2 = ((adc_t / 131072.0 - calib[:t][0] / 8192) ** 2) * calib[:t][2]
    var1 + var2
  end

  def compensate_t(t_fine)
    t_fine / 5120.0
  end

  def compensate_p(adc_p, t_fine)
    var1 = t_fine / 2.0 - 64000.0
    var2 = (var1 ** 2) * calib[:p][5] / 32768.0
    var2 = var2 + var1 * calib[:p][4] * 2.0
    var2 = var2 / 4.0 + calib[:p][3] * 65536.0
    var1 = (calib[:p][2] * (var1 ** 2) / 524288.0 + calib[:p][1] * var1) / 524288.0
    var1 = (1.0 + var1 / 32768.0) * calib[:p][0]

    return 0 if var1 == 0

    p = 1048576.0 - adc_p
    p = (p - var2 / 4096.0) * 6250.0 / var1
    var1 = calib[:p][8] * (p ** 2) / 2147483648.0
    var2 = p * calib[:p][7] / 32768.0
    (p + (var1 + var2 + calib[:p][6]) / 16.0) / 100.0
  end

  def compensate_h(adc_h, t_fine)
    var = t_fine - 76800.0

    return 0 if var.zero?

    var = (adc_h - (calib[:h][3] * 64.0 + calib[:h][4] / 16384.0 * var)) *
      (calib[:h][1] / 65536.0 * (1.0 + calib[:h][5] / 67108864.0 * var *
                                 (1.0 + calib[:h][2] / 67108864.0 * var)))
      var = var * (1.0 - calib[:h][0] * var / 524288.0)

      if var > 100.0
        var = 100.0
      elsif var < 0.0
        var = 0.0
      end

      var
  end
end

# I2Cへのファイルパス
I2CPATH = "/dev/i2c-1"

# TSL2561照度センサから照度情報[lux]を取得
def sensor_lux
  lightSensor = LightSensor.new(I2CPATH)
  lightSensor.turnOn
  sleep(0.420)
  luminosity = lightSensor.getLuminosity
  lux = luminosity.calcLux
  puts "lux=#{lux}"
  #puts "lux2=#{luminosity}"
  lightSensor.turnOff
  lux
end

# BME280温湿度・気圧センサから情報[t,p,h]を取得
def sensor_tmpr
  sensor = TmprSensor.new(I2CPATH)
  sensor.update
  t = sensor.temperature
  p = sensor.pressure
  h = sensor.humidity
  puts "temperature=#{t}; pressure=#{p}; humidity=#{h}"
  return t, p, h
end

# mukoyamaへのリクエストパラメータを作成
def get_url_params(lux, t, p, h, v)
  ts = Time.now.strftime("%Y-%m-%dT%H:%M:%S%z").sub("+","%2B")
  s = "dt=#{ts}"
  s += "&temperature=#{t}" if t
  s += "&pressure=#{p}" if p
  s += "&humidity=#{h}" if h
  s += "&illuminance=#{lux}" if lux
  s += "&voltage=#{v}" if v
  return s
end

url   = ENV["MUKOYAMA_URL"]
id    = ENV["MUKOYAMA_ID"]
token = ENV["MUKOYAMA_TOKEN"]
raise 'MUKOYAMA_URL is not set.' unless url
begin
  lux   = sensor_lux
rescue => e
  puts e
  lux = nil
end
begin
  t, p, h = sensor_tmpr
rescue => e
  puts e
  t, p, h = nil, nil, nil
end

# URLを作成してリクエスト送信
u = url + "/temps/upload?id=#{id}&token=#{token}&" + get_url_params(lux, t, p, h, nil)
puts u
cmd = 'curl -s -S "' + u + '"'
system(cmd)
