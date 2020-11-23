// Vars



GUI_Functions GUIFunctions = new GUI_Functions();

GUI_Element GUI_TopBar;
GUI_Element   GUI_TopBar_CellsData;
GUI_Element   GUI_TopBar_CreateUGO;
GUI_Element   GUI_TopBar_ExitButton;

GUI_Element GUI_CellData;
GUI_Element   GUI_CellData_HealthText;
GUI_Element   GUI_CellData_EnergyText;

GUI_Element GUI_UGOCreation;

GUI_Element GUI_CodonEditor;
GUI_Element   GUI_CodonEditor_AddCodon;
GUI_Element   GUI_CodonEditor_RemoveCodon;

GUI_Element GUI_ConfirmExit;



Cell SelectedCell = null;
GUI_Element[] CodonElements;
ArrayList <Codon> CodonsBeingEdited;

final int MaxCodonsShown = 8;





void InitGUI() {
  String DataPath = dataPath("");
  
  GUI_TopBar = new GUI_Element (new File (DataPath + "/GUI/Child.TopBar"));
    GUI_TopBar_CellsData = GUI_TopBar.Child("CellsData");
    GUI_TopBar_CreateUGO = GUI_TopBar.Child("CreateUGO");
    GUI_TopBar_ExitButton = GUI_TopBar.Child("ExitButton");
  
  GUI_CellData = new GUI_Element (new File (DataPath + "/GUI/Child.CellData"));
    GUI_CellData_HealthText = GUI_CellData.Child("HealthText");
    GUI_CellData_EnergyText = GUI_CellData.Child("EnergyText");
  
  GUI_UGOCreation = new GUI_Element (new File (DataPath + "/GUI/Child.UGOCreation"));
  
  GUI_CodonEditor = new GUI_Element (new File (DataPath + "/GUI/Child.CodonEditor")) {@Override public void Update() {super.Update(); UpdateCodonGUIElements();}};
    GUI_CodonEditor_AddCodon = GUI_CodonEditor.Child("AddCodon");
    GUI_CodonEditor_RemoveCodon = GUI_CodonEditor.Child("RemoveCodon");
    GUI_CellData.AddChild(GUI_CodonEditor);
    GUI_UGOCreation.AddChild(GUI_CodonEditor);
  
  GUI_ConfirmExit = new GUI_Element (new File (DataPath + "/GUI/Child.ConfirmExit"));
  
}





void UpdateGUIs() {
  
  if (MouseJustReleased) {
    float[] WorldMousePos = ConvertScreenPosToWorldPos (StartMouseX, StartMouseY);
    Cell ClickedCell = GetCellAtPosition (WorldMousePos[0], WorldMousePos[1]);
    if (ClickedCell != null) {
      OpenCellDataForCell (ClickedCell);
    } else {
      GUI_CellData.Enabled = false;
    }
  }
  
  if (!GUI_CellData.Enabled || SelectedCell.ShouldBeRemoved) SelectedCell = null;
  
  if (SelectedCell != null) {
    GUI_CellData_HealthText.Text = "Health: " + ceil (SelectedCell.WallHealth);
    GUI_CellData_EnergyText.Text = "Energy: " + ceil (SelectedCell.Energy);
  }
  
  if (GUI_TopBar_ExitButton.JustClicked()) {
    GUI_ConfirmExit.XPos = 0.4;
    GUI_ConfirmExit.YPos = 0.4; // It also toggles ConfirmExit by its ButtonAction
  }
  
  if (GUI_TopBar_CreateUGO.JustClicked()) {
    ArrayList <Codon> NewUGOCodons = new ArrayList <Codon> ();
    for (int i = 0; i < MaxCodonsShown; i ++) {
      NewUGOCodons.add(new Codon(new int[] {Codon1_None, Codon2_None}));
    }
    CreateCodonGUIElements(NewUGOCodons);
  }
  
  if (GUI_CodonEditor_AddCodon.JustClicked()) {
    CodonsBeingEdited.add(new Codon (new int[] {Codon1_None, Codon2_None}));
    RemakeCodonGUIElements();
  }
  if (GUI_CodonEditor_RemoveCodon.JustClicked()) {
    CodonsBeingEdited.remove(CodonsBeingEdited.size()-1);
    RemakeCodonGUIElements();
  }
  
  MakingUGO = GUI_UGOCreation.Enabled;
  
}





void OpenCellDataForCell (Cell ClickedCell) {
  
  GUI_UGOCreation.Enabled = false;
  GUI_CellData.Enabled = true;
  SelectedCell = ClickedCell;
  
  CreateCodonGUIElements (ClickedCell.Codons);
  
}





void CreateCodonGUIElements (ArrayList <Codon> Codons) {
  
  final float ElementHeight = 1.0/MaxCodonsShown;
  
  CodonsBeingEdited = Codons;
  CodonElements = new GUI_Element [Codons.size()];
  GUI_Element CodonsFrame = GUI_CodonEditor.Child("CodonsFrame");
  CodonsFrame.MaxScrollY = (Codons.size() - MaxCodonsShown) * ElementHeight;
  
  CodonsFrame.DeleteChildren();
  
  for (int i = 0; i < CodonElements.length; i ++) {
    
    Codon ThisCodon = Codons.get(i);
    
    GUI_Element ThisCodonHolder = new GUI_Element (new String[] {
      "Name:", "Codon " + i,
      "ElementType:", "Holder",
      "XPos:", "0",
      "YPos:", Float.toString(i * ElementHeight),
      "XSize:", "1",
      "YSize:", Float.toString(ElementHeight),
    });
    
    ThisCodonHolder.AddChild(new GUI_Element (new String[] {
      "Name:", "LeftDecay",
      "XPos:", "0",
      "YPos:", "0",
      "XSize:", "0.25",
      "YSize:", "1",
      "BackgroundColor:", "0",
      "EdgeSize:", "0",
    }));
    
    ThisCodonHolder.AddChild(new GUI_Element (new String[] {
      "Name:", "LeftFill",
      "XPos:", "0.25",
      "YPos:", "0",
      "XSize:", "0.25",
      "YSize:", "1",
      "BackgroundColor:", hex(GetColorFromCodon1(ThisCodon)),
      "EdgeSize:", "0",
      "RenderOrder:", "0",
    }));
    
    ThisCodonHolder.AddChild(new GUI_Element (new String[] {
      "Name:", "RightDecay",
      "XPos:", "0.75",
      "YPos:", "0",
      "XSize:", "0.25",
      "YSize:", "1",
      "BackgroundColor:", "0",
    }));
    
    ThisCodonHolder.AddChild(new GUI_Element (new String[] {
      "Name:", "RightFill",
      "XPos:", "0.5",
      "YPos:", "0",
      "XSize:", "0.25",
      "YSize:", "1",
      "BackgroundColor:", hex(GetColorFromCodon2(ThisCodon)),
      "EdgeSize:", "0",
    }));
    
    ThisCodonHolder.AddChild(new GUI_Element (new String[] {
      "Name:", "LeftText",
      "ElementType:", "TextButton",
      "HasFrame:", "false",
      "Text:", GetCodon1Name(ThisCodon),
      "TextColor:", "FF",
      "XPos:", "0",
      "YPos:", "0",
      "XSize:", "0.5",
      "YSize:", "1",
      "SizeIsConsistentWith:", "ITSELF",
    }));
    
    ThisCodonHolder.AddChild(new GUI_Element (new String[] {
      "Name:", "RightText",
      "ElementType:", "TextButton",
      "HasFrame:", "false",
      "Text:", GetCodon2Name(ThisCodon),
      "TextColor:", "FF",
      "XPos:", "0.5",
      "YPos:", "0",
      "XSize:", "0.5",
      "YSize:", "1",
      "SizeIsConsistentWith:", "ITSELF",
    }));
    
    CodonsFrame.AddChild(ThisCodonHolder);
    CodonElements[i] = ThisCodonHolder;
    
  }
  
}



void RemakeCodonGUIElements() {
  CreateCodonGUIElements(CodonsBeingEdited);
}





void UpdateCodonGUIElements() {
  
  if (SelectedCell != null && SelectedCell.CodonsChanged) {
    CreateCodonGUIElements(SelectedCell.Codons);
  }
  
  for (int i = 0; i < CodonElements.length; i ++) {
    GUI_Element E = CodonElements[i];
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





void RenderGUIs() {
  
  GUI_TopBar_CellsData.Text = "Cells alive: " + AliveCells + ", Cells dead:" + DeadCells + ", Cells modified: " + ModifiedCells;
  
  GUI_TopBar     .Render();
  GUI_CellData   .Render();
  GUI_UGOCreation.Render();
  GUI_ConfirmExit.Render();
  
}










void EscKeyPressed() {
  
  if (GUI_ConfirmExit.Enabled) {
    GUI_ConfirmExit.Enabled = false;
    return;
  }
  
  if (GUI_CellData.Enabled) {
    GUI_CellData.Enabled = false;
    return;
  }
  
  if (GUI_UGOCreation.Enabled) {
    GUI_UGOCreation.Enabled = false;
    return;
  }
  
  // else
  GUI_ConfirmExit.Enabled = true; // This toggles because of the first if statement
  GUI_ConfirmExit.XPos = 0.4;
  GUI_ConfirmExit.YPos = 0.4;
  return;
  
}





boolean MouseIsOverGUI() {
  return GUI_TopBar.HasMouseHovering() || GUI_CellData.HasMouseHovering() || GUI_UGOCreation.HasMouseHovering() || GUI_ConfirmExit.HasMouseHovering();
}
