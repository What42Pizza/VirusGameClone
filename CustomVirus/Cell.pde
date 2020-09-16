public static class HandPositions {
  public final static int Inward = 0;
  public final static int Outward = 1;
}



public class Cell {
  
  
  
  float XPos;
  float YPos;
  float XMid;
  float YMid;
  int CellIndex = -1;
  
  float WallHealth = 100;
  float Energy = 100;
  ArrayList <Codon> Codons;
  int[] CodonMemory = new int [0];
  
  float HandRotation = 0;
  int HandCodonPos = 0;
  float HandCenterRotation = 0;
  float TargetHandCenterRotation = 0;
  float InterpRotation = 0;
  int InterpCodonPos = 0;
  int InterpColorChange = 255;
  
  int HandPosition = HandPositions.Outward;
  ArrayList <float[]> HandLines = new ArrayList <float[]> ();
  
  float WallThickness;
  
  boolean Alive = true;
  boolean ShouldBeRemoved = false;
  
  
  
  
  public Cell (int CellX, int CellY) {
    XPos = CellX * CellWidth;
    YPos = CellY * CellHeight;
    XMid = XPos + CellWidth / 2;
    YMid = YPos + CellHeight / 2;
    Codons = ProcessCodonInformation (Starting_Codons);
  }
  
  
  
  
  
  public void Draw() {
    if (!IsOnScreen()) return;
    DrawHand();
    DrawHandTrack();
    DrawInterpHand();
    DrawCodons (Codons, XMid, YMid);
    WallThickness = CellWidth * 0.1 * WallHealth * 0.005;
    DrawWalls();
    DrawHandLines();
  }
  
  
  
  private boolean IsOnScreen() {
    return
      (XPos + CellWidth ) * Camera.Zoom + Camera.XPos > 0      &&
      (XPos)              * Camera.Zoom + Camera.XPos < width  &&
      (YPos + CellHeight) * Camera.Zoom + Camera.YPos > 0      &&
      (YPos)              * Camera.Zoom + Camera.YPos < height
   ;
  }
  
  
  
  private void DrawHand() {
    fill (Color_Cell_Hand);
    ShapeRenderer.Render (CellHandShape, XMid, YMid, HandRotation, HandCenterRotation);
  }
  
  
  
  private void DrawHandTrack() {
    noFill();
    stroke (Color_Cell_Hand_Track);
    strokeWeight (0.00125);
    ellipse (XPos + CellWidth * 0.5, YPos + CellHeight * 0.5, CellWidth * 0.65, CellHeight * 0.65);
    noStroke();
  }
  
  
  
  private void DrawInterpHand() {
    fill (Color_Cell_Interpreter_Hand, InterpColorChange); // This makes the inter hand lighter by making it transparent, which isn't great
    stroke (Color_Cell_Interpreter_Hand_Edge, InterpColorChange);
    strokeWeight (Cell_Interpreter_Hand_Edge_Size);
    ShapeRenderer.Render (InterpShape, XMid, YMid, InterpRotation, Codons.size() / 4.0, 1);
    noStroke();
  }
  
  
  
  private void DrawWalls() {
    float Buffer = Render_Buffer_Extension;
    float DBuffer = Buffer * 2;
    fill (Color_Cell_Wall);
    noStroke();
    rect (XPos - Buffer, YPos - Buffer, CellWidth + DBuffer, WallThickness + DBuffer); // Top
    rect (XPos + CellWidth - WallThickness - Buffer, YPos - Buffer, WallThickness + DBuffer, CellHeight + DBuffer); // Right
    rect (XPos - Buffer, YPos + CellHeight - WallThickness - Buffer, CellWidth + DBuffer, WallThickness + DBuffer); // Bottom
    rect (XPos - Buffer, YPos - Buffer, WallThickness + DBuffer, CellHeight + DBuffer); // Left
  }
  
  
  
  private void DrawHandLines() {
    strokeWeight (Cell_Hand_Lines_Size);
    float[] HandPoint = GetHandPoint();
    for (int i = 0; i < HandLines.size(); i++) {
      float[] Line = HandLines.get(i);
     // stroke (lerpColor (color (255), Color_Cell_Hand_Lines, Line[2]));
     stroke (Color_Cell_Hand_Lines, Line[2] * 256);
      line (HandPoint[0], HandPoint[1], Line[0], Line[1]);
      Line[2] *= 0.95;
      if (Line[2] < 0.01) {
        HandLines.remove(i);
        i --;
      }
    }
    noStroke();
  }
  
  
  
  private float[] GetHandPoint() {
    float[] HandTip = new float[] {CellHandShape[2][0], CellHandShape[2][1]};
    //float[] HandTip = CellHandShape[2].clone(); // IDK how well I can trust .clone()
    HandTip[0] -= CellHandShape[0][0]; // Move hand to center
    HandTip[1] -= CellHandShape[0][1];
    HandTip = ShapeRenderer.RotateVertex (HandTip, HandCenterRotation); // Rotate around center
    HandTip[0] += CellHandShape[0][0]; // Move hand to center
    HandTip[1] += CellHandShape[0][1];
    HandTip = ShapeRenderer.RotateVertex (HandTip, HandRotation); // Rotate to hand trach position
    return new float[] {HandTip[0] + XMid, HandTip[1] + YMid};
  }
  
  
  
  
  
  
  
  public void Update() {
    MoveHands();
    InterpColorChange = InterpColorChange + (int) ((255 - InterpColorChange) * 0.1);
    if (Energy > 0 && (frameCount % FrameRate) == 0)
      AdvanceInterpHand();
    if (Energy > 0 && (frameCount % FrameRate) == FrameRate/2) {
      Interpreter.InterpretCodon (Codons.get(InterpCodonPos), this, InterpCodonPos);
      InterpColorChange = 63;
    }
  }
  
  
  
  private void MoveHands() {
    HandRotation = MoveAngleTowards (HandRotation, ((float) HandCodonPos / Codons.size() * PI * 2), 0.1);
    HandCenterRotation = MoveAngleTowards (HandCenterRotation, TargetHandCenterRotation, 0.1);
    InterpRotation = MoveAngleTowards (InterpRotation, ((float) InterpCodonPos / Codons.size() * PI * 2), 0.1);
  }
  
  
  
  private float MoveAngleTowards (float AngleIn, float TargetAngle, float MoveAmount) { // This will allow rotating from near 2pi to near 0 and vise versa
    float AngleChange = (TargetAngle - AngleIn);
    float AngleChangePlusRad = (TargetAngle + PI * 2 - AngleIn);
    float AngleChangeMinusRad = (TargetAngle - PI * 2 - AngleIn);
    return (AngleIn + AbsMin (AngleChange, AngleChangePlusRad, AngleChangeMinusRad) * MoveAmount) % (PI * 2);
  }
  
  
  
  private float AbsMin (float A, float B, float C) { // This works just like min(), but compares (but doesn't return) the absolute values of the inputs
    if (abs(A) < abs(B)) {
      return abs(A) < abs(C) ? A : C;
    } else {
      return abs(B) < abs(C) ? B : C;
    }
  }
  
  
  
  private void AdvanceInterpHand() {
    InterpCodonPos ++;
    InterpCodonPos %= Codons.size();
  }
  
  
  
  
  
  
  
  
  
  
  public void DamageWall() {
    WallHealth -= Particle_Wall_Damage;
    if (WallHealth <= 0) Die();
  }
  
  
  
  private void Die(){
    if (!Alive) return;
    Alive = false;
    ShouldBeRemoved = true;
    ReplaceCodonsWithWaste();
  }
  
  private void ReplaceCodonsWithWaste() {
    int Num = Codons.size();
    for (int i = 0; i < Num; i ++) {
      Codon C = Codons.get(i);
      float[] WastePos = GetCodonPosition(i);
      WasteParticles.add (new Particle (ParticleTypes.Waste, WastePos[0], WastePos[1], true));
    }
  }
  
  
  
  public float[] GetCodonPosition (int CodonI) {
    float Rot = (float) CodonI / Codons.size() * PI * 2;
    return new float[] {
      XMid + sin(Rot) * CellWidth * 0.1,
      YMid + cos(Rot) * CellHeight * 0.1
    };
  }
  
  
  
  public void GainEnergy() {
    Energy = Energy + (100 - Energy) * Cell_Energy_Gain_Percent;
  }
  
  
  
  public void DrainEnergy() {
    Energy = 100 - (100 - Energy) / (1 - Cell_Energy_Drain_Percent); // GainEnergy() w/ X Gain_Percent then DrainEnergy() w/ X Drain_Percent returns energy to starting amount
  }
  
  
  
  public void RepairWall() {
    float WallHealthGain = (100 - WallHealth) * Cell_Wall_Health_Gain_Percent;
    WallHealth =+ WallHealthGain;
    Energy = max (Energy - (WallHealthGain * Cell_Wall_Health_Gain_Cost), 0);
  }
  
  
  
  public void DigestWall(){
    float WallHealthDrain = WallHealth - (100 - (100 - WallHealth) / (1 - Cell_Wall_Health_Drain_Percent));
    WallHealth -= WallHealthDrain;
    Energy = min (Energy + (WallHealthDrain * Cell_Wall_Health_Drain_Cost), 100);
  }
  
  
  
  public void DigestCodon (int CodonI) {
    Codon C = Codons.get(CodonI);
    C.Health -= Cell_Codon_Health_Drain_Percent;
    if (C.Health <= 0) {
      C.Info = new int[] {Codon1_None, Codon2_None};
      C.Health = 1;
    }
  }
  
  
  
  public ArrayList <Codon> GetRGLFromCodon (Codon C) {
    ArrayList <Codon> Output = new ArrayList <Codon> ();
    for (int i = C.Info[2]; i < C.Info[3] + 1; i ++) {
      Output.add (Codons.get (i % Codons.size()));
    }
    return Output;
  }
  
  
  
  public void DrawLineFromHandTo (float LineX, float LineY) {
    HandLines.add (new float[] {LineX, LineY, 1});
  }
  
  
  
  public void DrawLinesFromHandToWall() {
    DrawLineFromHandTo (XPos            , YPos             );
    DrawLineFromHandTo (XPos + CellWidth, YPos             );
    DrawLineFromHandTo (XPos + CellWidth, YPos + CellHeight);
    DrawLineFromHandTo (XPos            , YPos + CellHeight);
  }
  
  
  
  public boolean IsInward() {
    return HandPosition == HandPositions.Inward;
  }
  
  public boolean IsOutward() {
    return HandPosition == HandPositions.Outward;
  }
  
  
  
}
