public class Interpreter {
  
  
  
  public void InterpretCodon (Codon Codon, Cell Cell) {
    switch (Codon.Info[0]) {
      
      case (Codon1_None):
        return;
      
      case (Codon1_Digest):
        Digest (Codon, Cell);
        return;
      
      case (Codon1_Remove):
        Remove (Codon, Cell);
        return;
      
      case (Codon1_MoveHand):
        MoveHand (Codon, Cell);
        return;
      
      case (Codon1_Read):
        Read (Codon, Cell);
        return;
      
      case (Codon1_Write):
        Write (Codon, Cell);
        return;
      
    }
  }
  
  
  
  
  
  private void Digest (Codon Codon, Cell Cell) {
    switch (Codon.Info[1]) {
      
      case (Codon2_None):
        return;
      
      case (Codon2_Food):
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
        for (Particle W : WasteParticles) {
          if (ParticleIsInCell (W, Cell)) {
            Cell.DrawLineFromHandTo (W.XPos, W.YPos);
            Cell.DrainEnergy();
            W.Disapearing = true;
          }
        }
        return;
      
      case (Codon2_Wall):
        Cell.DigestWall();
        Cell.DrawLinesFromHandToWall();
        return;
      
      case (Codon2_WeakestLocation):
        return;
      
      case (Codon2_Inward):
        for (int i = 0; i < Cell.Codons.size(); i ++) {
          Cell.DigestCodon(i);
          float[] CodonPos = Cell.GetCodonPosition (i);
          Cell.DrawLineFromHandTo (CodonPos[0], CodonPos[1]);
        }
        return;
      
      case (Codon2_Outward):
        Cell.DigestWall();
        Cell.DrawLinesFromHandToWall();
        return;
      
      case (Codon2_RGL):
        int Mod = Cell.Codons.size();
        int Start = Codon.Info[2] + Cell.HandCodonPos + Mod * 1000; // The +Mod*1000 is because mod (-1, 4) returns -1 and not 3
        int End = Codon.Info[3] + Cell.HandCodonPos + 1 + Mod * 1000;
        for (int i = Start; i < End; i ++) {
          Cell.DigestCodon (i % Mod);
          float[] CodonPos = Cell.GetCodonPosition (i % Mod);
          Cell.DrawLineFromHandTo (CodonPos[0], CodonPos[1]);
        }
        return;
      
    }
  }
  
  
  
  
  
  private void Remove (Codon Codon, Cell Cell) {
    switch (Codon.Info[1]) {
      
      case (Codon2_None):
        return;
      
      case (Codon2_Food):
        if (Cell.HandPosition != HandPositions.Inward) return;
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
        if (Cell.HandPosition != HandPositions.Inward) return;
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
        Cell.Die();
        return;
      
      case (Codon2_WeakestLocation):
        return;
      
      case (Codon2_Inward):
        return;
      
      case (Codon2_Outward):
        Cell.Die();
        return;
      
      case (Codon2_RGL):
        int Mod = Cell.Codons.size();
        int Start = Codon.Info[2] + Cell.InterpCodonPos + Mod * 1000; // The +Mod*1000 is because mod (-1, 4) returns -1 and not 3
        int End = Codon.Info[3] + Cell.InterpCodonPos + 1 + Mod * 1000;
        for (int i = Start; i < End; i ++) {
          float[] CodonPos = Cell.GetCodonPosition (i % Mod);
          Cell.DrawLineFromHandTo (CodonPos[0], CodonPos[1]);
        }
        for (int i = Start; i < End && Cell.Codons.size() > 0; i ++) {
          Cell.Codons.remove(Start % Cell.Codons.size());
        }
        Cell.InterpCodonPos -= Codon.Info[3] - Codon.Info[2];
        Cell.InterpCodonPos += Cell.Codons.size() * 1000;
        Cell.InterpCodonPos %= Cell.Codons.size();
        return;
      
    }
  }
  
  
  
  
  
  private void MoveHand (Codon Codon, Cell Cell) {
    switch (Codon.Info[1]) {
      
      case (Codon2_None):
        
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
        
        return;
      
      case (Codon2_Outward):
        
        return;
      
      case (Codon2_RGL):
        
        return;
      
    }
  }
  
  
  
  
  
  private void Read (Codon Codon, Cell Cell) {
    switch (Codon.Info[1]) {
      
      case (Codon2_None):
        
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
        
        return;
      
      case (Codon2_Outward):
        
        return;
      
      case (Codon2_RGL):
        
        return;
      
    }
  }
  
  
  
  
  
  private void Write (Codon Codon, Cell Cell) {
    switch (Codon.Info[1]) {
      
      case (Codon2_None):
        
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
        
        return;
      
      case (Codon2_Outward):
        
        return;
      
      case (Codon2_RGL):
        
        return;
      
    }
  }
  
  
  
}
