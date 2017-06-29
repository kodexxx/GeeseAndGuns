const char* key = "FPGujAxsR4vQ9nvw";
int U1, U2;
void setup() {
  Serial.begin(9600);

}

bool canPress = true;

void loop() {
  if (digitalRead(7) == 1 && canPress == true) {
    canPress = false;
    Serial.println("bleed");
    delay(75);
    U1 = analogRead(4);
    delay(95);
    U2 = analogRead(4);
    Serial.print(U1);
    Serial.print(" ");
    Serial.print(U2);
    Serial.println();
  }
  else if (digitalRead(7) == 0) {
    canPress = true;
  }

  delay(10);
  
}
