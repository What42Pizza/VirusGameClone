public class UGO {
  
  float XPos;
  float YPos;
  float XVel;
  float YVel;
  boolean ShouldBeRemoved = false;
  ArrayList <Codon> Codons;
  
  Cell PrevOccupiedCell = null;
  
  
  
  
  public UGO () {
    XPos = random(1);
    YPos = random(1);
    PrevOccupiedCell = GetCellAtPosition (XPos, YPos);
    XVel = random(0.00025, 0.0005) * RandomSign();
    YVel = random(0.00025, 0.0005) * RandomSign();
  }
  
  
  
  public UGO (float XPosIn, float YPosIn, ArrayList <Codon> CodonsIn) {
    XPos = XPosIn;
    YPos = YPosIn;
    Codons = CodonsIn;
    PrevOccupiedCell = GetCellAtPosition (XPos, YPos);
    XVel = random(0.00025, 0.0005) * RandomSign();
    YVel = random(0.00025, 0.0005) * RandomSign();
  }
  
  
  
  public UGO (float XPosIn, float YPosIn, float XVelIn, float YVelIn, ArrayList <Codon> CodonsIn) {
    XPos = XPosIn;
    YPos = YPosIn;
    XVel = XVelIn;
    YVel = YVelIn;
    Codons = CodonsIn;
    PrevOccupiedCell = GetCellAtPosition (XPos, YPos);
  }
  
  
  
  
  
  public void Draw() {
    
  }
  
  
  
  public void Update() {
    
    XPos += XVel + 1; // +1 is for correct negative world wrap
    YPos += YVel + 1;
    XPos %= 1;
    YPos %= 1;
    
    BounceOffCenterBlocks();
    
  }
  
  
  
  private void BounceOffCenterBlocks() {
    CenterBlock CurrOccupiedCenterBlock = GetCenterBlockAtPosition (XPos, YPos);
    if (CurrOccupiedCenterBlock != null) {
      CenterBlock PrevXBlock = GetCenterBlockAtPosition (XPos - XVel, YPos);
      if (PrevXBlock == null) XVel *= -1;
      CenterBlock PrevYBlock = GetCenterBlockAtPosition (XPos, YPos - YVel);
      if (PrevYBlock == null) YVel *= -1;
    }
  }
  
}
