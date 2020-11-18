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



Cell CellBeingTracked = null;





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
  
  if (CellBeingTracked != null) {
    GUI_CellData_HealthText.Text = "Health: " + ceil (CellBeingTracked.WallHealth);
    GUI_CellData_EnergyText.Text = "Energy: " + ceil (CellBeingTracked.Energy);
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
  CellBeingTracked = ClickedCell;
  
}





void RenderGUIs() {
  
  GUI_TopBar_CellsData.Text = "Cells alive: " + AliveCells + ", Cells dead:" + DeadCells + ", Cells modified: " + ModifiedCells;
  
  GUI_TopBar     .Render();
  GUI_CellData   .Render();
  GUI_UGOCreation.Render();
  GUI_ConfirmExit.Render();
  
}










void EscKeyPressed() {
  
  if (GUI_CellData.Enabled) {
    GUI_CellData.Enabled = false;
    return;
  }
  
  if (GUI_UGOCreation.Enabled) {
    GUI_UGOCreation.Enabled = false;
    return;
  }
  
  if (GUI_ConfirmExit.Enabled) {
    GUI_ConfirmExit.Enabled = false;
    return;
  }
  
  // else
  GUI_ConfirmExit.Enabled = true;
  GUI_ConfirmExit.XPos = 0.4;
  GUI_ConfirmExit.YPos = 0.4;
  return;
  
}





boolean MouseIsOverGUI() {
  return GUI_TopBar.HasMouseHovering() || GUI_CellData.HasMouseHovering() || GUI_UGOCreation.HasMouseHovering() || GUI_ConfirmExit.HasMouseHovering();
}
