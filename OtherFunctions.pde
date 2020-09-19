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
  
  int CellID = 0;
  for (int y = 0; y < Starting_Cells[0].length; y ++) {
    for (int x = 0; x < Starting_Cells   .length; x ++) {
      if (Starting_Cells[x][y] == 1) {
        Cells.add (new Cell (x, y));
        Cells.get(CellID).ID = CellID;
        CellID ++;
      } else if (Starting_Cells[x][y] == 2) {
        CenterBlocks.add (new CenterBlock (x, y));
      }
    }
  }
  
}



int RandomSign() {
  return random(1) > 0.5 ? 1 : -1;
}



float[] ConvertScreenPosToWorldPos (float XPos, float YPos) {
  return new float[] {
    ((XPos - Camera.XPos) / Camera.Zoom),
    ((YPos - Camera.YPos) / Camera.Zoom)
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
  float TargetWorldXPos = XLoc * CellWidth;
  float TargetWorldYPos = YLoc * CellHeight;
  for (Cell C : Cells) {
    if (C.XPos == TargetWorldXPos && C.YPos == TargetWorldYPos) {
      return C;
    }
  }
  return null;
}



Cell GetCellAtPosition (float XPos, float YPos) {
  float TargetWorldXPos = floor (XPos / CellWidth ) * CellWidth ;
  float TargetWorldYPos = floor (YPos / CellHeight) * CellHeight;
  for (Cell C : Cells) {
    if (C.XPos == TargetWorldXPos && C.YPos == TargetWorldYPos) {
      return C;
    }
  }
  return null;
}



CenterBlock GetCenterBlockAtPosition (float XPos, float YPos) {
  float TargetWorldXPos = floor (XPos / CellWidth ) * CellWidth ;
  float TargetWorldYPos = floor (YPos / CellHeight) * CellHeight;
  for (CenterBlock B : CenterBlocks) {
    if (B.XPos == TargetWorldXPos && B.YPos == TargetWorldYPos) {
      return B;
    }
  }
  return null;
}



CenterBlock GetCenterBlockAtLocation (int XLoc, int YLoc) {
  float TargetWorldXPos = XLoc * CellWidth;
  float TargetWorldYPos = YLoc * CellHeight;
  for (CenterBlock B : CenterBlocks) {
    if (B.XPos == TargetWorldXPos && B.YPos == TargetWorldYPos) {
      return B;
    }
  }
  return null;
}





boolean ParticleIsInCell (Particle P, Cell C) {
  return
    P.XPos > C.XPos &&
    P.XPos < C.XPos + CellWidth &&
    P.YPos > C.YPos &&
    P.YPos < C.YPos + CellHeight
  ;
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
    case (Codon2_UGO            ): return Color_Codon2_UGO             ;
  }
  return color (255, 0, 255);
}
