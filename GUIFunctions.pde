// Vars



GUI_Functions GUIFunctions = new GUI_Functions();

GUI_Element GUI_TopBar;
GUI_Element   GUI_TopBar_CellsData ;
GUI_Element   GUI_TopBar_CreateUGO ;
GUI_Element   GUI_TopBar_ExitButton;

GUI_Element GUI_CellData;

GUI_Element GUI_UGOCreation;
GUI_Element   GUI_UGOCreation_CloseButton;

GUI_Element GUI_ConfirmExit;
  GUI_Element GUI_ConfirmExit_CloseButton;
  GUI_Element GUI_ConfirmExit_YesButton;
  GUI_Element GUI_ConfirmExit_NoButton;





void GUIFunctions_InitGUI() {
  String DataPath = dataPath("");
  
  GUI_TopBar = new GUI_Element (new File (DataPath + "/GUI/Child.TopBar"));
    GUI_TopBar_CellsData  = GUI_TopBar.Child("CellsData" );
    GUI_TopBar_CreateUGO  = GUI_TopBar.Child("CreateUGO" );
    GUI_TopBar_ExitButton = GUI_TopBar.Child("ExitButton");
  
  GUI_CellData = new GUI_Element (new File (DataPath + "/GUI/Child.CellData"));
  
  GUI_UGOCreation = new GUI_Element (new File (DataPath + "/GUI/Child.UGOCreation"));
     GUI_UGOCreation_CloseButton = GUI_UGOCreation.Child("CloseButton");
  
  GUI_ConfirmExit = new GUI_Element (new File (DataPath + "/GUI/Child.ConfirmExit"));
     GUI_ConfirmExit_CloseButton = GUI_ConfirmExit.Child("TopBar")   .Child("CloseButton");
     //GUI_ConfirmExit_YesButton   = GUI_ConfirmExit.Child("MainFrame").Child("YesButton"  );
     //GUI_ConfirmExit_NoButton    = GUI_ConfirmExit.Child("MainFrame").Child("NoButton"   );
  
}





void GUIFunctions_UpdateGUIs() {
  
  if (GUI_TopBar_ExitButton.JustClicked()) exit();
  if (GUI_TopBar_CreateUGO .JustClicked()) GUI_UGOCreation.Enabled = !GUI_UGOCreation.Enabled;
  if (GUI_UGOCreation_CloseButton.JustClicked()) GUI_UGOCreation.Enabled = false;
  
  MakingUGO = GUI_UGOCreation.Enabled;
  
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
  
  // else
  exit();
  return;
  
}





boolean GUIFunctions_MouseIsOverGUI() {
  return GUI_TopBar.HasMouseHovering() || GUI_CellData.HasMouseHovering() || GUI_UGOCreation.HasMouseHovering() || GUI_ConfirmExit.HasMouseHovering();
}
