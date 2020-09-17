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
          if (ParticleIsInCell (F, Cell)) {
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
          if (ParticleIsInCell (W, Cell)) {
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
        int[] RGLLocation = GetHandRGLLocation (Cell, Codon.Info[2], Codon.Info[3]);
        for (int i = RGLLocation[0]; i < RGLLocation[1]; i ++) {
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
          if (ParticleIsInCell (F, Cell)) {
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
          if (ParticleIsInCell (W, Cell)) {
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
        int[] RGLLocation = GetHandRGLLocation (Cell, Codon.Info[2], Codon.Info[3]);
        for (int i = RGLLocation[0]; i < RGLLocation[1]; i ++) { // -------------- Draw lines
          float[] ICodonPos = Cell.GetCodonPosition(i);
          Cell.DrawLineFromHandTo (ICodonPos[0], ICodonPos[1]);
        }
        for (int i = RGLLocation[0]; i < RGLLocation[1] && Cell.Codons.size() > 0; i ++) { // Remove codons
          int Mod = Cell.Codons.size();
          Cell.Codons.remove ((RGLLocation[0] + Mod * 1000) % Mod);
        }
        int Mod = Cell.Codons.size();
        Cell.InterpCodonPos = (Cell.InterpCodonPos - (Codon.Info[3] - Codon.Info[2]) + Mod * 1000) % Mod;
        //Cell.InterpCodonPos -= Codon.Info[3] - Codon.Info[2];
        //Cell.InterpCodonPos += Cell.Codons.size() * 1000;
        //Cell.InterpCodonPos %= Cell.Codons.size();
        return;
      
      case (Codon2_UGO):
        
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
        Cell.InterpCodonPos = (CodonI + Codon.Info[2] + Mod * 1000) % Mod;
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
        Cell.CodonMemory = ProcessCodonsIntoInfo (Cell.Codons);
        for (int i = 0; i < Cell.Codons.size(); i ++) {
          float[] CodonPos = Cell.GetCodonPosition (i);
          Cell.DrawLineFromHandTo (CodonPos[0], CodonPos[1]);
        }
        return;
      
      case (Codon2_Outward):
        return;
      
      case (Codon2_RGL):
        if (!Cell.HandIsInward()) return;
        int[] RGLLocation = GetHandRGLLocation (Cell, Codon.Info[2], Codon.Info[3]);
        ArrayList <Codon> CodonsToProcess = new ArrayList <Codon> ();
        ArrayList <Codon> Codons = Cell.Codons;
        int Mod = Codons.size();
        for (int i = RGLLocation[0]; i < RGLLocation[1]; i ++) {
          int CodonIndex = (i + Mod * 1000) % Mod;
          CodonsToProcess.add (Codons.get(CodonIndex));
          Cell.DrawLineFromHandToCodon (CodonIndex);
        }
        Cell.CodonMemory = ProcessCodonsIntoInfo (CodonsToProcess);
        return;
      
      case (Codon2_UGO):
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
        Cell.SetCodons (ProcessInfoIntoCodons (Cell.CodonMemory));
        for (int i = 0; i < Cell.Codons.size(); i ++)
          Cell.DrawLineFromHandToCodon (i);
        return;
      
      case (Codon2_Outward):
        return;
      
      case (Codon2_RGL):
        int RGLStart = GetHandRGLLocation (Cell, Codon.Info[2]);
        ArrayList <Codon> CodonsToWrite = ProcessInfoIntoCodons (Cell.CodonMemory);
        Cell.ReplaceCodons (RGLStart, CodonsToWrite);
        for (int i = RGLStart; i < RGLStart + CodonsToWrite.size(); i ++)
          Cell.DrawLineFromHandToCodon (i);
        return;
      
      case (Codon2_UGO):
        if (!Cell.HandIsOutward()) return;
        CellHandPos = Cell.GetHandPoint();
        UGOs.add (new UGO (CellHandPos[0], CellHandPos[1], ProcessInfoIntoCodons (Cell.CodonMemory)));
        return;
      
    }
  }
  
  
  
  
  
  
  
  
  
  
  int[] GetHandRGLLocation (Cell Cell, int RGLStart, int RGLEnd) {
    ArrayList <Codon> Codons = Cell.Codons;
    int Mod = Codons.size();
    int Start = (RGLStart + Cell.HandCodonPos + Mod * 1000) % Mod; // The +Mod*1000 is because mod (-1, 4) returns -1 and not 3 (this wraps correctly when negative)
    int End = (RGLEnd + Cell.HandCodonPos + 1 + Mod * 1000) % Mod;
    return new int[] {Start, End};
  }
  
  
  
  int GetHandRGLLocation (Cell Cell, int RGLStart) {
    ArrayList <Codon> Codons = Cell.Codons;
    int Mod = Codons.size();
    int Start = (RGLStart + Cell.HandCodonPos + Mod * 1000) % Mod; // The +Mod*1000 is because mod (-1, 4) returns -1 and not 3 (this wraps correctly when negative)
    return Start;
  }
  
  
  
  
  
}
