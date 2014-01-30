#include <WiFlyHQ.h>

#include <SoftwareSerial.h>

SoftwareSerial wifiSerial(8,9);
WiFly wifly;

const char pingSite = '192.168.1.3';

void terminal();

void setup() {           
  char buf[32];     
  wifiSerial.begin(9600);
  if(!wifly.begin(&wifiSerial, &Serial)) {
    Serial.println("Can't start wifly");
    terminal();
  } else {
    Serial.println("Started wifly");
  }
}


void loop() {
  Serial.println("HI FROM SERIAL\n");
  delay(1000);
}

void terminal() {
  while(1) {
    if(wifly.available() > 0) {
      Serial.write(wifly.read());
    }
    if(Serial.available()) {
      wifly.write(Serial.read());
    }
  }
}
