// Vars



boolean MakingUGO = false; // Updated in GUIFunctions

boolean UpdateFunctions_PrevMousePressed = false;
int UpdateFunctions_StartMouseX = 0;
int UpdateFunctions_StartMouseY = 0;
float UpdateFunctions_StartCameraXPos = 0;
float UpdateFunctions_StartCameraYPos = 0;





// Functions



void UpdateFunctions_UpdateInputs() {
  
  if (mousePressed && !UpdateFunctions_PrevMousePressed) UpdateFunctions_StartMouseDrag();
  
  if (mousePressed) {
    if (MakingUGO) {
      
    } else {
      if (!GUIFunctions_MouseIsOverGUI()) MoveCameraToMouse();
    }
  }
  
  if (InputFunctions_KeyJustPressed(' ')) Paused = !Paused;
  
  if (Keys['w']) Camera.YPos += Camera_Speed;
  if (Keys['a']) Camera.XPos += Camera_Speed;
  if (Keys['s']) Camera.YPos -= Camera_Speed;
  if (Keys['d']) Camera.XPos -= Camera_Speed;
  
}



void UpdateFunctions_StartMouseDrag() {
  UpdateFunctions_StartMouseX = mouseX;
  UpdateFunctions_StartMouseY = mouseY;
  UpdateFunctions_StartCameraXPos = Camera.XPos;
  UpdateFunctions_StartCameraYPos = Camera.YPos;
}



void MoveCameraToMouse() {
  Camera.XPos = UpdateFunctions_StartCameraXPos + (mouseX - UpdateFunctions_StartMouseX);
  Camera.YPos = UpdateFunctions_StartCameraYPos + (mouseY - UpdateFunctions_StartMouseY);
}



void UpdateFunctions_UpdateFoodParticles() {
  
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



void UpdateFunctions_UpdateWasteParticles() {
  
  while (WasteParticles.size() < Num_Of_Waste_Particles) WasteParticles.add (new Particle (ParticleTypes.Waste));
  
  if (WasteParticles.size() > Num_Of_Waste_Particles) {                                   // If there are too many waste particles (which could kill cells)
    Particle ParticleToRemove = WasteParticles.get((int) random (WasteParticles.size())); // Take random waste particle
    while (ParticleToRemove.IsInCell()) ParticleToRemove = WasteParticles.get((int) random (WasteParticles.size())); // Take one that isn't in a cell
    ParticleToRemove.Disapearing = true;                                                                             // Remove it
  }
  
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



void UpdateFunctions_UpdateUGOs(){
  for (int i = 0; i < UGOs.size(); i ++) {
    UGO U = UGOs.get(i);
    U.Update();
    if (U.ShouldBeRemoved) {
      UGOs.remove(i);
      i --;
    }
  }
}



void UpdateFunctions_UpdateCells() {
  for (int i = 0; i < Cells.size(); i ++) {
    Cell C = Cells.get(i);
    C.Update();
    if (C.ShouldBeRemoved) {
      Cells.remove(i);
      i --;
    }
  }
}



void UpdateFunctions_UpdateKeys() {
  arrayCopy (Keys, PrevKeys); // This does PrevKeys = Keys;
  UpdateFunctions_PrevMousePressed = mousePressed;
}
