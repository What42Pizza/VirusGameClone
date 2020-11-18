// Vars

boolean MakingUGO = false; // Updated in GUIFunctions





// Functions



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



void UpdateUGOs(){
  for (int i = 0; i < UGOs.size(); i ++) {
    UGO U = UGOs.get(i);
    U.Update();
    if (U.ShouldBeRemoved) {
      UGOs.remove(i);
      i --;
    }
  }
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
