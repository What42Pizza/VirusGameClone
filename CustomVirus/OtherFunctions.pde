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
  
  int CellIndex = 0;
  for (int y = 0; y < Starting_Cells[0].length; y ++) {
    for (int x = 0; x < Starting_Cells   .length; x ++) {
      if (Starting_Cells[x][y] == 1) {
        Cells.add (new Cell (x, y));
        Cells.get(CellIndex).CellIndex = CellIndex;
        CellIndex ++;
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



ArrayList <Codon> ProcessCodonInformation (int[] In) {
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
