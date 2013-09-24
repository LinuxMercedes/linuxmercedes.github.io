//Set LED brightness between 0 and 11
const int led = 3; //must be on a PWM output
int brightness = 0;

void setup() {
	pinMode(led, OUTPUT);
	Serial.begin(115200);
}

void loop() {
	if(Serial.available() > 0) { // Check if serial data is in the input buffer
		int val = Serial.parseInt(); // Convert it to an integer
		brightness = val * ( 255.0 / 11); //Scale it to adjust for PWM output
	}

	analogWrite(led, brightness);
}

