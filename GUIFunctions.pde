// Vars



GUI_Functions GUIFunctions = new GUI_Functions();
CodonEditor CodonEditor = new CodonEditor();

GUI_Element GUI_TopBar;
GUI_Element   GUI_TopBar_CellsData;
GUI_Element   GUI_TopBar_TicksSinceX;
GUI_Element   GUI_TopBar_CreateUGO;
GUI_Element   GUI_TopBar_ExitButton;

GUI_Element GUI_CellData;
GUI_Element   GUI_CellData_HealthFrame;
GUI_Element     GUI_CellData_HealthText;
GUI_Element     GUI_CellData_HealthFill;
GUI_Element     GUI_CellData_HealthVoid;
GUI_Element   GUI_CellData_EnergyFrame;
GUI_Element     GUI_CellData_EnergyText;
GUI_Element     GUI_CellData_EnergyFill;
GUI_Element     GUI_CellData_EnergyVoid;

GUI_Element GUI_UGOCreation;

GUI_Element GUI_CodonEditor;
GUI_Element   GUI_CodonEditor_CodonsFrame;
GUI_Element   GUI_CodonEditor_AddCodon;
GUI_Element   GUI_CodonEditor_RemoveCodon;
GUI_Element   GUI_CodonEditor_ReplaceCodonsFrame;
GUI_Element   GUI_CodonEditor_Codon1sFrame;
GUI_Element   GUI_CodonEditor_Codon2sFrame;
GUI_Element   GUI_CodonEditor_RGLStartOrEnd;
GUI_Element   GUI_CodonEditor_RGLPlus;
GUI_Element   GUI_CodonEditor_RGLMinus;

GUI_Element GUI_ConfirmExit;

Cell SelectedCell = null;





void InitGUI() {
  String DataPath = dataPath("");
  
  GUI_TopBar = new GUI_Element (new File (DataPath + "/GUI/Child.TopBar"));
    GUI_TopBar_CellsData = GUI_TopBar.Child("CellsData");
    GUI_TopBar_TicksSinceX = GUI_TopBar.Child("TicksSinceX");
    GUI_TopBar_CreateUGO = GUI_TopBar.Child("CreateUGO");
    GUI_TopBar_ExitButton = GUI_TopBar.Child("ExitButton");
  
  GUI_CellData = new GUI_Element (new File (DataPath + "/GUI/Child.CellData"));
    GUI_CellData_HealthFrame = GUI_CellData.Child("HealthFrame");
      GUI_CellData_HealthText = GUI_CellData_HealthFrame.Child("HealthText");
      GUI_CellData_HealthFill = GUI_CellData_HealthFrame.Child("HealthFill");
      GUI_CellData_HealthVoid = GUI_CellData_HealthFrame.Child("HealthVoid");
    GUI_CellData_EnergyFrame = GUI_CellData.Child("EnergyFrame");
      GUI_CellData_EnergyText = GUI_CellData_EnergyFrame.Child("EnergyText");
      GUI_CellData_EnergyFill = GUI_CellData_EnergyFrame.Child("EnergyFill");
      GUI_CellData_EnergyVoid = GUI_CellData_EnergyFrame.Child("EnergyVoid");
  
  GUI_UGOCreation = new GUI_Element (new File (DataPath + "/GUI/Child.UGOCreation"));
  
  GUI_CodonEditor = new GUI_Element (new File (DataPath + "/GUI/Child.CodonEditor")) {@Override public void Update() {super.Update(); CodonEditor.UpdateCodonGUIElements();}}; // this probably isn't the best way to do it but IDK of a better way that isn't weird
    GUI_CodonEditor_CodonsFrame = GUI_CodonEditor.Child("CodonsFrame");
    GUI_CodonEditor_AddCodon = GUI_CodonEditor.Child("AddCodon");
    GUI_CodonEditor_RemoveCodon = GUI_CodonEditor.Child("RemoveCodon");
    GUI_CodonEditor_ReplaceCodonsFrame = GUI_CodonEditor.Child("ReplaceCodonsFrame");
    GUI_CodonEditor_Codon1sFrame = GUI_CodonEditor_ReplaceCodonsFrame.Child("Codon1sFrame");
    GUI_CodonEditor_Codon2sFrame = GUI_CodonEditor_ReplaceCodonsFrame.Child("Codon2sFrame");
    GUI_Element RGLEdit = GUI_CodonEditor_ReplaceCodonsFrame.Child("RGLEdit");
    GUI_CodonEditor_RGLStartOrEnd = RGLEdit.Child("RGLStartOrEnd");
    GUI_CodonEditor_RGLPlus  = RGLEdit.Child("RGLPlus");
    GUI_CodonEditor_RGLMinus = RGLEdit.Child("RGLMinus");
    GUI_CellData.AddChild(GUI_CodonEditor);
    GUI_UGOCreation.AddChild(GUI_CodonEditor);
  
  GUI_ConfirmExit = new GUI_Element (new File (DataPath + "/GUI/Child.ConfirmExit"));
  
  GUI_CellData_HealthFill.BackgroundColor = Color_Cell_Wall_Text;
  GUI_CellData_EnergyFill.BackgroundColor = Color_Cell_Energy_Text;
  
}





void UpdateGUIs() {
  
  
  
  // Select cell
  if (MouseJustReleased) {
    float[] WorldMousePos = ConvertScreenPosToWorldPos (StartMouseX, StartMouseY);
    Cell ClickedCell = GetCellAtPosition (WorldMousePos[0], WorldMousePos[1]);
    if (ClickedCell != null) {
      CodonEditor.OpenCellDataForCell (ClickedCell);
      GUI_UGOCreation.Enabled = false;
    } else {
      GUI_CellData.Enabled = false;
    }
  }
  
  
  
  // CellData
  if (SelectedCell != null) {
    if (!GUI_CellData.Enabled || SelectedCell.ShouldBeRemoved) {
      SelectedCell = null;
      GUI_CellData.Enabled = false;
    } else {
      GUI_CellData_HealthText.Text = "Health: " + ceil (SelectedCell.WallHealth);
      GUI_CellData_HealthFill.XSize = SelectedCell.WallHealth / 100;
      GUI_CellData_HealthVoid.XPos  = SelectedCell.WallHealth / 100;
      GUI_CellData_HealthVoid.XSize = 1 - SelectedCell.WallHealth / 100;
      GUI_CellData_EnergyText.Text = "Energy: " + ceil (SelectedCell.Energy);
      GUI_CellData_EnergyFill.XSize = SelectedCell.Energy / 100;
      GUI_CellData_EnergyVoid.XPos  = SelectedCell.Energy / 100;
      GUI_CellData_EnergyVoid.XSize = 1 - SelectedCell.Energy / 100;
    }
  }
  
  
  
  // TopBar
  GUI_TopBar_CellsData.Text = "Alive: " + AliveCells + ", Dead:" + DeadCells + ", Modified: " + ModifiedCells + ", Unmodified: " + UnmodifiedCells + ", UGOs: " + UGOs.size();
  GUI_TopBar_TicksSinceX.Text = "Ticks Since Start: " + CurrentTick + ", Ticks Since Modified: " + (FirstModificationTick == -1 ? "--" : Integer.toString(CurrentTick - FirstModificationTick));
  
  
  
  // Confirm exit
  if (GUI_TopBar_ExitButton.JustClicked()) {
    GUI_ConfirmExit.XPos = 0.4;
    GUI_ConfirmExit.YPos = 0.4; // It also toggles ConfirmExit by its ButtonAction
  }
  
  
  
  // CreateUGO button
  if (GUI_TopBar_CreateUGO.JustClicked()) {
    CodonEditor.ResetCodons();
    GUI_CellData.Enabled = false;
  }
  
  
  
  // CodonEditor
  if (GUI_CodonEditor_AddCodon.JustClicked()) {
    CodonEditor.AddCodon(new Codon (new int[] {Codon1_None, Codon2_None}));
  }
  if (GUI_CodonEditor_RemoveCodon.JustClicked()) {
    CodonEditor.RemoveCodon();
  }
  
  
  
}





void RenderGUIs() {
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
