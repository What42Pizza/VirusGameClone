public class CodonEditor {
  
  
  
  // Vars
  
  final int MaxCodonsShown = 8;
  final float ElementHeight = 1.0/MaxCodonsShown;
  
  ArrayList <GUI_Element> CodonGUIElements;
  ArrayList <Codon> CodonsBeingEdited;
  
  
  
  
  
  // Functions
  
  void OpenCellDataForCell (Cell ClickedCell) {
    
    SelectedCell = ClickedCell;
    
    GUI_UGOCreation.Enabled = false;
    GUI_CellData.Enabled = true;
    GUI_CodonEditor_CodonsFrame.TargetScrollY = 0;
    GUI_CodonEditor_CodonsFrame.CurrScrollY = 0;
    
    CodonEditor.CreateCodonGUIElements (ClickedCell.Codons);
    
  }
  
  
  
  
  
  void ResetCodons() {
    ArrayList <Codon> NewCodons = new ArrayList <Codon> ();
    for (int i = 0; i < CodonEditor.MaxCodonsShown; i ++) {
      NewCodons.add(new Codon(new int[] {Codon1_None, Codon2_None}));
    }
    CreateCodonGUIElements(NewCodons);
  }
  
  
  
  void AddCodon (Codon CodonIn) {
    AddCodonToGUI (CodonIn);
    if (SelectedCell != null) {
      SelectedCell.Codons.add(CodonIn);
    }
  }
  
  
  
  void RemoveCodon() {
    int CodonIndex = CodonsBeingEdited.size() - 1;
    CodonsBeingEdited.remove(CodonIndex);
    CodonGUIElements.get(CodonIndex).Delete();
    CodonGUIElements.remove(CodonIndex);
    GUI_CodonEditor_CodonsFrame.MaxScrollY = max ((CodonsBeingEdited.size() - MaxCodonsShown) * ElementHeight, 0);
    GUI_CodonEditor_CodonsFrame.ConstrainScroll();
    if (SelectedCell != null) {
      SelectedCell.Codons.remove(CodonIndex);
    }
  }
  
  
  
  void CreateCodonGUIElements (ArrayList <Codon> Codons) {
    
    CodonsBeingEdited = new ArrayList <Codon> ();
    CodonGUIElements = new ArrayList <GUI_Element> ();
    GUI_CodonEditor_CodonsFrame.DeleteChildren();
    //CodonsFrame.MaxScrollY = (Codons.size() - MaxCodonsShown) * ElementHeight;
    
    for (int i = 0; i < Codons.size(); i ++) {
      AddCodonToGUI (Codons.get(i));
    }
    
  }
  
  
  
  void AddCodonToGUI (Codon NewCodon) {
    CodonsBeingEdited.add (NewCodon);
    GUI_Element NewElement = CreateElementFromCodon (NewCodon, CodonGUIElements.size());
    CodonGUIElements.add (NewElement);
    GUI_CodonEditor_CodonsFrame.AddChild(NewElement);
    GUI_CodonEditor_CodonsFrame.MaxScrollY = max ((CodonsBeingEdited.size() - MaxCodonsShown) * ElementHeight, 0);
  }
  
  
  
  
  
  GUI_Element CreateElementFromCodon (Codon CodonIn, int Index) {
      
    GUI_Element CodonElement = new GUI_Element (new String[] {
      "Name:", "Codon " + Index,
      "ElementType:", "Holder",
      "XPos:", "0",
      "YPos:", Float.toString(ElementHeight * Index),
      "XSize:", "1",
      "YSize:", Float.toString(ElementHeight),
    });
    
    CodonElement.AddChild(new GUI_Element (new String[] {
      "Name:", "LeftDecay",
      "XPos:", "0",
      "YPos:", "0",
      "XSize:", "0.25",
      "YSize:", "1",
      "BackgroundColor:", "0",
      "EdgeSize:", "0",
    }));
    
    CodonElement.AddChild(new GUI_Element (new String[] {
      "Name:", "LeftFill",
      "XPos:", "0.25",
      "YPos:", "0",
      "XSize:", "0.25",
      "YSize:", "1",
      "BackgroundColor:", hex(GetColorFromCodon1(CodonIn)),
      "EdgeSize:", "0",
      "RenderOrder:", "0",
    }));
    
    CodonElement.AddChild(new GUI_Element (new String[] {
      "Name:", "RightDecay",
      "XPos:", "0.75",
      "YPos:", "0",
      "XSize:", "0.25",
      "YSize:", "1",
      "BackgroundColor:", "0",
    }));
    
    CodonElement.AddChild(new GUI_Element (new String[] {
      "Name:", "RightFill",
      "XPos:", "0.5",
      "YPos:", "0",
      "XSize:", "0.25",
      "YSize:", "1",
      "BackgroundColor:", hex(GetColorFromCodon2(CodonIn)),
      "EdgeSize:", "0",
    }));
    
    CodonElement.AddChild(new GUI_Element (new String[] {
      "Name:", "LeftText",
      "ElementType:", "TextButton",
      "HasFrame:", "false",
      "Text:", GetCodon1Name(CodonIn),
      "TextColor:", "FF",
      "XPos:", "0",
      "YPos:", "0",
      "XSize:", "0.5",
      "YSize:", "1",
      "SizeIsConsistentWith:", "ITSELF",
    }));
    
    CodonElement.AddChild(new GUI_Element (new String[] {
      "Name:", "RightText",
      "ElementType:", "TextButton",
      "HasFrame:", "false",
      "Text:", GetCodon2Name(CodonIn),
      "TextColor:", "FF",
      "XPos:", "0.5",
      "YPos:", "0",
      "XSize:", "0.5",
      "YSize:", "1",
      "SizeIsConsistentWith:", "ITSELF",
    }));
    
    return CodonElement;
    
  }
  
  
  
  
  
  void UpdateCodonGUIElements() {
    
    if (SelectedCell != null && SelectedCell.CodonsChanged) {
      CreateCodonGUIElements(SelectedCell.Codons);
    }
    
    for (int i = 0; i < CodonGUIElements.size(); i ++) {
      GUI_Element E = CodonGUIElements.get(i);
      Codon C = CodonsBeingEdited.get(i);
      
      GUI_Element LeftDecay  = E.Child("LeftDecay" );
      GUI_Element LeftFill   = E.Child("LeftFill"  );
      GUI_Element RightDecay = E.Child("RightDecay");
      GUI_Element RightFill  = E.Child("RightFill" );
      
      LeftDecay .XSize = (1 - C.Health) / 2.0;
      LeftFill  .XPos  = (1 - C.Health) / 2.0;
      LeftFill  .XSize = C.Health / 2.0;
      RightFill .XSize = C.Health / 2.0;
      RightDecay.XPos  = 0.5 + C.Health / 2.0;
      RightDecay.XSize = (1 - C.Health) / 2.0;
      
    }
    
  }
  
  
  
  

}
