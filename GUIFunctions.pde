// Vars



GUI_Functions GUIFunctions = new GUI_Functions();

GUI_Element GUI_TopBar;
GUI_Element   GUI_TopBar_CellsData ;

GUI_Element GUI_CellData;
GUI_Element   GUI_CellData_HealthText;
GUI_Element   GUI_CellData_EnergyText;

GUI_Element GUI_UGOCreation;

GUI_Element GUI_ConfirmExit;



Cell CellBeingTracked = null;





void GUIFunctions_InitGUI() {
  String DataPath = dataPath("");
  
  GUI_TopBar = new GUI_Element (new File (DataPath + "/GUI/Child.TopBar"));
    GUI_TopBar_CellsData = GUI_TopBar.Child("CellsData");
  
  GUI_CellData = new GUI_Element (new File (DataPath + "/GUI/Child.CellData"));
    GUI_CellData_HealthText = GUI_CellData.Child("HealthText");
    GUI_CellData_EnergyText = GUI_CellData.Child("EnergyText");
  
  GUI_UGOCreation = new GUI_Element (new File (DataPath + "/GUI/Child.UGOCreation"));
  
  GUI_ConfirmExit = new GUI_Element (new File (DataPath + "/GUI/Child.ConfirmExit"));
  
}





void GUIFunctions_UpdateGUIs() {
  
  if (!mousePressed && UpdateFunctions_PrevMousePressed) { // When mouse is released
    int DeltaX = mouseX - UpdateFunctions_StartMouseX;
    int DeltaY = mouseY - UpdateFunctions_StartMouseY;
    if (abs (DeltaX) < 3 && abs (DeltaY) < 3) {            // If mouse hasn't dragged too much
      float[] WorldMousePos = OtherFunctions_ConvertScreenPosToWorldPos (UpdateFunctions_StartMouseX, UpdateFunctions_StartMouseY);
      Cell ClickedCell = OtherFunctions_GetCellAtPosition (WorldMousePos[0], WorldMousePos[1]);
      if (ClickedCell != null) {
        GUIFunctions_OpenCellDataForCell (ClickedCell);
      }
    }
  }
  
  if (CellBeingTracked != null) {
    GUI_CellData_HealthText.Text = "Health: " + ceil (CellBeingTracked.WallHealth);
    GUI_CellData_EnergyText.Text = "Energy: " + ceil (CellBeingTracked.Energy);
  }
  
  MakingUGO = GUI_UGOCreation.Enabled;
  
}





void GUIFunctions_OpenCellDataForCell (Cell ClickedCell) {
  
  GUI_CellData.Enabled = true;
  CellBeingTracked = ClickedCell;
  
}





void GUIFunctions_RenderGUIs() {
  
  GUI_TopBar_CellsData.Text = "Cells alive: " + AliveCells + ", Cells dead:" + DeadCells + ", Cells modified: " + ModifiedCells;
  
  GUI_TopBar     .Render();
  GUI_CellData   .Render();
  GUI_UGOCreation.Render();
  GUI_ConfirmExit.Render();
  
}










void GUIFunctions_EscKeyPressed() {
  
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
  return;
  
}





boolean GUIFunctions_MouseIsOverGUI() {
  return GUI_TopBar.HasMouseHovering() || GUI_CellData.HasMouseHovering() || GUI_UGOCreation.HasMouseHovering() || GUI_ConfirmExit.HasMouseHovering();
}
