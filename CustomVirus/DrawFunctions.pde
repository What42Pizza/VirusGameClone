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





void DrawCodons (ArrayList <Codon> CodonsIn, float XPos, float YPos) {
  fill (0);
  int Num = CodonsIn.size();
  for (int i = 0; i < Num; i ++) {
    Codon C = CodonsIn.get(i);
    fill (0);
    ellipse (XPos, YPos, CellWidth * 0.09, CellHeight * 0.09);
    ShapeRenderer.Render (CodonShape , XPos, YPos, (float) i / Num * PI * 2, Num / 3.9);
    fill (GetColorFromCodon2(C));
    ShapeRenderer.Render (Codon2Shape, XPos, YPos, (float) i / Num * PI * 2, Num / 4.0);
    fill (GetColorFromCodon1(C));
    ShapeRenderer.Render (Codon1Shape, XPos, YPos, (float) i / Num * PI * 2, Num / 4.0);
  }
}



color GetColorFromCodon1 (Codon CodonIn) {
  switch (CodonIn.Info[0]) {
    case (Codon1_None    ): return Color_Codon1_None    ;
    case (Codon1_Digest  ): return Color_Codon1_Digest  ;
    case (Codon1_Remove  ): return Color_Codon1_Remove  ;
    case (Codon1_MoveHand): return Color_Codon1_MoveHand;
    case (Codon1_Read    ): return Color_Codon1_Read    ;
    case (Codon1_Write   ): return Color_Codon1_Write   ;
  }
  return color (255, 0, 255);
}



color GetColorFromCodon2 (Codon CodonIn) {
  switch (CodonIn.Info[1]) {
    case (Codon2_None           ): return Color_Codon2_None            ;
    case (Codon2_Food           ): return Color_Codon2_Food            ;
    case (Codon2_Waste          ): return Color_Codon2_Waste           ;
    case (Codon2_Wall           ): return Color_Codon2_Wall            ;
    case (Codon2_WeakestLocation): return Color_Codon2_WeakestLocation ;
    case (Codon2_Inward         ): return Color_Codon2_Inward          ;
    case (Codon2_Outward        ): return Color_Codon2_Outward         ;
    case (Codon2_RGL            ): return Color_Codon2_RGL             ;
  }
  return color (255, 0, 255);
}
