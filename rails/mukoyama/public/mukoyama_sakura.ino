#include <SakuraIO.h>

// LM35 温度センサから温度の情報(アナログ)を取得し、送信するスケッチです

SakuraIO_I2C sakuraio;

float a_in = 0;
float temp_c = 0;

void setup(){
  while((sakuraio.getConnectionStatus() & 0x80) != 0x80){
    delay(1000);
    Serial.print(".");
  }
  Serial.println("");
}

void loop() {
  a_in = analogRead(0);
  temp_c = ((5 * a_in) / 1024) * 100;
  sakuraio.enqueueTx(0,temp_c);
  sakuraio.send();
  // 15秒おきに送信しておいて、クラウド側から10分置きに適当なものをピックアップ
  // ESP8266同様のタイミング(NTP使用)でデータ送信できるようにすべきか？
  delay(15000);
  Serial.print(temp_c);
  Serial.print("  ");
  Serial.println(sakuraio.getConnectionStatus());
}
