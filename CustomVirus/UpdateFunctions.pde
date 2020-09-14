boolean MakingUGO = false;

boolean PrevMousePressed = false;
int StartMouseX = 0;
int StartMouseY = 0;
float StartCameraXPos = 0;
float StartCameraYPos = 0;



void UpdateInputs() {
  
  if (mousePressed && !PrevMousePressed) MouseJustPressed();
  
  if (mousePressed) {
    if (MakingUGO) {
      
    } else {
      MoveCameraToMouse();
    }
  }
  
  if (KeyJustPressed(' ')) Paused = !Paused;
  
  if (Keys['w']) Camera.YPos += Camera_Speed;
  if (Keys['a']) Camera.XPos += Camera_Speed;
  if (Keys['s']) Camera.YPos -= Camera_Speed;
  if (Keys['d']) Camera.XPos -= Camera_Speed;
  
}



void MouseJustPressed() {
  StartMouseX = mouseX;
  StartMouseY = mouseY;
  StartCameraXPos = Camera.XPos;
  StartCameraYPos = Camera.YPos;
}



void MoveCameraToMouse() {
  Camera.XPos = StartCameraXPos + (mouseX - StartMouseX);
  Camera.YPos = StartCameraYPos + (mouseY - StartMouseY);
}



void UpdateFoodParticles() {
  
  while (FoodParticles.size() < Num_Of_Food_Particles) FoodParticles.add (new Particle (ParticleTypes.Food));
  
  for (int i = 0; i < FoodParticles.size(); i ++) {
    Particle F = FoodParticles.get(i);
    F.Update();
    if (F.Age > Particle_Removal_Age && random(1) < 0.01) F.Disapearing = true;
    if (F.ShouldBeRemoved) {
      FoodParticles.remove(i);
      i --;
    }
  }
}



void UpdateWasteParticles() {
  
  while (WasteParticles.size() < Num_Of_Waste_Particles) WasteParticles.add (new Particle (ParticleTypes.Waste));
  
  for (int i = 0; i < WasteParticles.size(); i ++) {
    Particle W = WasteParticles.get(i);
    W.Update();
    if (W.Age > Particle_Removal_Age && random(1) < 0.01) W.Disapearing = true;
    if (W.ShouldBeRemoved) {
      WasteParticles.remove(i);
      i --;
    }
  }
}



void UpdateUGOs(){
  
}



void UpdateCells() {
  for (int i = 0; i < Cells.size(); i ++) {
    Cell C = Cells.get(i);
    C.Update();
    if (C.ShouldBeRemoved) {
      Cells.remove(i);
      i --;
    }
  }
}



void UpdateKeys() {
  arrayCopy (Keys, PrevKeys); // This does PrevKeys = Keys;
  PrevMousePressed = mousePressed;
}
