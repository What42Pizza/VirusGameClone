boolean CheckIfSettingsAreValid() {
  
  if (Starting_Cells == null) {
    println ("Error: Starting_Cells cannot be null.");
    return false;
  }
  
  if (Starting_Cells.length == 0) {
    println ("Error: Starting_Cells length cannot be 0.");
    return false;
  }
  
  if (Starting_Cells[0].length == 0) {
    println ("Error: Starting_Cells width cannot be 0.");
    return false;
  }
  
  int StartingCellsLength = Starting_Cells.length;
  for (int[] Row : Starting_Cells) {
    if (Row.length != StartingCellsLength) {
      println ("Error: All rows in Starting_Cells have to be the same length.");
      return false;
    }
  }
  
  return true;
  
}



void CreateStartingCells() {
  
  int MapWidth  = Starting_Cells   .length;
  int MapHeight = Starting_Cells[0].length;
  CellsGrid = new Cell [MapWidth] [MapHeight];
  CenterBlocksGrid = new CenterBlock [MapWidth] [MapHeight];
  
  for (int y = 0; y < MapHeight; y ++) {
    for (int x = 0; x < MapWidth ; x ++) {
      CellsGrid[x][y] = null;
      CenterBlocksGrid[x][y] = null;
    }
  }
  
  int CellID = 0;
  for (int y = 0; y < MapHeight; y ++) {
    for (int x = 0; x < MapWidth ; x ++) {
      if (Starting_Cells[x][y] == 1) {
        Cell NewCell = new Cell (x, y);
        NewCell.ID = CellID;
        Cells.add (NewCell);
        CellsGrid[x][y] = NewCell;
        CellID ++;
      } else if (Starting_Cells[x][y] == 2) {
        CenterBlock NewCenterBlock = new CenterBlock (x, y);
        CenterBlocks.add (NewCenterBlock);
        CenterBlocksGrid[x][y] = NewCenterBlock;
      }
    }
  }
  
}



int RandomSign() {
  return random(1) > 0.5 ? 1 : -1;
}



float[] ConvertScreenPosToWorldPos (int XPos, int YPos) {
  return new float[] {
    ((XPos - Camera.XPos) / Camera.Zoom),
    ((YPos - Camera.YPos) / Camera.Zoom)
  };
}

int[] ConvertWorldPosToScreenPos (float WorldX, float WorldY) {
  return new int[] {
    (int) (WorldX * Camera.Zoom + Camera.XPos),
    (int) (WorldY * Camera.Zoom + Camera.YPos)
  };
}



ArrayList <Codon> ProcessInfoIntoCodons (int[] In) {
  ArrayList <Codon> Output= new ArrayList <Codon> ();
  for (int i = 0; i < In.length; i += 2) {
    if (In[i+1] == Codon2_RGL) {
      Output.add (new Codon (new int[] {In[i], In[i+1], In[i+2], In[i+3]}));
      i += 2;
    } else {
      Output.add (new Codon (new int[] {In[i], In[i+1]}));
    }
  }
  return Output;
}



int[] ProcessCodonsIntoInfo (ArrayList <Codon> In) {
  IntList Output = new IntList();
  for (Codon C : In) {
    for (int Int : C.Info) {
      Output.append (Int);
    }
  }
  return ConvertIntList (Output);
}



int[] ConvertIntList (IntList In) {
  int[] Output = new int [In.size()];
  for (int i = 0; i < Output.length; i ++) {
    Output[i] = In.get(i);
  }
  return Output;
}





Cell GetCellAtLocation (int XLoc, int YLoc) {
  return CellsGrid [XLoc] [YLoc];
}



Cell GetCellAtPosition (float XPos, float YPos) {
  if (XPos < 0 || XPos >= 1 || YPos < 0 || YPos >= 1) return  null;
  int CellX = floor (XPos / CellWidth );
  int CellY = floor (YPos / CellHeight);
  return CellsGrid [CellX] [CellY];
}



CenterBlock GetCenterBlockAtPosition (float XPos, float YPos) {
  if (XPos < 0 || XPos >= 1 || YPos < 0 || YPos >= 1) return  null;
  int CellX = floor (XPos / CellWidth );
  int CellY = floor (YPos / CellHeight);
  return CenterBlocksGrid [CellX] [CellY];
}



CenterBlock GetCenterBlockAtLocation (int XLoc, int YLoc) {
  return CenterBlocksGrid [XLoc] [YLoc];
}





boolean ParticleIsInCell (Particle P, Cell C) {
  return
    P.XPos > C.XPos &&
    P.XPos < C.XPos + CellWidth &&
    P.YPos > C.YPos &&
    P.YPos < C.YPos + CellHeight
  ;
}





color GetCodon1Color (Codon CodonIn) {
  return GetCodon1ColorFromID (CodonIn.Info[0]);
}

color GetCodon1ColorFromID (int CodonID) {
  switch (CodonID) {
    case (Codon1_None    ): return Color_Codon1_None    ;
    case (Codon1_Digest  ): return Color_Codon1_Digest  ;
    case (Codon1_Remove  ): return Color_Codon1_Remove  ;
    case (Codon1_MoveHand): return Color_Codon1_MoveHand;
    case (Codon1_Read    ): return Color_Codon1_Read    ;
    case (Codon1_Write   ): return Color_Codon1_Write   ;
    default: return Color_Codon_Error;
  }
}



color GetCodon2Color (Codon CodonIn) {
  return GetCodon2ColorFromID (CodonIn.Info[1]);
}

color GetCodon2ColorFromID (int CodonID) {
  switch (CodonID) {
    case (Codon2_None           ): return Color_Codon2_None            ;
    case (Codon2_Food           ): return Color_Codon2_Food            ;
    case (Codon2_Waste          ): return Color_Codon2_Waste           ;
    case (Codon2_Wall           ): return Color_Codon2_Wall            ;
    case (Codon2_WeakestLocation): return Color_Codon2_WeakestLocation ;
    case (Codon2_Inward         ): return Color_Codon2_Inward          ;
    case (Codon2_Outward        ): return Color_Codon2_Outward         ;
    case (Codon2_RGL            ): return Color_Codon2_RGL             ;
    case (Codon2_UGO            ): return Color_Codon2_UGO             ;
    default: return Color_Codon_Error;
  }
}



String GetCodon1Name (Codon CodonIn) {
  return Codon1_Names[CodonIn.Info[0]];
}

String GetCodon2Name (Codon CodonIn) {
  int CodonInfo = CodonIn.Info[1];
  if (CodonInfo == Codon2_RGL) {
    return Codon2_Names[Codon2_RGL] + ": " + CodonIn.Info[2] + " - " + CodonIn.Info[3];
  } else {
    return Codon2_Names[CodonInfo];
  }
}



int CountAliveCells (int[][] CellsGrid) {
  int Output = 0;
  for (int[] Row : CellsGrid) {
    for (int i : Row) {
      Output += (i == 1) ? 1 : 0; // I know I could just do += i % 2 but this is more expandable
    }
  }
  return Output;
}





int[] IncreaseArraySize (int[] ArrayIn, int NewSize) {
  if (ArrayIn.length == NewSize) return ArrayIn;
  int[] Output = new int[NewSize];
  for (int i = 0; i < ArrayIn.length; i ++) {
    Output[i] = ArrayIn[i];
  }
  return Output;
}
