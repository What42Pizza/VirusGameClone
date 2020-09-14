public static class ParticleTypes {
  public static final int Food = 1;
  public static final int Waste = 2;
}



public class Particle {
  
  float XPos;
  float YPos;
  float XVel;
  float YVel;
  int Age = 0;
  int ParticleType;
  
  boolean Appearing = true;
  boolean Disapearing = false;
  boolean ShouldBeRemoved = false;
  float Opacity = 0;
  
  Cell PrevOccupiedCell = null;
  
  
  
  
  public Particle (int ParticleTypeIn) {
    ParticleType = ParticleTypeIn;
    XPos = random(1);
    YPos = random(1);
    PrevOccupiedCell = GetCellAtPosition (XPos, YPos);
    XVel = random(0.00025, 0.0005) * RandomSign();
    YVel = random(0.00025, 0.0005) * RandomSign();
    ShouldBeRemoved = GetCellAtPosition (XPos, YPos) != null || GetCenterBlockAtPosition (XPos, YPos) != null; // Destroy particle if strating in cell
  }
  
  
  
  public Particle (int ParticleTypeIn, boolean OverrideCellCheck) {
    ParticleType = ParticleTypeIn;
    XPos = random(1);
    YPos = random(1);
    PrevOccupiedCell = GetCellAtPosition (XPos, YPos);
    XVel = random(0.00025, 0.0005) * RandomSign();
    YVel = random(0.00025, 0.0005) * RandomSign();
    ShouldBeRemoved = !OverrideCellCheck && (GetCellAtPosition (XPos, YPos) != null || GetCenterBlockAtPosition (XPos, YPos) != null); // Destroy particle if strating in cell
  }
  
  
  
  public Particle (int ParticleTypeIn, float XPosIn, float YPosIn, boolean OverrideCellCheck) {
    ParticleType = ParticleTypeIn;
    XPos = XPosIn;
    YPos = YPosIn;
    PrevOccupiedCell = GetCellAtPosition (XPos, YPos);
    XVel = random(0.00025, 0.0005) * RandomSign();
    YVel = random(0.00025, 0.0005) * RandomSign();
    ShouldBeRemoved = !OverrideCellCheck && (GetCellAtPosition (XPos, YPos) != null || GetCenterBlockAtPosition (XPos, YPos) != null); // Destroy particle if strating in cell
  }
  
  
  
  
  
  public void Draw() {
    switch (ParticleType) {
      case (ParticleTypes.Food):
        fill (lerpColor (Color_Food_Particle, color (255), 1 - Opacity));
        ellipse (XPos, YPos, Food_Particle_Size, Food_Particle_Size);
        break;
      case (ParticleTypes.Waste):
        fill (lerpColor (Color_Waste_Particle, color (255), 1 - Opacity));
        ellipse (XPos, YPos, Waste_Particle_Size, Waste_Particle_Size);
        break;
    }
  }
  
  
  
  public void Update() {
    
    if (Appearing) {
      Disapearing = false;
      Opacity += 0.05;
      if (Opacity >= 1) Appearing = false;
    }
    
    if (Disapearing) {
      Opacity -= 0.05;
      if (Opacity <= 0) {
        Disapearing = false;
        ShouldBeRemoved = true;
      }
    }
    
    if (ParticleType == ParticleTypes.Waste)
      BounceWithinCell();
    
    XPos += XVel + 1;
    YPos += YVel + 1;
    XPos %= 1;
    YPos %= 1;
    Age ++;
    
    DamageTransitioningCells();
    BounceOffCenterBlocks();
    
  }
  
  
  
  private void DamageTransitioningCells() {
    Cell CurrOccupiedCell = GetCellAtPosition (XPos, YPos);
    if (CurrOccupiedCell != PrevOccupiedCell) {
      if (PrevOccupiedCell != null) PrevOccupiedCell.DamageWall();
      if (CurrOccupiedCell != null) CurrOccupiedCell.DamageWall();
    }
    PrevOccupiedCell = CurrOccupiedCell;
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
  
  
  
  private void BounceWithinCell() {
    Cell CurrCell  = GetCellAtPosition (XPos, YPos);
    Cell NextXCell = GetCellAtPosition (XPos + XVel, YPos);
    Cell NextYCell = GetCellAtPosition (XPos, YPos + YVel);
    if (CurrCell != NextXCell) { // This also needs Curr extists && Prev exists, but that will always be true if Curr != Prev
      XVel *= -1;
      if (CurrCell != null) CurrCell.DamageWall();
    }
    if (CurrCell != NextYCell) {
      YVel *= -1;
      if (CurrCell != null) CurrCell.DamageWall();
    }
  }
  
  
  
  public void LeaveCell() {
    
    int ThisXLoc = floor (XPos / CellWidth);
    int ThisYLoc = floor (YPos / CellHeight);
    
    if (GetCellAtLocation (ThisXLoc - 1, ThisYLoc) == null && GetCenterBlockAtLocation (ThisXLoc - 1, ThisYLoc) == null) {
      XPos = (ThisXLoc - 0.1) * CellWidth;
    } else if (GetCellAtLocation (ThisXLoc, ThisYLoc - 1) == null && GetCenterBlockAtLocation (ThisXLoc, ThisYLoc - 1) == null) {
      YPos = (ThisYLoc - 0.1) * CellHeight;
    } else if (GetCellAtLocation (ThisXLoc + 1, ThisYLoc) == null && GetCenterBlockAtLocation (ThisXLoc + 1, ThisYLoc) == null) {
      XPos = (ThisXLoc + 1.1) * CellWidth;
    } else if (GetCellAtLocation (ThisXLoc, ThisYLoc + 1) == null && GetCenterBlockAtLocation (ThisXLoc, ThisYLoc + 1) == null) {
      YPos = (ThisYLoc + 1.1) * CellHeight;
    }
    
  }
  
  
  
  /*
  public void LeaveCell_OLD() { // Doesn't work
    
    ArrayList <int[]> AdjacentLocations = new ArrayList <int[]> ();
    AdjacentLocations.add (new int[] {-1,  1});
    AdjacentLocations.add (new int[] { 0,  1});
    AdjacentLocations.add (new int[] { 1,  1});
    AdjacentLocations.add (new int[] {-1,  0});
    AdjacentLocations.add (new int[] { 1,  0});
    AdjacentLocations.add (new int[] {-1, -1});
    AdjacentLocations.add (new int[] { 0, -1});
    AdjacentLocations.add (new int[] { 1, -1});
    
    int ThisCellXLoc = floor (XPos / CellWidth);
    int ThisCellYLoc = floor (YPos / CellHeight);
    
    while (AdjacentLocations.size() > 0) {
      int NewCellLocI = floor(random(AdjacentLocations.size()));
      int[] NewCellLoc = AdjacentLocations.get(NewCellLocI);
      AdjacentLocations.remove(NewCellLocI);
      Cell C = GetCellAtLocation (ThisCellXLoc + NewCellLoc[0], ThisCellYLoc + NewCellLoc[1]);
      if (C == null) {
        MoveToCell (C); // C is null???
        return;
      }
    }
    
  }
  
  
  
  private void MoveToCell (Cell C) {
    if (XPos > C.XPos) {
      XPos = C.XPos + CellWidth * 0.9;
    } else if (XPos < C.XPos) {
      XPos = C.XPos + CellWidth * 0.1;
    }
    if (YPos > C.YPos) {
      YPos = C.YPos + CellHeight * 0.9;
    } else if (YPos < C.YPos) {
      YPos = C.YPos + CellHeight * 0.1;
    }
  }
  */
  
  
  
}
