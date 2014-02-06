#include <WiFlyHQ.h>

#include <SoftwareSerial.h>

SoftwareSerial wifiSerial(8,9);
WiFly wifly;
const int relayPin  = 2;
const char pingSite = '192.168.1.3';

void terminal();
void resetWifly();

void setup() {
  pinMode(relayPin, OUTPUT);
  char buf[32];
  resetWifly();
  Serial.println("10 more seconds...");
  delay(5000);
  Serial.println("5 more seconds...");
  delay(5000);
  wifiSerial.begin(9600);
  if(!wifly.begin(&wifiSerial, &Serial)) {
    Serial.println("Can't start wifly");
    //terminal();
  } else {
    Serial.println("Started wifly");
  }
}


void loop() {

}
void resetWifly() {
  Serial.println("reset!");
  digitalWrite(relayPin, LOW);
  delay(3000);
  digitalWrite(relayPin, HIGH);

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
