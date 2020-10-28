public class UGO extends Particle {
  
  
  
  
  
  // Vars
  
  ArrayList <Codon> Codons;
  Cell StartingCell;
  
  
  
  
  
  // Constructors
  
  /*
  public UGO (ArrayList <Codon> CodonsIn) {
    super(0);
    Codons = CodonsIn;
    StartingCell = GetCellAtPosition (XPos, YPos);
  }
  */
  
  public UGO (float XPosIn, float YPosIn, ArrayList <Codon> CodonsIn) {
    super (0, XPosIn, YPosIn, true);
    Codons = CodonsIn;
    StartingCell = GetCellAtPosition (XPos, YPos);
  }
  
  
  
  
  
  // Functions
  
  
  
  @Override
  
  public void Draw() {
    DrawCodons (Codons, XPos, YPos);
  }
  
  
  
  
  
  @Override
  
  public void Update() {
    
    XPos += XVel + 1; // +1 is for correct negative world wrap
    YPos += YVel + 1;
    XPos %= 1;
    YPos %= 1;
    
    Cell EnteredCell = GetCellAtPosition (XPos, YPos);
    if (EnteredCell != StartingCell) {
      InfectCell (EnteredCell);
      this.ShouldBeRemoved = true;
    }
    
    if (StartingCell != null)
      BounceWithinCell();
    
  }
  
  
  
  
  
  public void InfectCell (Cell CellToInfect) {
    
    int CellHandPos = CellToInfect.HandCodonPos;
    ArrayList <Codon> CodonsToInfect = CellToInfect.Codons;
    
    for (int i = Codons.size() - 1; i >= 0; i --) {
      Codon C = Codons.get(i);
      CodonsToInfect.add (CellHandPos, C);
    }
    
    CellToInfect.HandCodonPos += Codons.size();
    
  }
  
  
  
  
  
}
