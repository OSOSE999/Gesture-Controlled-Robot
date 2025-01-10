#define ENA 9   // PWM pin for left motor
#define ENB 10  // PWM pin for right motor
#define IN1 7   // Left motor direction 1
#define IN2 6   // Left motor direction 2
#define IN3 5   // Right motor direction 1
#define IN4 4   // Right motor direction 2
#define POT_X A0 // POT-HG for forward/backward
#define POT_Y A1 // POT-HG for left/right

void setup() {
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);
  pinMode(ENA, OUTPUT);
  pinMode(ENB, OUTPUT);
}

void loop() {
  int xVal = analogRead(POT_X); // Read forward/backward input
  int yVal = analogRead(POT_Y); // Read left/right input

  int motorSpeedX = map(abs(xVal - 512), 0, 512, 0, 255); // Map X-axis to speed
  int motorSpeedY = map(abs(yVal - 512), 0, 512, 0, 255); // Map Y-axis to speed

  // Forward/backward motion (both motors)
  if (xVal > 512) { // Forward
    digitalWrite(IN1, HIGH);
    digitalWrite(IN2, LOW);
    analogWrite(ENA, motorSpeedX); // Left motor PWM

    digitalWrite(IN3, HIGH);
    digitalWrite(IN4, LOW);
    analogWrite(ENB, motorSpeedX); // Right motor PWM
  } else if (xVal < 512) { // Backward
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, HIGH);
    analogWrite(ENA, motorSpeedX); // Left motor PWM

    digitalWrite(IN3, LOW);
    digitalWrite(IN4, HIGH);
    analogWrite(ENB, motorSpeedX); // Right motor PWM
  } else { // Stop
    analogWrite(ENA, 0);
    analogWrite(ENB, 0);
  }

  // Left/right turning adjustments
  if (yVal > 512) { // Turn right
    analogWrite(ENA, motorSpeedY); // Left motor keeps moving
    analogWrite(ENB, 0);          // Right motor stops
  } else if (yVal < 512) { // Turn left
    analogWrite(ENA, 0);          // Left motor stops
    analogWrite(ENB, motorSpeedY); // Right motor keeps moving
  }
}
