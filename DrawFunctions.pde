void DrawBackground() {
  
  background (191); // 3/4 * 256 - 1 // Outer background
  
  pushMatrix();
  translate(Camera.XPos, Camera.YPos); // Inner background
  scale (Camera.Zoom);
  fill (255);
  rect(0, 0, 1, 1);
  popMatrix();
  
}



void DrawFoodParticles() {
  noStroke();
  for (Particle F : FoodParticles) {
    F.Draw();
  }
}



void DrawWasteParticles() {
  noStroke();
  for (Particle W : WasteParticles) {
    W.Draw();
  }
}



void DrawUGOs() {
  for (UGO UGO : UGOs) {
    UGO.Draw();
  }
}



void DrawCells() {
  for (Cell C : Cells) {
    C.Draw();
  }
}



void DrawCenterBlocks() {
  for (CenterBlock C : CenterBlocks) {
    C.Draw();
  }
}



void DrawFPS (int StartingMillis) {
  fill (0);
  float TextSize = width / 100;
  textSize (TextSize);
  text ("FPS: " + (round (frameRate * 100) / 100.0), 5, TextSize);
  text ("Millis: " + (millis() - StartingMillis), 5, TextSize * 2);
}
