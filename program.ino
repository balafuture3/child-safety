#include <SoftwareSerial.h>
#include <LiquidCrystal_I2C.h>


LiquidCrystal_I2C lcd(0x27,20,4);  // set the LCD address to 0x27 for a 16 chars and 2 line display

SoftwareSerial wifiSerial(2, 3);      // RX, TX for ESP8266

bool DEBUG = true;   //show more logs
int responseTime = 10; //communication timeout
String AP = "bala";
String PASS = "741bala8";
#define echoPinF 4
#define trigPinF 5
#define echoPinB 6
#define trigPinB 7
long duration;
int distanceF;
int distanceB;
const int IR =  A3;
const int F_MOTOR_L =  8;
 
const int B_MOTOR_L =  9; 

const int F_MOTOR_R =  10;

const int B_MOTOR_R =  11; 


void setup()
{
  
  pinMode(trigPinF,OUTPUT);
  pinMode(echoPinF,INPUT);
  pinMode(trigPinB,OUTPUT);
  pinMode(echoPinB,INPUT);
  pinMode(IR, INPUT);
  pinMode(F_MOTOR_R, OUTPUT);
  pinMode(B_MOTOR_L, OUTPUT);
  pinMode(B_MOTOR_R, OUTPUT);
  digitalWrite(F_MOTOR_L, LOW);
  digitalWrite(F_MOTOR_R, LOW);
  digitalWrite(B_MOTOR_L, LOW);
  digitalWrite(B_MOTOR_R, LOW);
  
  lcd.init();                      // initialize the lcd 
  // Print a message to the LCD.
  lcd.backlight();
  lcd.setCursor(0,0);
  lcd.print(" Food Delivery ");
    lcd.setCursor(0,1);
  lcd.print("     Robot     ");
  // Open serial communications and wait for port to open esp8266:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  wifiSerial.begin(9600);
//  table1Forward();
//  table1Backword();
//    table2Forward();
//  table1Backword();
//  while (!wifiSerial) {
//    ; // wait for serial port to connect. Needed for Leonardo only
//  }
//  sendToWifi("AT+CWMODE=3",responseTime,DEBUG); // configure as access point
//  sendToWifi("AT+CIFSR",responseTime,DEBUG); // get ip address
//  sendToWifi("AT+CIPMUX=1",responseTime,DEBUG); // configure for multiple connections
//  sendToWifi("AT+CIPSERVER=1,80",responseTime,DEBUG); // turn on server on port 80
// 
//  sendToUno("Wifi connection is running!",responseTime,DEBUG);
  wifiSerial.println("AT");
   delay(50);
  while(!wifiSerial.available());
  Serial.println(wifiSerial.readString());

   wifiSerial.flush();
   delay(50);

     wifiSerial.println("AT+CWMODE=3");
   delay(50);
  while(!wifiSerial.available());
  Serial.println(wifiSerial.readString());

   wifiSerial.flush();
   delay(50);

    wifiSerial.println("AT+CIPMUX=1");
   delay(50);
  while(!wifiSerial.available());
  Serial.println(wifiSerial.readString());

   wifiSerial.flush();
   delay(50);

      wifiSerial.println("AT+CIPSERVER=1");
   delay(50);
  while(!wifiSerial.available());
  Serial.println(wifiSerial.readString());

   wifiSerial.flush();
   delay(50);
         wifiSerial.println("AT+CIFSR");
   delay(50);
  while(!wifiSerial.available());
  Serial.println(wifiSerial.readString());
    lcd.setCursor(0,0);
  lcd.print(" Wifi Initialized ");
    lcd.setCursor(0,1);
  lcd.print("Connect to Wifi ");


//   wifiSerial.flush();
//   delay(50);
   
//  wifiSerial.println("AT+CIPMUX=1");
//   delay(50);
//  while(!wifiSerial.available());
//    Serial.println(wifiSerial.readString());
//
//  wifiSerial.flush();
//   delay(50);
//  wifiSerial.println("AT+CWMODE=1");
//   delay(50);
//  while(!wifiSerial.available());
//    Serial.println(wifiSerial.readString());
//
//  wifiSerial.println("AT+CWJAP=\""+ AP +"\",\""+ PASS +"\"");
//  delay(50);
//  wifiSerial.flush();
//  delay(2500);
//  while(!wifiSerial.available());
//  Serial.print(wifiSerial.readString());
//
//     wifiSerial.flush();
//  wifiSerial.println("AT+CIFSR");
//   delay(50);
//  //wifiSerial.flush();
//  delay(50);
//  while(!wifiSerial.available());
//  Serial.print(wifiSerial.readString());
//   delay(50);
//
//   
// wifiSerial.println("AT+CIPSTART=1,\"TCP\",\"www.balasblog.co.in\",80");
//  delay(250);
//   while(!wifiSerial.available());
//    Serial.print(wifiSerial.readString());
//    delay(250);
//
//        String a="GET /test.php HTTP/1.1\r\nHost: www.balasblog.co.in\r\n\r\n";
//    wifiSerial.println("AT+CIPSEND=1,"+String(a.length()));
//        delay(20);
//    wifiSerial.flush();
//    delay(250);
//    while ( !wifiSerial.available() );
//    {  Serial.println( wifiSerial.readString() );
//    }
//    delay(20);
//    wifiSerial.println(a);
//      delay(20);
//    wifiSerial.flush();
//    delay(20);
//    while ( !wifiSerial.available() );
//    {  
////      Serial.flush();
//      String e= wifiSerial.readString();
//       lcd.print(e);
//      Serial.println( e );
//      
//    }
    



//  wifiSerial.println("AT+CIPSTART=1,\"TCP\",\"14.98.224.37\",903");
//  delay(4000);
//// delay(2500);
//    //wifiSerial.flush();
//    while(!wifiSerial.available());
//    Serial.print(wifiSerial.readString());
//    delay(250);
  //    Serial.println(command);


}


void loop()
{
 while(wifiSerial.available())
 {
 lcd.setCursor(0,0);
 String a = wifiSerial.readString();
 lcd.clear();
 lcd.print(a.substring(11,15));
 Serial.println(a);
 wifiSerial.flush();
 if(a.substring(11,15)=="MODE")
 {
  if(digitalRead(IR)==0)
  {
   lcd.clear();
 lcd.print("Order for Table2");
  table1Forward();
   lcd.setCursor(0,0);
 lcd.clear();
 lcd.print("Table2 Delivered");
 delay(3000);
    table1Backword();
     lcd.clear();
 lcd.print("Kitchen Reached");
  }
  else
  {
    lcd.clear();
 lcd.print("Place Food");
  }
 }
 else if(a.substring(11,15)=="POWE")
 {
  if(digitalRead(IR)==0)
  {
     lcd.clear();
 lcd.print("Order for Table1");
    table2Forward();
     lcd.setCursor(0,0);
 lcd.clear();
 lcd.print("Table1 Delivered");
  delay(3000);
  table2Backword();
       lcd.clear();
 lcd.print("Kitchen Reached");
 }
   else
  {
    lcd.clear();
 lcd.print("Place Food");
  }
 }
 }
}
 int FrontUltrasonic(int i,boolean lf,boolean lb,boolean rf,boolean rb)
{
LOOPa:
  digitalWrite(trigPinF,LOW);
  delayMicroseconds(2);
  digitalWrite(trigPinF,HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPinF,LOW);

 duration=pulseIn(echoPinF,HIGH);
  distanceF=(duration*0.034/2);
  
//    lcd.setCursor(0,0);
//  lcd.print(distanceF);
//  
//  lcd.print("    ");
  if(distanceF<20)
  {
//     lcd.setCursor(0,0);
//     lcd.print("Obstacle at ");
//    lcd.setCursor(0,1);
//     lcd.print(i);
//      lcd.print("    ");
    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,LOW);
    goto LOOPa;
    
  }
    else
  {
      digitalWrite(F_MOTOR_L,lf);
    digitalWrite(B_MOTOR_L,lb);
    digitalWrite(F_MOTOR_R,rf);
    digitalWrite(B_MOTOR_R,rb);
  }
//  Serial.print("DistanceF : ");
//  Serial.print(distanceF);
//  Serial.println(" cm ");
   return  distanceF;
}
int BackUltrasonic(int i,boolean lf,boolean lb,boolean rf,boolean rb)
{
  b:
  digitalWrite(trigPinB,LOW);
  delayMicroseconds(2);
  digitalWrite(trigPinB,HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPinB,LOW);

 duration=pulseIn(echoPinB,HIGH);
  distanceB=(duration*0.034/2);
//    lcd.setCursor(0,1);
//  lcd.print(distanceB);
//  lcd.print("    ");
  if(distanceB<20)
  {
//     lcd.setCursor(0,0);
//     lcd.print("Obstacle at ");
//    lcd.setCursor(0,1);
//     lcd.print(i);
//      lcd.print("    ");
    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,LOW);
    goto b;
  }
  else
  {
      digitalWrite(F_MOTOR_L,lf);
    digitalWrite(B_MOTOR_L,lb);
    digitalWrite(F_MOTOR_R,rf);
    digitalWrite(B_MOTOR_R,rb);
  }
//  Serial.print("DistanceB : ");
//  Serial.print(distanceB);
//  Serial.println(" cm ");
   return  distanceB;
}
void table1Forward()
{
    digitalWrite(F_MOTOR_L,HIGH);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,HIGH);
    digitalWrite(B_MOTOR_R,LOW);

for(int i=0;i<250;i++)
{
  BackUltrasonic(i,HIGH,LOW,HIGH,LOW);
  FrontUltrasonic(i,HIGH,LOW,HIGH,LOW);
}
    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,HIGH);
    digitalWrite(B_MOTOR_R,LOW);

    for(int i=0;i<250;i++)
{
  BackUltrasonic(i,LOW,LOW,HIGH,LOW);
  FrontUltrasonic(i,LOW,LOW,HIGH,LOW);
}
    digitalWrite(F_MOTOR_L,HIGH);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,HIGH);
    digitalWrite(B_MOTOR_R,LOW);

for(int i=0;i<250;i++)
{
  BackUltrasonic(i,HIGH,LOW,HIGH,LOW);
  FrontUltrasonic(i,HIGH,LOW,HIGH,LOW);
}

    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,LOW);
//    
//    delay(3000);
    
  
}
void table1Backword()
{
    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,HIGH);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,HIGH);

    for(int i=0;i<250;i++)
{
  BackUltrasonic(i,LOW,HIGH,LOW,HIGH);
  FrontUltrasonic(i,LOW,HIGH,LOW,HIGH);
}

//    digitalWrite(F_MOTOR_L,LOW);
//    digitalWrite(B_MOTOR_L,HIGH);
//    digitalWrite(F_MOTOR_R,LOW);
//    digitalWrite(B_MOTOR_R,HIGH);
//
//     delay(3000);

    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,HIGH);

    
        for(int i=0;i<250;i++)
{
  BackUltrasonic(i,LOW,LOW,LOW,HIGH);
  FrontUltrasonic(i,LOW,LOW,LOW,HIGH);
}
    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,HIGH);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,HIGH);

    for(int i=0;i<250;i++)
{
  BackUltrasonic(i,LOW,HIGH,LOW,HIGH);
  FrontUltrasonic(i,LOW,HIGH,LOW,HIGH);
}

    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,LOW);  
}

void table2Forward()
{
    digitalWrite(F_MOTOR_L,HIGH);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,HIGH);
    digitalWrite(B_MOTOR_R,LOW);

for(int i=0;i<250;i++)
{
  BackUltrasonic(i,HIGH,LOW,HIGH,LOW);
  FrontUltrasonic(i,HIGH,LOW,HIGH,LOW);
}
    digitalWrite(F_MOTOR_L,HIGH);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,LOW);

    for(int i=0;i<250;i++)
{
  BackUltrasonic(i,HIGH,LOW,LOW,LOW);
  FrontUltrasonic(i,HIGH,LOW,LOW,LOW);
}
    digitalWrite(F_MOTOR_L,HIGH);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,HIGH);
    digitalWrite(B_MOTOR_R,LOW);

for(int i=0;i<250;i++)
{
  BackUltrasonic(i,HIGH,LOW,HIGH,LOW);
  FrontUltrasonic(i,HIGH,LOW,HIGH,LOW);
}

    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,LOW);
//    
//    delay(3000); 
  
}

void table2Backword()
{
    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,HIGH);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,HIGH);

    for(int i=0;i<250;i++)
{
  BackUltrasonic(i,LOW,HIGH,LOW,HIGH);
  FrontUltrasonic(i,LOW,HIGH,LOW,HIGH);
}

//    digitalWrite(F_MOTOR_L,LOW);
//    digitalWrite(B_MOTOR_L,HIGH);
//    digitalWrite(F_MOTOR_R,LOW);
//    digitalWrite(B_MOTOR_R,HIGH);
//
//     delay(3000);

    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,HIGH);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,LOW);

    
        for(int i=0;i<250;i++)
{
  BackUltrasonic(i,LOW,HIGH,LOW,LOW);
  FrontUltrasonic(i,LOW,HIGH,LOW,LOW);
}
    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,HIGH);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,HIGH);

    for(int i=0;i<250;i++)
{
  BackUltrasonic(i,LOW,HIGH,LOW,HIGH);
  FrontUltrasonic(i,LOW,HIGH,LOW,HIGH);
}

    digitalWrite(F_MOTOR_L,LOW);
    digitalWrite(B_MOTOR_L,LOW);
    digitalWrite(F_MOTOR_R,LOW);
    digitalWrite(B_MOTOR_R,LOW);  
}
