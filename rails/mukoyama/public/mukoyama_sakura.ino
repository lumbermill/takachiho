// BME280 温度センサから温度の情報を取得し、送信するスケッチです
// This prrogram requires SparkFun's BME280 library.
// https://github.com/sparkfun/SparkFun_BME280_Arduino_Library
#include "SparkFunBME280.h"
#include <SakuraIO.h>


SakuraIO_I2C sakuraio;
BME280 bme280;

void setup(){
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  // Setup BME280
  bme280.settings.commInterface = I2C_MODE; // Use I2C Interface
  bme280.settings.I2CAddress = 0x76;        // I2C Address
  bme280.settings.runMode = 3;              // Normal mode
  bme280.settings.tempOverSample = 1;
  bme280.settings.pressOverSample = 1;
  bme280.settings.humidOverSample = 1;

  delay(10);
  if (bme280.begin() != 0x60)
  {
    Serial.println("BME280 communication error!");
    while (1);
  }

  Serial.print("Waiting to come online");
  for (;;) {
    if ( (sakuraio.getConnectionStatus() & 0x80) == 0x80 ) break;
    Serial.print(".");
    delay(1000);
  }
  Serial.println("");
}

void loop() {
  float temp = bme280.readTempC();
  sakuraio.enqueueTx(0,temp);
  sakuraio.send();
  Serial.print(temp);
  Serial.print("  ");
  Serial.print(sakuraio.getSignalQuality());
  Serial.print("  ");
  Serial.println(sakuraio.getConnectionStatus());
  // 15秒おきに送信しておいて、クラウド側から10分置きに適当なものをピックアップ
  // ESP8266同様のタイミング(NTP使用)でデータ送信できるようにすべきか？
  delay(15000);
}
