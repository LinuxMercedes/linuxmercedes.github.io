const int button = 2;
const int pot = 0;
const int base = 8;
int pin = 0;
int buttonval = HIGH;

void setup() {
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
  
  pinMode(button, INPUT);
  digitalWrite(button, HIGH);
}

void loop() {
  int val = digitalRead(button);
  
  if(val != buttonval && val == LOW) {
    pin = (pin + 1) % 4; // pin will go 0, 1, 2, 3, 0, 1, ...
  }
  
  buttonval = val;
  
  if(pin > 0) {
    val = analogRead(pot);
    analogWrite(base + pin, val / 4);
  }
}

