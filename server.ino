#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <ArduinoHttpClient.h>
#include <TinyGPS++.h>
#include <DFRobot_DHT11.h>

DFRobot_DHT11 DHT;
#define DHT11_PIN A0
static const uint32_t GPSBaud = 9600;

// The TinyGPS++ object
TinyGPSPlus gps;
#define ss Serial3
#define DEBUG_PORT Serial


String lat="";
String lon="";
String AP = "bala";
String PASS = "741bala8";

int countTrueCommand;
int countTimeCommand;
boolean sendgps=true;
boolean found = false;
const int LFMOTOR_L =  A3; // the number of LINEFOLLOWER LEFT MOTOR pin

const int LFMOTOR_R =  A2; // the number of LINEFOLLOWER RIGHT MOTOR pin
LiquidCrystal_I2C lcd(0x27,20,4); 

void setup()
{
   ss.begin(GPSBaud);
  lcd.init();                      // initialize the lcd 
  lcd.init();
    DHT.read(DHT11_PIN);
  lcd.backlight();
  lcd.setCursor(0,0);
  lcd.print("Tem: ");
  lcd.print(DHT.temperature);
  lcd.print(" Hum: ");
  lcd.print(DHT.humidity);
  // Print a message to the LCD.
 
  DEBUG_PORT.begin(9600);
  Serial2.begin(115200);

//  DEBUG_PORT.println("AT");
  Serial2.println("AT");
   delay(50);
  while(!Serial2.available());
  DEBUG_PORT.println(Serial2.readString());

   Serial2.flush();
   delay(50);
  Serial2.println("AT+CIPMUX=1");
   delay(50);
  while(!Serial2.available());
    DEBUG_PORT.println(Serial2.readString());

  Serial2.flush();
   delay(50);
  Serial2.println("AT+CWMODE=1");
   delay(50);
  while(!Serial2.available());
    DEBUG_PORT.println(Serial2.readString());

  Serial2.println("AT+CWJAP=\""+ AP +"\",\""+ PASS +"\"");
  delay(50);
  Serial2.flush();
  delay(5000);
  while(!Serial2.available());
  DEBUG_PORT.print(Serial2.readString());

     Serial2.flush();
  Serial2.println("AT+CIFSR");
   delay(50);
  //Serial2.flush();
  delay(50);
  while(!Serial2.available());
  DEBUG_PORT.print(Serial2.readString());
   delay(50);
   
}

//--------------------------

void loop()
{

  
  // This sketch displays information every time a new sentence is correctly encoded.
  while (ss.available() > 0)
    if (gps.encode(ss.read()))
      displayInfo();

  if (millis() > 5000 && gps.charsProcessed() < 10)
  {
    Serial.println(F("No GPS detected: check wiring."));
    while(true);
  }
}
void displayInfo()
{
  Serial.print(F("Location: ")); 
  if (gps.location.isValid())
  {
    Serial.print(gps.location.lat(), 6);
    Serial.print(F(","));
    Serial.print(gps.location.lng(), 6);
    lcd.setCursor(0,1);
  lcd.print("");
  lcd.print(gps.location.lat(), 4);
   lcd.print(",");
  lcd.print(gps.location.lng(), 4);
  
  }
  else
  {
     lcd.setCursor(0,1);
     lcd.print("Loc: NO SIGNAL");
    Serial.print(F("INVALID"));
  }
   DHT.read(DHT11_PIN);
  lcd.backlight();
  lcd.setCursor(0,0);
  lcd.print("Tem: ");
  lcd.print(DHT.temperature);
  lcd.print(" Hum: ");
  lcd.print(DHT.humidity);
 Serial2.println("AT+CIPSTART=1,\"TCP\",\"www.balasblog.co.in\",80");
  delay(500);
   while(!Serial2.available());
    DEBUG_PORT.print(Serial2.readString());
    delay(100);

        String a="GET /dt_insertloc.php?location="+String(gps.location.lat(),6)+","+String(gps.location.lng(),6)+"&temp="+String(DHT.temperature)+","+String(DHT.humidity)+" HTTP/1.1\r\nHost: www.balasblog.co.in\r\n\r\n";
DEBUG_PORT.println( a );
    Serial2.println("AT+CIPSEND=1,"+String(a.length()));
        delay(20);
   // Serial2.flush();
    delay(200);
    while ( !Serial2.available() );
    {  DEBUG_PORT.println( Serial2.readString() );
    }
//    delay(200);
    Serial2.println(a);
      delay(20);
    Serial2.flush();
    delay(200);
    while ( !Serial2.available() );
    {  DEBUG_PORT.println( Serial2.readString() );
    }
    
//
//  Serial.print(F("  Date/Time: "));
//  if (gps.date.isValid())
//  {
//    Serial.print(gps.date.month());
//    Serial.print(F("/"));
//    Serial.print(gps.date.day());
//    Serial.print(F("/"));
//    Serial.print(gps.date.year());
//  }
//  else
//  {
//    Serial.print(F("INVALID"));
//  }
//
//  Serial.print(F(" "));
//  if (gps.time.isValid())
//  {
//    if (gps.time.hour() < 10) Serial.print(F("0"));
//    Serial.print(gps.time.hour());
//    Serial.print(F(":"));
//    if (gps.time.minute() < 10) Serial.print(F("0"));
//    Serial.print(gps.time.minute());
//    Serial.print(F(":"));
//    if (gps.time.second() < 10) Serial.print(F("0"));
//    Serial.print(gps.time.second());
//    Serial.print(F("."));
//    if (gps.time.centisecond() < 10) Serial.print(F("0"));
//    Serial.print(gps.time.centisecond());
//  }
//  else
//  {
//    Serial.print(F("INVALID"));
//  }

  Serial.println(); 
  delay(10000);
  }
