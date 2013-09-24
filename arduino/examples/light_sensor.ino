const int num_leds = 2;
int times[num_leds];

void charge(int pin) {
  pinMode(pin, OUTPUT);
  pinMode(pin+1, OUTPUT);
  digitalWrite(pin, HIGH);
  digitalWrite(pin+1, LOW);
}

void discharge(int pin) {
  pinMode(pin, INPUT);
  digitalWrite(pin, LOW);
}

void light(int pin) {
  digitalWrite(pin+1, HIGH);
  digitalWrite(pin, LOW);
  pinMode(pin+1, OUTPUT);
  pinMode(pin, OUTPUT);
}

int maxidx(int vals[], int len) {
  int m = vals[1];
  int idx = 1;
  for(int i = 2; i < len; i++) {
    if(m < vals[i]) {
      idx = i;
      m = vals[i];
    }
  }
  
  return idx;
}

void setup() {
//  Serial.begin(115200);
}

void loop() {
  unsigned int len;
  unsigned int tot;
  unsigned int i = 1;

  for(int i = 1; i < num_leds; i++) {
    charge(i*2);
  }

  for(int i = 1; i < num_leds; i++) {
    discharge(i*2);
  }  

  for(len = 0, tot = 1; len < 3000000 && tot < num_leds; len++) {
    for(int i = 0; i < num_leds; i++) {
      if(digitalRead(i*2) == LOW) {
        times[i] = len;
//        Serial.print(i*2);
//        Serial.println(len);
        tot += 1;
      }
    }
  }

  int m = maxidx(times, num_leds);
//  Serial.println(" ");
//  Serial.println(m);
//  Serial.println(times[m]);
//  light(m);
  light(m*2);

  delayMicroseconds(1000);
}

