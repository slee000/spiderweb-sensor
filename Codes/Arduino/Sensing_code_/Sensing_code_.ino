/* **************************************************
* Sudong Lee ( sudong.lee (at) epfl.ch )
*   CREATE Lab
*    : https://www.epfl.ch/labs/create/
*   Institute of Mechanical Engineering (IGM)
*   School of Engineering (STI)
*   EPFL
************************************************** */
// https://github.com/waspinator/CD74HC4067
/*
 * Controlling and looping through a CD74HC4067's channel outputs
 *
 * Connect the four control pins to any unused digital or analog pins.
 * This example uses digital pins 4, 5, 6, and 7.
 *
 * Connect the common pin to any other available pin. This is the pin that will be
 * shared between the 16 channels of the CD74HC4067. The 16 channels will inherit the
 * capabilities of the common pin. For example, if it's connected to an analog pin,
 * you will be able to use analogRead on each of the 16 channels.
 *
*/
#include <Wire.h>
#include <CD74HC4067.h>

CD74HC4067 mux01(4, 5, 6, 7);
int muxN01[] = {0,1,2,3,4,5,6};
CD74HC4067 mux02(8, 9, 10, 11);
int muxN02[] = {3,4,5,6,7,8,9};

uint8_t byte1, byte2;
uint16_t byte0;
uint16_t byte_r;

double data2vol_t;
double vol_t;
double vol;

double resistorVol;
double sensorResist;

long currTime=0;
double num = 0;
double startTime = 0;
double hz = 0.0;

void setup() {
  Wire.begin(); 
  Serial.begin(115200);

  writei2c(0b1001000, 0b01010000, 0b11100011);
  delay(1);
  data2vol_t = ( (pow(2,15)-1) / pow(2,15) * 6.144 ) / 32767;
  delay(10);
  
  startTime = double(millis()) * 0.001; // Hz
}

void loop(){
  //hzCheck(); // Hz
  //Serial.print(",");
  
  for (int j=0; j<7; j++) {
    mux02.channel(muxN02[j]);
    delayMicroseconds(1500);

    for (int i=j+1; i<8; i++) {
      mux01.channel(muxN01[i]);
      delayMicroseconds(1500);

      writei2c(0b1001000, 0b01110000, 0b11100011);
      delayMicroseconds(10);
      byte_r = readi2c(0b1001000);
      delayMicroseconds(10);

      resistorVol = data2vol(byte_r);
      sensorResist = (5.0-resistorVol)/resistorVol * 2200;
      if (j==5 && i==6) { Serial.println(sensorResist, 2); }
      else {
        Serial.print(sensorResist, 2);
        Serial.print(",");
      }
    }
  }
}

void writei2c(uint8_t address, uint8_t byte_m, uint8_t byte_l){
  Wire.beginTransmission(address);
  Wire.write(0b00000001);
  Wire.write(byte_m);
  Wire.write(byte_l);
  Wire.endTransmission();
}

uint16_t readi2c(uint8_t address){
  Wire.beginTransmission(address);
  Wire.write(0b00000000);
  Wire.endTransmission();
  Wire.requestFrom(address,2);
  byte1 = Wire.read();
  byte2 = Wire.read();

  byte0 = byte1<<8 | byte2;
  return byte0;
}

double data2vol(uint16_t byte_){
  if (byte_ >= 32768) {
    byte_ = ~byte_ + 1;
    vol_t = - data2vol_t * double(byte_);
  }
  else {
    vol_t = data2vol_t * double(byte_);
  }
  return vol_t;
}

void hzCheck(){
  num = num+1;
  hz = num / (double(millis())* 0.001-startTime);
  Serial.print(hz, 3);
}
