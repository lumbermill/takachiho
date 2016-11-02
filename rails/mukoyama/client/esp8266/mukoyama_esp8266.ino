
/*
 * Posting sensor value to Mukoyama example sketch.
 * コンパイルするためにはArduinoIDEにESP8266 Core for ArduinoとTime Library,SHT31 Libraryをインストールする必要があります。
 * 
 * ESP8266 Core for Arduino: https://github.com/esp8266/Arduino
 * Time Library: http://playground.arduino.cc/code/time
 * SHT31 Library: http://cactus.io/hookups/sensors/temperature-humidity/sht31/hookup-arduino-to-sensirion-sht31-temp-humidity-sensor
 * 参考: http://trac.switch-science.com/wiki/esp_dev_arduino_ide
 */

#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <TimeLib.h> 
#include <WiFiUdp.h>
#include <Ticker.h>
#include "cactus_io_SHT31.h"
extern "C" {
  #include "user_interface.h"
}

const char* ssid     = "*******";  // WifiのSSID
const char* password = "*******";  // Wifiのパスワード

IPAddress timeServer(133, 243, 238, 164); // ntp.nict.jp
const int timeZone = 9;    // Asia/Tokyo
WiFiUDP Udp;
unsigned int localPort = 8888;  // local port to listen for UDP packets

const char* host = "mukoyama.lmlab.net";
const int httpsPort = 443;
const char* mukoyama_post_url = "/logs/insert";
const char* mukoyama_id    = "*";         // mukoyama.lmlab.netから発行されるセンサーID
const char* mukoyama_token = "************";   // mukoyama.lmlab.netから発行されるトークン

Ticker ticker;
bool readyForTicker = true; // タイマーで指定時刻になったら立てるフラグ

cactus_io_SHT31 sht31; //温湿度センサー

void setup() {
  Serial.begin(115200);
  Serial.println();
  Serial.print("connecting to ");
  Serial.println(ssid);

  // *** Wifi Setup ***
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  // *** NTP Setup ***
  Serial.println("Starting UDP");
  Udp.begin(localPort);
  Serial.print("Local port: ");
  Serial.println(Udp.localPort());
  Serial.println("waiting for sync");
  setSyncProvider(getNtpTime);

  // *** sht31 ***
  Serial.println("*** setup shi31 start ***");
  Serial.println("Sensirion SHT31 - Humidity - Temp Sensor | cactus.io");
  if (!sht31.begin()) {
    Serial.println("Could not find the sensor. Check wiring and I2C address");
    while (1) delay(1);
  }
  Serial.println("*** setup shi31 end   ***");

  wifi_set_sleep_type(LIGHT_SLEEP_T); //省電力の設定
  ticker.attach_ms(10 * 60 * 1000, setReadyForTicker); //10分毎に実行する設定
}

void loop() {
  if (readyForTicker) {
    send_data();
    readyForTicker = false;
  }
}

void setReadyForTicker() {
  readyForTicker = true;// フラグを立てるだけ
}

void get_sensor_value(float* f_temp, float* f_press, float* f_humid) {
  *f_temp  = sht31.getTemperature_C();
  *f_press = 0; // 気圧はsht31では取得できない
  *f_humid = sht31.getHumidity();
  Serial.print("temperature:");
  Serial.println(*f_temp);
  Serial.print("pressure:");
  Serial.println(*f_press);
  Serial.print("humidity:");
  Serial.println(*f_humid);
}

void send_data() {
  // Use WiFiClientSecure class to create TLS connection
  WiFiClientSecure client;
  Serial.print("connecting to ");
  Serial.println(host);
  if (!client.connect(host, httpsPort)) {
    Serial.println("connection failed");
    return;
  }

  float f_temp, f_press, f_humid;
  get_sensor_value(&f_temp, &f_press, &f_humid);

  String timestamp = get_timestamp();//"2016-10-27T08:46:38+09:00"のような書式
  String temperature = String(f_temp);
  String pressure    = String(f_press);
  String humidity    = String(f_humid);

  char url_buf[256];
  sprintf(url_buf,"%s?id=%s&token=%s&time_stamp=%s&temperature=%s&pressure=%s&humidity=%s",
      mukoyama_post_url, mukoyama_id, mukoyama_token, timestamp.c_str(),
      temperature.c_str(), pressure.c_str(), humidity.c_str());

  String url = String(url_buf);
  Serial.print("requesting URL: ");
  Serial.println(url);

  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
      "Host: " + host + "\r\n" +
      "User-Agent: MukoyamaClientESP8266\r\n" +
      "Connection: close\r\n\r\n");

  Serial.println("request sent");
  while (client.connected()) {
    String line = client.readStringUntil('\n');
    if (line == "\r") {
      Serial.println("headers received");
      break;
    }
  }
  String line = client.readString();
  Serial.println("reply was:");
  Serial.println("==========");
  Serial.println(line);
  Serial.println("==========");
  Serial.println("closing connection");
}

String get_timestamp(){
  // digital clock display of the time
  String timestamp = String("");
  timestamp = String(timestamp + String(year()));
  timestamp = String(timestamp + String("-"));
  timestamp = String(timestamp + zero_padding(month()));
  timestamp = String(timestamp + String("-"));
  timestamp = String(timestamp + zero_padding(day()));
  timestamp = String(timestamp + String("T"));
  timestamp = String(timestamp + zero_padding(hour()));
  timestamp = String(timestamp + String(":"));
  timestamp = String(timestamp + zero_padding(minute()));
  timestamp = String(timestamp + String(":"));
  timestamp = String(timestamp + zero_padding(second()));
  timestamp = String(timestamp + String("+"));
  timestamp = String(timestamp + String(timeZone));
  timestamp = String(timestamp + String(":00"));
  return timestamp;
}

String zero_padding(int digits){
  String num_str = String("");
  if(digits < 10) {
    num_str = String('0');
  }
  num_str = String(num_str + String(digits));
  return num_str;
}

/*-------- NTP code ----------*/

const int NTP_PACKET_SIZE = 48; // NTP time is in the first 48 bytes of message
byte packetBuffer[NTP_PACKET_SIZE]; //buffer to hold incoming & outgoing packets

time_t getNtpTime(){
  while (Udp.parsePacket() > 0) ; // discard any previously received packets
  Serial.println("Transmit NTP Request");
  sendNTPpacket(timeServer);
  uint32_t beginWait = millis();
  while (millis() - beginWait < 1500) {
    int size = Udp.parsePacket();
    if (size >= NTP_PACKET_SIZE) {
      Serial.println("Receive NTP Response");
      Udp.read(packetBuffer, NTP_PACKET_SIZE);  // read packet into the buffer
      unsigned long secsSince1900;
      // convert four bytes starting at location 40 to a long integer
      secsSince1900 =  (unsigned long)packetBuffer[40] << 24;
      secsSince1900 |= (unsigned long)packetBuffer[41] << 16;
      secsSince1900 |= (unsigned long)packetBuffer[42] << 8;
      secsSince1900 |= (unsigned long)packetBuffer[43];
      return secsSince1900 - 2208988800UL + timeZone * SECS_PER_HOUR;
    }
  }
  Serial.println("No NTP Response :-(");
  return 0; // return 0 if unable to get the time
}

// send an NTP request to the time server at the given address
void sendNTPpacket(IPAddress &address){
  // set all bytes in the buffer to 0
  memset(packetBuffer, 0, NTP_PACKET_SIZE);
  // Initialize values needed to form NTP request
  // (see URL above for details on the packets)
  packetBuffer[0] = 0b11100011;   // LI, Version, Mode
  packetBuffer[1] = 0;     // Stratum, or type of clock
  packetBuffer[2] = 6;     // Polling Interval
  packetBuffer[3] = 0xEC;  // Peer Clock Precision
  // 8 bytes of zero for Root Delay & Root Dispersion
  packetBuffer[12]  = 49;
  packetBuffer[13]  = 0x4E;
  packetBuffer[14]  = 49;
  packetBuffer[15]  = 52;
  // all NTP fields have been given values, now
  // you can send a packet requesting a timestamp:                 
  Udp.beginPacket(address, 123); //NTP requests are to port 123
  Udp.write(packetBuffer, NTP_PACKET_SIZE);
  Udp.endPacket();
}
