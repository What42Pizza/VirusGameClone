boolean OtherFunctions_CheckIfSettingsAreValid() {
  
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



void OtherFunctions_CreateStartingCells() {
  
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



int OtherFunctions_RandomSign() {
  return random(1) > 0.5 ? 1 : -1;
}



float[] OtherFunctions_ConvertScreenPosToWorldPos (int XPos, int YPos) {
  return new float[] {
    ((XPos - Camera.XPos) / Camera.Zoom),
    ((YPos - Camera.YPos) / Camera.Zoom)
  };
}



ArrayList <Codon> OtherFunctions_ProcessInfoIntoCodons (int[] In) {
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



int[] OtherFunctions_ProcessCodonsIntoInfo (ArrayList <Codon> In) {
  IntList Output = new IntList();
  for (Codon C : In) {
    for (int Int : C.Info) {
      Output.append (Int);
    }
  }
  return OtherFunctions_ConvertIntList (Output);
}



int[] OtherFunctions_ConvertIntList (IntList In) {
  int[] Output = new int [In.size()];
  for (int i = 0; i < Output.length; i ++) {
    Output[i] = In.get(i);
  }
  return Output;
}





Cell OtherFunctions_GetCellAtLocation (int XLoc, int YLoc) {
  return CellsGrid [XLoc] [YLoc];
}



Cell OtherFunctions_GetCellAtPosition (float XPos, float YPos) {
  if (XPos < 0 || XPos >= 1 || YPos < 0 || YPos >= 1) return  null;
  int CellX = floor (XPos / CellWidth );
  int CellY = floor (YPos / CellHeight);
  return CellsGrid [CellX] [CellY];
}



CenterBlock OtherFunctions_GetCenterBlockAtPosition (float XPos, float YPos) {
  if (XPos < 0 || XPos >= 1 || YPos < 0 || YPos >= 1) return  null;
  int CellX = floor (XPos / CellWidth );
  int CellY = floor (YPos / CellHeight);
  return CenterBlocksGrid [CellX] [CellY];
}



CenterBlock OtherFunctions_GetCenterBlockAtLocation (int XLoc, int YLoc) {
  return CenterBlocksGrid [XLoc] [YLoc];
}





boolean OtherFunctions_ParticleIsInCell (Particle P, Cell C) {
  return
    P.XPos > C.XPos &&
    P.XPos < C.XPos + CellWidth &&
    P.YPos > C.YPos &&
    P.YPos < C.YPos + CellHeight
  ;
}





color OtherFunctions_GetColorFromCodon1 (Codon CodonIn) {
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



color OtherFunctions_GetColorFromCodon2 (Codon CodonIn) {
  switch (CodonIn.Info[1]) {
    case (Codon2_None           ): return Color_Codon2_None            ;
    case (Codon2_Food           ): return Color_Codon2_Food            ;
    case (Codon2_Waste          ): return Color_Codon2_Waste           ;
    case (Codon2_Wall           ): return Color_Codon2_Wall            ;
    case (Codon2_WeakestLocation): return Color_Codon2_WeakestLocation ;
    case (Codon2_Inward         ): return Color_Codon2_Inward          ;
    case (Codon2_Outward        ): return Color_Codon2_Outward         ;
    case (Codon2_RGL            ): return Color_Codon2_RGL             ;
    case (Codon2_UGO            ): return Color_Codon2_UGO             ;
  }
  return color (255, 0, 255);
}



int OtherFunctions_CountAliveCells (int[][] CellsGrid) {
  int Output = 0;
  for (int[] Row : CellsGrid) {
    for (int i : Row) {
      Output += (i == 1) ? 1 : 0; // I know I could just do += i % 2 but this is more expandable
    }
  }
  return Output;
}
