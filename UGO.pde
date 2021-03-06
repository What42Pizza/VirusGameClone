public class UGO extends Particle {
  
  
  
  
  
  // Vars
  
  ArrayList <Codon> Codons;
  Cell StartingCell;
  boolean BounceInCell = true;
  
  
  
  
  
  // Constructors
  
  /*
  public UGO (ArrayList <Codon> CodonsIn) {
    super(0);
    Codons = CodonsIn;
    StartingCell = GetCellAtPosition (XPos, YPos);
  }
  */
  
  public UGO (float XPosIn, float YPosIn, ArrayList <Codon> CodonsIn, boolean BounceInCellIn) {
    super (0, XPosIn, YPosIn, true);
    Codons = CodonsIn;
    StartingCell = GetCellAtPosition (XPos, YPos);
    BounceInCell = BounceInCellIn;
  }
  
  public UGO (float XPosIn, float YPosIn, float XVelIn, float YVelIn, ArrayList <Codon> CodonsIn, boolean BounceInCellIn) {
    super (0, XPosIn, YPosIn, true);
    XVel = XVelIn;
    YVel = YVelIn;
    Codons = CodonsIn;
    StartingCell = GetCellAtPosition (XPos, YPos);
    BounceInCell = BounceInCellIn;
  }
  
  
  
  
  
  // Functions
  
  
  
  @Override
  
  public void Draw() {
    DrawCodons (Codons, XPos, YPos);
  }
  
  
  
  
  
  @Override
  
  public void Update() {
    if (StartingCell != null && StartingCell.ShouldBeRemoved) StartingCell = null;
    
    XPos += XVel + 1; // +1 is for correct negative world wrap
    YPos += YVel + 1;
    XPos %= 1;
    YPos %= 1;
    
    Cell EnteredCell = GetCellAtPosition (XPos, YPos);
    if (EnteredCell != StartingCell && EnteredCell != null && random(1) < UGO_Infect_Chance) {
      InfectCell (EnteredCell);
      this.ShouldBeRemoved = true;
    }
    
    if (StartingCell != null && EnteredCell == StartingCell && BounceInCell)
      BounceWithinCell();
    
    DamageTransitioningCells();
    BounceOffCenterBlocks();
    
  }
  
  
  
  
  
  public void InfectCell (Cell CellToInfect) {
    
    int CellInterpPos = CellToInfect.InterpCodonPos;
    ArrayList <Codon> CodonsToInfect = CellToInfect.Codons;
    
    for (int i = Codons.size() - 1; i >= 0; i --) {
      Codon C = Codons.get(i);
      CodonsToInfect.add (CellInterpPos, C);
    }
    
    CellToInfect.InterpCodonPos += Codons.size();
    CellToInfect.SetAsModified();
    CellToInfect.CodonsChanged = true;
    
  }
  
  
  
  
  
}
