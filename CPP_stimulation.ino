// CPP Optogenetics stimulation

#define instructionPin 6
#define stimulationPin 13

void setup() {
  pinMode(instructionPin,INPUT);   // Receives inputs from Bonsai-connected Arduino
  pinMode(stimulationPin,OUTPUT); // Trigger Output for the Laser
  Serial.begin(57600);
}

void loop() {

  // 20 Hz, 5ms pulses
  while (digitalRead(instructionPin) == HIGH){
    digitalWrite(stimulationPin, HIGH);   // turn the Laser on 
    delay(5);                 // wait for 5 ms. Change this value to change pulse duration
    digitalWrite(stimulationPin, LOW);    // turn the Laser off
    delay(45);                // wait for 45 ms. Change this value to change pulse frequency
  }
  
  // Laser is off otherwise
  digitalWrite(stimulationPin, LOW); 

}
