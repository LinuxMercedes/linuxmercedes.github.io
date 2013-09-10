const int therm = 0;

void setup() {
  Serial.begin(115200);
}

void loop() {
  int val = analogRead(therm);
  
  Serial.print(val); 
  Serial.print(" ");
  Serial.println(val * (5.0/1023));
}

