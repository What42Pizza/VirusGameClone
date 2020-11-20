// Vars



GUI_Functions GUIFunctions = new GUI_Functions();

GUI_Element GUI_TopBar;
GUI_Element   GUI_TopBar_CellsData;
GUI_Element   GUI_TopBar_ExitButton;

GUI_Element GUI_CellData;
GUI_Element   GUI_CellData_HealthText;
GUI_Element   GUI_CellData_EnergyText;

GUI_Element GUI_UGOCreation;

GUI_Element GUI_ConfirmExit;



Cell SelectedCell = null;
GUI_Element[] SelectedCellCodonElements;





void InitGUI() {
  String DataPath = dataPath("");
  
  GUI_TopBar = new GUI_Element (new File (DataPath + "/GUI/Child.TopBar"));
    GUI_TopBar_CellsData = GUI_TopBar.Child("CellsData");
    GUI_TopBar_ExitButton = GUI_TopBar.Child("ExitButton");
  
  GUI_CellData = new GUI_Element (new File (DataPath + "/GUI/Child.CellData"));
    GUI_CellData_HealthText = GUI_CellData.Child("HealthText");
    GUI_CellData_EnergyText = GUI_CellData.Child("EnergyText");
  
  GUI_UGOCreation = new GUI_Element (new File (DataPath + "/GUI/Child.UGOCreation"));
  
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
  
  MakingUGO = GUI_UGOCreation.Enabled;
  
}





void OpenCellDataForCell (Cell ClickedCell) {
  
  GUI_UGOCreation.Enabled = false;
  GUI_CellData.Enabled = true;
  SelectedCell = ClickedCell;
  
  CreateCodonGUIElements();
  
}





void CreateCodonGUIElements() {
  ArrayList <Codon> Codons = SelectedCell.Codons;
  GUI_Element CodonsFrame = GUI_CellData.Child("CodonsFrame");
  GUI_Element CodonsText = GUI_CellData.Child("CodonsText");
  float ElementHeight = CodonsText.YSize / CodonsFrame.YSize; // Calc what percentage CodonsText.YSize is of CodonsFrame.YSize, and that will be the YSize of the new elements
  SelectedCellCodonElements = new GUI_Element [Codons.size()];
  
  for (int i = 0; i < SelectedCellCodonElements.length; i ++) {
    
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
    }));
    
    ThisCodonHolder.AddChild(new GUI_Element (new String[] {
      "Name:", "RightDecay",
      "XPos:", "0.75",
      "YPos:", "0",
      "XSize:", "0.25",
      "YSize:", "1",
      "BackgroundColor:", "0",
      "EdgeSize:", "0",
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
      "ElementType:", "TextFrame",
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
      "ElementType:", "TextFrame",
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
