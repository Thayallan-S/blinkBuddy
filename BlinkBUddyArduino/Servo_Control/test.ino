#include <Servo.h>
#include <LiquidCrystal.h>
LiquidCrystal lcd(12,11,5,4,3,2);

Servo myServo; 
int value;
int angle;
void setup() {
  // put your setup code here, to run once:
Serial.begin(9600); 
myServo.attach(7);
lcd.begin(16,2);
  lcd.print("blink");
  lcd.setCursor(7,1);
  lcd.print("buddy");
}

void loop() {
  // put your main code here, to run repeatedly:
    value = digitalRead(6); 
  Serial.println(value);
  if(value==1){
    angle=95;
    }
   if(value==0){
    angle=0;
    }   
    // print out the angle for the servo motor
  Serial.print(", angle: ");
  Serial.println(angle);

  // set the servo position
  myServo.write(angle);

  // wait for the servo to get there
  delay(15);

}
