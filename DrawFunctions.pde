void DrawBackground() {
  
  background (191); // 3/4 of 256 - 1 // Outer background
  fill (255);
  pushMatrix();
  translate (Camera.XPos, Camera.YPos); // Inner background
  scale (Camera.Zoom);
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



void DrawFPSAndMillis (int UpdateMillis, int DrawMillis, int TotalMillis) {
  if (!(Debug_Show_FPS || Debug_Show_Millis)) return;
  
  float TextSize = max (width / 100, 15);
  float YOffset = height * 0.05;
  fill (0);
  textSize (TextSize);
  textAlign (LEFT, TOP);
  
  if (Debug_Show_FPS) {
    text ("FPS: " + (round (frameRate * 100) / 100.0), 5, YOffset);
  } else {
    YOffset -= TextSize; // If rendering Millis but not FPS, move Millis up
  }
  if (Debug_Show_Millis) {
    text ("Update millis: " + UpdateMillis, 5, TextSize   + YOffset);
    text ("Draw millis: "   + DrawMillis  , 5, TextSize*2 + YOffset);
    text ("Total millis: "  + TotalMillis , 5, TextSize*3 + YOffset);
  }
  
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
