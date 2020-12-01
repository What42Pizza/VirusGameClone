public class CodonEditor {
  
  
  
  
  
  final int MaxCodonsShown = 8;
  final float ElementHeight = 1.0/MaxCodonsShown;
  
  ArrayList <GUI_Element> CodonGUIElements;
  ArrayList <Codon> CodonsBeingEdited;
  int SelectedCodonIndex = -1;
  int SelectedCodonSide = 0;
  
  
  
  
  
  
  
  
  
  
  void InitReplaceCodonFrames() {
    
    GUI_Element Codon1Frame = GUI_CodonEditor_ReplaceCodon1Frame;
    GUI_Element Codon2Frame = GUI_CodonEditor_ReplaceCodon2Frame;
    
    float MinScroll = ElementHeight * 0.2;
    
    Codon1Frame.MinScrollY = MinScroll;
    Codon1Frame.MaxScrollY = max ((Codon1_Names.length - MaxCodonsShown) * ElementHeight, MinScroll * -1);
    Codon1Frame.TargetScrollY = MinScroll;
    Codon1Frame.CurrScrollY = MinScroll;
    
    Codon2Frame.MinScrollY = MinScroll;
    Codon2Frame.MaxScrollY = max ((Codon2_Names.length - MaxCodonsShown) * ElementHeight, MinScroll * -1);
    Codon2Frame.TargetScrollY = MinScroll;
    Codon2Frame.CurrScrollY = MinScroll;
    
    for (int i = 0; i < Codon1_Names.length; i ++) {
      String CodonName = Codon1_Names[i];
      color CodonColor = GetCodon1ColorFromID (i);
      GUI_Element NewButton = new GUI_Element (new String[] {
        "Name:", "ReplaceCodon_" + CodonName,
        "ElementType:", "TextButton",
        "UsePressedColor:", "false",
        "Text:", CodonName,
        "SizeIsConsistentWith:", "ITSELF",
        "TextColor:", hex(color(255)),
        "BackgroundColor:", hex (CodonColor),
        "EdgeColor:", hex (lerpColor (CodonColor, color (0), 0.15)),
        "EdgeSize:", Integer.toString((int)(width * 0.003)),
        "XPos:", "0.1",
        "YPos:", Float.toString(ElementHeight * i),
        "XSize:", "0.8",
        "YSize:", Float.toString(ElementHeight * 0.8),
      });
      Codon1Frame.AddChild(NewButton);
    }
    
    for (int i = 0; i < Codon2_Names.length; i ++) {
      String CodonName = Codon2_Names[i];
      color CodonColor = GetCodon2ColorFromID (i);
      GUI_Element NewButton = new GUI_Element (new String[] {
        "Name:", "ReplaceCodon_" + CodonName,
        "ElementType:", "TextButton",
        "UsePressedColor:", "false",
        "Text:", CodonName,
        "SizeIsConsistentWith:", "ITSELF",
        "TextColor:", hex(color(255)),
        "BackgroundColor:", hex (CodonColor),
        "EdgeColor:", hex (lerpColor (CodonColor, color (0), 0.15)),
        "EdgeSize:", Integer.toString((int)(width * 0.003)),
        "XPos:", "0.1",
        "YPos:", Float.toString(ElementHeight * i),
        "XSize:", "0.8",
        "YSize:", Float.toString(ElementHeight * 0.8),
      });
      Codon2Frame.AddChild(NewButton);
    }
    
  }
  
  
  
  
  
  void OpenCellDataForCell (Cell ClickedCell) {
    
    SelectedCell = ClickedCell;
    
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
    AddCodonToGUI (CodonIn, true);
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
    
    if (SelectedCell != null) SelectedCell.Codons.remove(CodonIndex);
    
    if (SelectedCodonIndex >= CodonsBeingEdited.size()) ResetSelectedCodonWOColor();
    
  }
  
  
  
  void CreateCodonGUIElements (ArrayList <Codon> Codons) {
    
    CodonsBeingEdited = new ArrayList <Codon> ();
    CodonGUIElements = new ArrayList <GUI_Element> ();
    GUI_CodonEditor_CodonsFrame.DeleteChildren();
    //CodonsFrame.MaxScrollY = (Codons.size() - MaxCodonsShown) * ElementHeight;
    
    for (int i = 0; i < Codons.size(); i ++) {
      AddCodonToGUI (Codons.get(i), false);
    }
    
    GUI_CodonEditor_CodonsFrame.ConstrainScroll();
    
  }
  
  
  
  void AddCodonToGUI (Codon NewCodon, boolean AutoMove) {
    GUI_Element CodonsFrame = GUI_CodonEditor_CodonsFrame; // Rename; add codon to list
    CodonsBeingEdited.add (NewCodon);
    
    GUI_Element NewElement = CreateElementFromCodon (NewCodon, CodonGUIElements.size()); // Create new GUI_Element
    CodonGUIElements.add (NewElement);
    GUI_CodonEditor_CodonsFrame.AddChild(NewElement);
    
    float NewMaxScrollY = max ((CodonsBeingEdited.size() - MaxCodonsShown) * ElementHeight, 0);
    if (AutoMove && CodonsFrame.TargetScrollY == CodonsFrame.MaxScrollY * -1) CodonsFrame.TargetScrollY = NewMaxScrollY * -1; // Update scrolling
    CodonsFrame.MaxScrollY = NewMaxScrollY;
    
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
      "BackgroundColor:", hex(GetCodon1Color(CodonIn)),
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
      "EdgeSize:", "0",
    }));
    
    CodonElement.AddChild(new GUI_Element (new String[] {
      "Name:", "RightFill",
      "XPos:", "0.5",
      "YPos:", "0",
      "XSize:", "0.25",
      "YSize:", "1",
      "BackgroundColor:", hex(GetCodon2Color(CodonIn)),
      "EdgeSize:", "0",
    }));
    
    CodonElement.AddChild(new GUI_Element (new String[] {
      "Name:", "LeftTextButton",
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
      "Name:", "RightTextButton",
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
  
  
  
  
  
  int CodonSelectStartFrame = 0;
  
  void UpdateCodonGUIElements() {
    
    if (SelectedCodonIndex != -1) {
      UpdateCodonFlashing();
    }
    
    if (GUI_CodonEditor.JustClicked() && !(GUI_CodonEditor_CodonsFrame.JustClicked() || GUI_CodonEditor_ReplaceCodon1Frame.JustClicked())) {
      ResetSelectedCodon();
    }
    
    if (SelectedCell != null && SelectedCell.CodonsChanged) {
      CreateCodonGUIElements(SelectedCell.Codons);
    }
    
    boolean CodonsFrameClicked = GUI_CodonEditor_CodonsFrame.JustClicked();
    
    for (int i = 0; i < CodonGUIElements.size(); i ++) {
      GUI_Element E = CodonGUIElements.get(i);
      Codon C = CodonsBeingEdited.get(i);
      
      GUI_Element LeftDecay  = E.Child("LeftDecay" );
      GUI_Element LeftFill   = E.Child("LeftFill"  );
      GUI_Element RightDecay = E.Child("RightDecay");
      GUI_Element RightFill  = E.Child("RightFill" );
      GUI_Element LeftText   = E.Child("LeftTextButton" );
      GUI_Element RightText  = E.Child("RightTextButton");
      
      LeftDecay .XSize = (1 - C.Health) / 2.0;
      LeftFill  .XPos  = (1 - C.Health) / 2.0;
      LeftFill  .XSize = C.Health / 2.0;
      RightFill .XSize = C.Health / 2.0;
      RightDecay.XPos  = 0.5 + C.Health / 2.0;
      RightDecay.XSize = (1 - C.Health) / 2.0;
      
      if (CodonsFrameClicked) {
        if (LeftText .JustClicked()) SetSelectedCodon (i, LEFT ); // IDR what these constants are supposed to be used for, but I'll just use them anyway
        if (RightText.JustClicked()) SetSelectedCodon (i, RIGHT);
      }
      
      /*
      if (i == SelectedCodonIndex) {
        int FrameDelta = frameCount - CodonSelectStartFrame;
        float FlashAmount = (sin (FrameDelta / 5.0) / 2.0 + 0.5);
        if (SelectedCodonSide == LEFT) {
          LeftDecay.BackgroundColor = color (FlashAmount * 223);
          LeftFill.BackgroundColor = lerpColor (GetCodon1Color(C), color (223), FlashAmount);
        } else {
          RightDecay.BackgroundColor = color (FlashAmount * 223);
          RightFill.BackgroundColor = lerpColor (GetCodon2Color(C), color (223), FlashAmount);
        }
      }
      */
      
    }
    
  }
  
  
  
  
  
  void UpdateCodonFlashing() {
    GUI_Element SelectedCodon = CodonGUIElements.get(SelectedCodonIndex);
    Codon C = CodonsBeingEdited.get(SelectedCodonIndex);
    int FrameDelta = frameCount - CodonSelectStartFrame;
    float FlashAmount = (sin (FrameDelta / 5.0) / 2.0 + 0.5);
    if (SelectedCodonSide == LEFT) {
      SelectedCodon.Child("LeftDecay" ).BackgroundColor = color (FlashAmount * 223);
      SelectedCodon.Child("LeftFill"  ).BackgroundColor = lerpColor (GetCodon1Color(C), color (223), FlashAmount);
    } else {
      SelectedCodon.Child("RightDecay").BackgroundColor = color (FlashAmount * 223);
      SelectedCodon.Child("RightFill" ).BackgroundColor = lerpColor (GetCodon2Color(C), color (223), FlashAmount);
    }
  }
  
  
  
  
  
  void SetSelectedCodon (int CodonIndex, int CodonSide) {
    ResetSelectedCodon();
    SelectedCodonIndex = CodonIndex;
    SelectedCodonSide = CodonSide;
    CodonSelectStartFrame = frameCount;
    if (CodonSide == LEFT) {
      GUI_CodonEditor_ReplaceCodon1Frame.Enabled = true;
    } else {
      GUI_CodonEditor_ReplaceCodon2Frame.Enabled = true;
    }
  }
  
  
  
  void ResetSelectedCodon() {
    ResetSelectedCodonColors();
    ResetSelectedCodonWOColor();
  }
  
  void ResetSelectedCodonWOColor() {
    SelectedCodonIndex = -1;
    SelectedCodonSide = 0;
    GUI_CodonEditor_ReplaceCodon1Frame.Enabled = false;
    GUI_CodonEditor_ReplaceCodon2Frame.Enabled = false;
  }
  
  
  
  void ResetSelectedCodonColors() {
    if (SelectedCodonIndex == -1) return;
    GUI_Element PrevSelectedElement = CodonGUIElements.get(SelectedCodonIndex);
    Codon PrevSelectedCodon = CodonsBeingEdited.get(SelectedCodonIndex);
    if (SelectedCodonSide == LEFT) {
      PrevSelectedElement.Child("LeftDecay").BackgroundColor = color (0);
      PrevSelectedElement.Child("LeftFill" ).BackgroundColor = GetCodon1Color (PrevSelectedCodon);
    } else {
      PrevSelectedElement.Child("RightDecay").BackgroundColor = color (0);
      PrevSelectedElement.Child("RightFill" ).BackgroundColor = GetCodon2Color (PrevSelectedCodon);
    }
  }
  
  
  
  

}
