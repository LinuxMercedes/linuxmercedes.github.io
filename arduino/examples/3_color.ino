const int red = 9;
const int green = 10;
const int blue = 11;
const int redval = 128; 
const int greenval = 64;
const int blueval = 64;

void setup() {
  pinMode(red, OUTPUT);
  pinMode(green, OUTPUT);
  pinMode(blue, OUTPUT);
}

void loop() {
  analogWrite(red, redval);
  analogWrite(green, greenval);
  analogWrite(blue, blueval);
}

