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
  float TextSize = max (width / 100, 15);
  textSize (TextSize);
  text ("FPS: " + (round (frameRate * 100) / 100.0), 5, TextSize);
  text ("Millis: " + (millis() - StartingMillis), 5, TextSize * 2);
}





void DrawCodons (ArrayList <Codon> CodonsIn, float XPos, float YPos) {
  fill (0);
  int Num = CodonsIn.size();
  for (int i = 0; i < Num; i ++) {
    Codon C = CodonsIn.get(i);
    fill (0);
    ellipse (XPos, YPos, CellWidth * 0.09, CellHeight * 0.09);
    ShapeRenderer.Render (Codon_Shape , XPos, YPos, (float) i / Num * PI * 2, Num / 3.9, 1);
    fill (GetColorFromCodon2(C));
    ShapeRenderer.Render (Codon2_Shape, XPos, YPos, (float) i / Num * PI * 2, Num / 4.0 / C.Health, 1);
    fill (GetColorFromCodon1(C));
    ShapeRenderer.Render (Codon1_Shape, XPos, YPos, (float) i / Num * PI * 2, Num / 4.0 / C.Health, 1);
  }
}
