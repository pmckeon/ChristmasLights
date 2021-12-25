#include <ESP32Servo.h>

Servo myservo;

int servoPin = 25;
int triggerPin = 5;
int lighteraPin = 32;
int lighterbPin = 21;
int buttonState = 0;

void setup() {
  // Allow allocation of all timers
  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);
  myservo.setPeriodHertz(50);    // standard 50 hz servo
  myservo.attach(servoPin, 1000, 2000); // attaches the servo on pin 18 to the servo object
  // using default min/max of 1000us and 2000us
  // different servos may require different min/max settings
  // for an accurate 0 to 180 sweep
  pinMode(triggerPin, INPUT_PULLUP);
  pinMode(lighteraPin, OUTPUT);
  pinMode(lighterbPin, OUTPUT);
  digitalWrite(lighteraPin, LOW);
  digitalWrite(lighterbPin, LOW);
  myservo.write(0);
}

void loop() {
  buttonState = digitalRead(triggerPin);

  if (buttonState == LOW) {
    // FIRE!!!
    digitalWrite(lighteraPin, HIGH);
    digitalWrite(lighterbPin, HIGH);
    myservo.write(90);
  } else {
    digitalWrite(lighteraPin, LOW);
    digitalWrite(lighterbPin, LOW);
    myservo.write(0);
  }

  delay(200);
}
