public class Interpreter {
  
  
  
  public void InterpretCodon (Codon Codon, Cell Cell, int CodonPos) {
    switch (Codon.Info[0]) {
      
      case (Codon1_None):
        return;
      
      case (Codon1_Digest):
        Digest (Codon, Cell, CodonPos);
        return;
      
      case (Codon1_Remove):
        Remove (Codon, Cell, CodonPos);
        return;
      
      case (Codon1_MoveHand):
        MoveHand (Codon, Cell, CodonPos);
        return;
      
      case (Codon1_Read):
        Read (Codon, Cell, CodonPos);
        return;
      
      case (Codon1_Write):
        Write (Codon, Cell, CodonPos);
        return;
      
    }
  }
  
  
  
  
  
  private void Digest (Codon Codon, Cell Cell, int CodonI) {
    switch (Codon.Info[1]) {
      
      case (Codon2_None):
        return;
      
      case (Codon2_Food):
        if (!Cell.HandIsOutward()) return;
        for (Particle F : FoodParticles) {
          if (OtherFunctions_ParticleIsInCell (F, Cell)) {
            Cell.GainEnergy();
            Cell.DrawLineFromHandTo (F.XPos, F.YPos);
            F.Disapearing = true;
            WasteParticles.add (new Particle (ParticleTypes.Waste, F.XPos, F.YPos, true));
            return;
          }
        }
        return;
      
      case (Codon2_Waste):
        if (!Cell.HandIsOutward()) return;
        for (Particle W : WasteParticles) {
          if (OtherFunctions_ParticleIsInCell (W, Cell)) {
            Cell.DrawLineFromHandTo (W.XPos, W.YPos);
            Cell.DrainEnergy();
            W.Disapearing = true;
          }
        }
        return;
      
      case (Codon2_Wall):
        if (!Cell.HandIsOutward()) return;
        Cell.DigestWall();
        Cell.DrawLinesFromHandToWall();
        return;
      
      case (Codon2_WeakestLocation):
        return;
      
      case (Codon2_Inward):
        if (!Cell.HandIsInward()) return;
        for (int i = 0; i < Cell.Codons.size(); i ++) {
          Cell.DigestCodon(i);
          float[] ICodonPos = Cell.GetCodonPosition (i);
          Cell.DrawLineFromHandTo (ICodonPos[0], ICodonPos[1]);
        }
        return;
      
      case (Codon2_Outward):
        if (!Cell.HandIsOutward()) return;
        Cell.DigestWall();
        Cell.DrawLinesFromHandToWall();
        return;
      
      case (Codon2_RGL):
        if (!Cell.HandIsInward()) return;
        int[] RGLIndexes = GetRGLIndexes (Cell, Codon.Info[2], Codon.Info[3]);
        for (int i : RGLIndexes) {
          Cell.DigestCodon(i);
          float[] ICodonPos = Cell.GetCodonPosition(i);
          Cell.DrawLineFromHandTo (ICodonPos[0], ICodonPos[1]);
        }
        return;
      
      case (Codon2_UGO):
        
        return;
      
    }
  }
  
  
  
  
  
  private void Remove (Codon Codon, Cell Cell, int CodonI) {
    switch (Codon.Info[1]) {
      
      case (Codon2_None):
        return;
      
      case (Codon2_Food):
        if (!Cell.HandIsOutward()) return;
        for (Particle F : FoodParticles) {
          if (OtherFunctions_ParticleIsInCell (F, Cell)) {
            Cell.DrawLineFromHandTo (F.XPos, F.YPos);
            F.LeaveCell();
            Cell.DrawLineFromHandTo (F.XPos, F.YPos);
            return;
          }
        }
        return;
      
      case (Codon2_Waste):
        if (!Cell.HandIsOutward()) return;
        for (Particle W : WasteParticles) {
          if (OtherFunctions_ParticleIsInCell (W, Cell)) {
            Cell.DrawLineFromHandTo (W.XPos, W.YPos);
            W.LeaveCell();
            Cell.DrawLineFromHandTo (W.XPos, W.YPos);
            return;
          }
        }
        return;
      
      case (Codon2_Wall):
        if (!Cell.HandIsOutward()) return;
        Cell.Die();
        return;
      
      case (Codon2_WeakestLocation):
        return;
      
      case (Codon2_Inward):
        return;
      
      case (Codon2_Outward):
        if (!Cell.HandIsOutward()) return;
        Cell.Die();
        return;
      
      case (Codon2_RGL):
        if (!Cell.HandIsInward()) return;
        int[] RGLIndexes = GetRGLIndexes (Cell, Codon.Info[2], Codon.Info[3]);
        for (int i : RGLIndexes)
          Cell.DrawLineFromHandToCodon(i);
        for (int i = 0; i < RGLIndexes.length; i ++)
          Cell.Codons.remove ((RGLIndexes[0] + Cell.Codons.size() * 1000) % Cell.Codons.size());
        Cell.CodonsChanged = true;
        
        /*
        int[] RGLLocation = GetHandRGLLocation (Cell, Codon.Info[2], Codon.Info[3]); // This code doesn't account for wrapping
        for (int i = RGLLocation[0]; i < RGLLocation[1]; i ++) { // -------------- Draw lines
          float[] ICodonPos = Cell.GetCodonPosition(i);
          Cell.DrawLineFromHandTo (ICodonPos[0], ICodonPos[1]);
        }
        for (int i = RGLLocation[0]; i < RGLLocation[1] && Cell.Codons.size() > 0; i ++) { // Remove codons
          int Mod = Cell.Codons.size();
          Cell.Codons.remove ((RGLLocation[0] + Mod * 1000) % Mod);
        }
        */
        
        int Mod = Cell.Codons.size();
        Cell.InterpCodonPos = (Cell.InterpCodonPos - (Codon.Info[3] - Codon.Info[2]) + Mod * 1000) % Mod;
        //Cell.InterpCodonPos -= Codon.Info[3] - Codon.Info[2];
        //Cell.InterpCodonPos += Cell.Codons.size() * 1000;
        //Cell.InterpCodonPos %= Cell.Codons.size();
        return;
      
      case (Codon2_UGO):
        if (!Cell.HandIsOutward()) return;
        for (UGO U : UGOs) {
          if (OtherFunctions_ParticleIsInCell (U, Cell)) {
            Cell.DrawLineFromHandTo (U.XPos, U.YPos);
            U.LeaveCell();
            Cell.DrawLineFromHandTo (U.XPos, U.YPos);
            U.BounceInCell = false;
            return;
          }
        }
        return;
      
    }
  }
  
  
  
  
  
  private void MoveHand (Codon Codon, Cell Cell, int CodonI) {
    switch (Codon.Info[1]) {
      
      case (Codon2_None):
        return;
      
      case (Codon2_Food):
        Cell.HandPosition = HandPositions.Outward;
        return;
      
      case (Codon2_Waste):
        Cell.HandPosition = HandPositions.Outward;
        return;
      
      case (Codon2_Wall):
        Cell.HandPosition = HandPositions.Outward;
        return;
      
      case (Codon2_WeakestLocation):
        float LowestHealth = 1;
        int WeakestPos = 0;
        for (int i = 0; i < Cell.Codons.size(); i ++) {
          if (Cell.Codons.get(i).Health < LowestHealth) {
            LowestHealth = Cell.Codons.get(i).Health;
            WeakestPos = i;
          }
        }
        Cell.HandCodonPos = WeakestPos;
        return;
      
      case (Codon2_Inward):
        Cell.MoveHandInward();
        return;
      
      case (Codon2_Outward):
        Cell.MoveHandOutward();
        return;
      
      case (Codon2_RGL):
        int Mod = Cell.Codons.size();
        Cell.HandCodonPos = (CodonI + Codon.Info[2] + Mod * 1000) % Mod;
        return;
      
      case (Codon2_UGO):
        return;
      
    }
  }
  
  
  
  
  
  private void Read (Codon Codon, Cell Cell, int CodonI) {
    switch (Codon.Info[1]) {
      
      case (Codon2_None):
        Cell.CodonMemory = new int [0];
        return;
      
      case (Codon2_Food):
        return;
      
      case (Codon2_Waste):
        return;
      
      case (Codon2_Wall):
        return;
      
      case (Codon2_WeakestLocation):
        return;
      
      case (Codon2_Inward):
        if (!Cell.HandIsInward()) return;
        Cell.CodonMemory = OtherFunctions_ProcessCodonsIntoInfo (Cell.Codons);
        for (int i = 0; i < Cell.Codons.size(); i ++) {
          float[] CodonPos = Cell.GetCodonPosition (i);
          Cell.DrawLineFromHandTo (CodonPos[0], CodonPos[1]);
        }
        return;
      
      case (Codon2_Outward):
        return;
      
      case (Codon2_RGL):
        if (!Cell.HandIsInward()) return;
        ArrayList <Codon> CodonsToProcess = new ArrayList <Codon> ();
        int[] RGLIndexes = GetRGLIndexes (Cell, Codon.Info[2], Codon.Info[3]);
        for (int I : RGLIndexes) {
          CodonsToProcess.add (Cell.Codons.get(I));
          Cell.DrawLineFromHandToCodon(I);
        }
        Cell.CodonMemory = OtherFunctions_ProcessCodonsIntoInfo (CodonsToProcess);
        return;
      
      case (Codon2_UGO):
        if (!Cell.HandIsOutward()) return;
        for (UGO U : UGOs) {
          if (OtherFunctions_ParticleIsInCell (U, Cell)) {
            Cell.DrawLineFromHandTo (U.XPos, U.YPos);
            Cell.CodonMemory = OtherFunctions_ProcessCodonsIntoInfo (U.Codons);
            return;
          }
        }
        return;
      
    }
  }
  
  
  
  
  
  private void Write (Codon Codon, Cell Cell, int CodonI) {
    float[] CellHandPos;
    switch (Codon.Info[1]) {
      
      case (Codon2_None):
        return;
      
      case (Codon2_Food):
        if (!Cell.HandIsOutward()) return;
        CellHandPos = Cell.GetHandPoint();
        FoodParticles.add (new Particle (ParticleTypes.Food, CellHandPos[0], CellHandPos[1], true));
        Cell.DrainEnergy();
        return;
      
      case (Codon2_Waste):
        if (!Cell.HandIsOutward()) return;
        CellHandPos = Cell.GetHandPoint();
        WasteParticles.add (new Particle (ParticleTypes.Waste, CellHandPos[0], CellHandPos[1], true));
        Cell.DrainEnergy();
        return;
      
      case (Codon2_Wall):
        if (!Cell.HandIsOutward()) return;
        Cell.RepairWall();
        Cell.DrawLinesFromHandToWall();
        return;
      
      case (Codon2_WeakestLocation):
        return;
      
      case (Codon2_Inward):
        if (!Cell.HandIsInward()) return;
        Cell.SetCodons (OtherFunctions_ProcessInfoIntoCodons (Cell.CodonMemory));
        for (int i = 0; i < Cell.Codons.size(); i ++)
          Cell.DrawLineFromHandToCodon (i);
        Cell.CodonsChanged = true;
        return;
      
      case (Codon2_Outward):
        return;
      
      case (Codon2_RGL):
        int RGLStart = GetHandRGLLocation (Cell, Codon.Info[2]);
        ArrayList <Codon> CodonsToWrite = OtherFunctions_ProcessInfoIntoCodons (Cell.CodonMemory);
        Cell.ReplaceCodons (RGLStart, CodonsToWrite);
        for (int i = RGLStart; i < RGLStart + CodonsToWrite.size(); i ++)
          Cell.DrawLineFromHandToCodon (i);
        Cell.CodonsChanged = true;
        return;
      
      case (Codon2_UGO):
        if (!Cell.HandIsOutward()) return;
        CellHandPos = Cell.GetHandPoint();
        ArrayList <Codon> UGOCodons = OtherFunctions_ProcessInfoIntoCodons (Cell.CodonMemory);
        UGOs.add (new UGO (CellHandPos[0], CellHandPos[1], UGOCodons, true));
        Cell.DrainEnergyFromCodons (UGOCodons.size());
        return;
      
    }
  }
  
  
  
  
  
  
  
  
  
  
  int[] GetHandRGLLocation (Cell Cell, int RGLStart, int RGLEnd) {
    int Mod = Cell.Codons.size();
    int Start = (RGLStart + Cell.HandCodonPos + Mod * 1000) % Mod; // The +Mod*1000 is because mod (-1, 4) returns -1 and not 3 (this wraps correctly when negative)
    int End = (RGLEnd + Cell.HandCodonPos + Mod * 1000) % Mod;
    return new int[] {Start, End};
  }
  
  
  
  int GetHandRGLLocation (Cell Cell, int RGLStart) {
    int Mod = Cell.Codons.size();
    int Start = (RGLStart + Cell.HandCodonPos + Mod * 1000) % Mod; // The +Mod*1000 is because mod (-1, 4) returns -1 and not 3 (this wraps correctly when negative)
    return Start;
  }
  
  
  
  int[] GetRGLIndexes (Cell Cell, int RGLStart, int RGLEnd) { // This is needed for if the start is after the end
    int[] Output = new int [RGLEnd - RGLStart + 1];
    int Mod = Cell.Codons.size();
    for (int i = 0; i < Output.length; i ++) {
      Output[i] = (Cell.HandCodonPos + RGLStart + i + Mod * 1000) % Mod;
    }
    return Output;
  }
  
  
  
  
  
}
