public static class HandPositions {
  public final static int Inward = 0;
  public final static int Outward = 1;
}



public class Cell {
  
  
  
  float XPos;
  float YPos;
  float XMid;
  float YMid;
  int ID = -1;
  
  float WallHealth = 100;
  float Energy = 100;
  ArrayList <Codon> Codons;
  int[] CodonMemory = new int [0];
  boolean CodonsChanged = false; // Used in GUIFunctions to know when to redo GUI elements
  
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
  boolean Modified = false;
  boolean ShouldBeRemoved = false;
  
  
  
  
  public Cell (int CellX, int CellY) {
    XPos = CellX * CellWidth;
    YPos = CellY * CellHeight;
    XMid = XPos + CellWidth / 2;
    YMid = YPos + CellHeight / 2;
    Codons = ProcessInfoIntoCodons (Starting_Codons);
  }
  
  
  
  
  
  public void Draw() {
    if (!IsOnScreen()) return;
    DrawHand();
    DrawHandTrack();
    DrawInterpHand();
    DrawCodons (Codons, XMid, YMid);
    if (Energy > 0) DrawEnergySymbol();
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
    ShapeRenderer.Render (Cell_Hand_Shape, XMid, YMid, HandRotation, HandCenterRotation);
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
    ShapeRenderer.Render (Interpreter_Shape, XMid, YMid, InterpRotation, Codons.size() / 4.0, 1);
    noStroke();
  }
  
  
  
  private void DrawEnergySymbol() {
    fill (Color_Cell_Energy_Symbol);
    ShapeRenderer.Render (Cell_Energy_Symbol, XMid, YMid, new float[] {100.0 / Energy, 100.0 / Energy});
  }
  
  
  
  private void DrawWalls() {
    float Buffer = Render_Buffer_Extension;
    float DBuffer = Buffer * 2;
    fill (Color_Cell_Wall);
    noStroke();
    rect (XPos                             - Buffer, YPos                              - Buffer, CellWidth     + DBuffer, WallThickness + DBuffer); // Top
    rect (XPos + CellWidth - WallThickness - Buffer, YPos                              - Buffer, WallThickness + DBuffer, CellHeight    + DBuffer); // Right
    rect (XPos                             - Buffer, YPos + CellHeight - WallThickness - Buffer, CellWidth     + DBuffer, WallThickness + DBuffer); // Bottom
    rect (XPos                             - Buffer, YPos                              - Buffer, WallThickness + DBuffer, CellHeight    + DBuffer); // Left
  }
  
  
  
  private void DrawHandLines() {
    strokeWeight (Cell_Hand_Lines_Size);
    float[] HandPoint = GetHandPoint();
    for (int i = 0; i < HandLines.size(); i++) {
      float[] Line = HandLines.get(i);
     // stroke (lerpColor (color (255), Color_Cell_Hand_Lines, Line[2]));
     stroke (Color_Cell_Hand_Lines, Line[2] * 256);
     line (HandPoint[0], HandPoint[1], Line[0], Line[1]);
    }
    noStroke();
  }
  
  
  
  public float[] GetHandPoint() {
    float[] HandTip = new float[] {Cell_Hand_Shape[2][0], Cell_Hand_Shape[2][1]};
    //float[] HandTip = CellHandShape[2].clone(); // IDK how well I can trust .clone()
    HandTip[0] -= Cell_Hand_Shape[0][0]; // Move hand to center
    HandTip[1] -= Cell_Hand_Shape[0][1];
    HandTip = ShapeRenderer.RotateVertex (HandTip, HandCenterRotation); // Rotate around center
    HandTip[0] += Cell_Hand_Shape[0][0]; // Move hand to center
    HandTip[1] += Cell_Hand_Shape[0][1];
    HandTip = ShapeRenderer.RotateVertex (HandTip, HandRotation); // Rotate to hand trach position
    return new float[] {HandTip[0] + XMid, HandTip[1] + YMid};
  }
  
  
  
  
  
  
  
  
  
  
  public void Update() {
    //if (true) return; // Use this to stop updates
    CodonsChanged = false;
    MoveHands();
    DamageCodons();
    LoseEnergy();
    InterpColorChange = InterpColorChange + (int) ((255 - InterpColorChange) * 0.1);
    if (Energy > 0 && (frameCount % 60) == 0) // I know locking it at 60 isn't great, but nothing else responds to framerate so I guess that's the route I'm going
      AdvanceInterpHand();
    if (Energy > 0 && (frameCount % 60) == 30) {
      Interpreter.InterpretCodon (Codons.get(InterpCodonPos), this, InterpCodonPos);
      InterpColorChange = 63;
    }
    UpdateHandLines();
  }
  
  
  
  private void MoveHands() {
    HandRotation = MoveAngleTowards (HandRotation, ((float) HandCodonPos / Codons.size() * PI * 2), 0.1);
    HandCenterRotation = MoveAngleTowards (HandCenterRotation, TargetHandCenterRotation, 0.1);
    InterpRotation = MoveAngleTowards (InterpRotation, ((float) InterpCodonPos / Codons.size() * PI * 2), 0.125);
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
  
  
  
  private void DamageCodons() {
    for (Codon C : Codons) {
      C.Health -= random (Cell_Codon_Damage_Percent_Low / 250.0, Cell_Codon_Damage_Percent_High / 250.0);
      if (C.Health <= 0) {
        C.Info = new int[] {Codon1_None, Codon2_None};
        C.Health = 1;
      }
    }
  }
  
  
  
  private void LoseEnergy() {
    Energy = max (Energy - Cell_Energy_Loss_Percent / 50.0, 0);
  }
  
  
  
  private void AdvanceInterpHand() {
    InterpCodonPos ++;
    InterpCodonPos %= Codons.size();
  }
  
  
  
  private void UpdateHandLines() {
    for (int i = 0; i < HandLines.size(); i ++) {
      float[] Line = HandLines.get(i);
      Line[2] *= 0.9;
      if (Line[2] < 0.01) {
        HandLines.remove(i);
        i --;
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  public void DamageWall() {
    WallHealth -= Particle_Wall_Damage;
    if (WallHealth <= 0) Die();
  }
  
  
  
  private void Die(){
    if (!Alive) return;
    Alive = false;
    AliveCells --;
    DeadCells ++;
    if (Modified) ModifiedCells --;
    ShouldBeRemoved = true;
    ReplaceCodonsWithWaste();
    
    if (Debug_Explain_Cell_Death) {
      println ();
      println ();
      println ();
      println ("Cell " + ID + " has died.");
      println ("Wall health: " + WallHealth);
      println ("Energy: " + Energy);
      println ("Codon healths:");
      for (Codon C : Codons)
        println ("    " + C.Health);
      println ();
      println ("Food Particles: " + FoodParticles.size());
      println ("Waste Particles: " + WasteParticles.size());
      println ("UGOs: " + UGOs.size());
      println ();
      println ("Cells still alive: " + AliveCells);
      println ("Cells dead: " + DeadCells);
      Paused = true;
    }
    
  }
  
  private void ReplaceCodonsWithWaste() {
    int Num = Codons.size();
    for (int i = 0; i < Num; i ++) {
      Codon C = Codons.get(i);
      float[] WastePos = GetCodonPosition(i);
      WasteParticles.add (new Particle (ParticleTypes.Waste, WastePos[0], WastePos[1], true));
    }
  }
  
  
  
  public float[] GetCodonPosition (int CodonIndex) {
    float Rot = (float) CodonIndex / Codons.size() * PI * 2;
    return new float[] {
      XMid + sin(Rot) * CellWidth * 0.1,
      YMid - cos(Rot) * CellHeight * 0.1
    };
  }
  
  
  
  public void GainEnergy() {
    Energy = Energy + (100 - Energy) * Cell_Energy_Gain_Percent;
  }
  
  
  
  public void DrainEnergy() {
    Energy = 100 - (100 - Energy) / (1 - Cell_Energy_Drain_Percent); // GainEnergy() w/ X Gain_Percent then DrainEnergy() w/ X Drain_Percent returns energy to starting amount
  }
  
  public void DrainEnergyFromCodons (int NumOfCodons) {
    Energy = max (Energy - NumOfCodons * Cell_Codon_Write_Cost, 0);
  }
  
  
  
  public void RepairWall() {
    float WallHealthGain = (100 - WallHealth) * Cell_Wall_Health_Gain_Percent;
    WallHealth += WallHealthGain;
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
      CodonsChanged = true;
    }
  }
  
  
  
  public void SetCodons (ArrayList <Codon> NewCodons) {
    Codons = NewCodons;
    DrainEnergyFromCodons (NewCodons.size());
  }
  
  
  
  public void ReplaceCodons (int StartPos, ArrayList <Codon> NewCodons) {
    for (int i = 0; i < NewCodons.size(); i ++) {
      Codons.remove (StartPos + i);
      Codons.add (StartPos + i, NewCodons.get(i));
    }
    DrainEnergyFromCodons (NewCodons.size());
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
  
  
  
  public void DrawLineFromHandToCodon (int CodonIndex) {
    float[] CodonPos = GetCodonPosition (CodonIndex);
    DrawLineFromHandTo (CodonPos[0], CodonPos[1]);
  }
  
  
  
  public boolean HandIsInward() {
    return HandPosition == HandPositions.Inward;
  }
  
  public boolean HandIsOutward() {
    return HandPosition == HandPositions.Outward;
  }
  
  
  
  public void MoveHandInward() {
    HandPosition = HandPositions.Inward;
    TargetHandCenterRotation = PI;
  }
  
  public void MoveHandOutward() {
    HandPosition = HandPositions.Outward;
    TargetHandCenterRotation = 0;
  }
  
  
  
}
