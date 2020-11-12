// Vars



GUI_Functions GUIFunctions = new GUI_Functions();

GUI_Element GUI_TopBar;
GUI_Element   GUI_TopBar_CellsData ;
GUI_Element   GUI_TopBar_CreateUGO ;
GUI_Element   GUI_TopBar_ExitButton;

GUI_Element GUI_CellData;

GUI_Element GUI_UGOCreation;





void InitGUI() {
  String DataPath = dataPath("");
  
  GUI_TopBar = new GUI_Element (new File (DataPath + "/GUI/Child.TopBar"));
    GUI_TopBar_CellsData  = GUI_TopBar.Child("CellsData" );
    GUI_TopBar_CreateUGO  = GUI_TopBar.Child("CreateUGO" );
    GUI_TopBar_ExitButton = GUI_TopBar.Child("ExitButton");
  
  GUI_CellData = new GUI_Element (new File (DataPath + "/GUI/Child.CellData"));
  
  GUI_UGOCreation = new GUI_Element (new File (DataPath + "/GUI/Child.UGOCreation"));
  
}





void UpdateGUIs() {
  
  if (GUI_TopBar_ExitButton.JustClicked()) exit();
  if (GUI_TopBar_CreateUGO .JustClicked()) GUI_UGOCreation.Enabled = !GUI_UGOCreation.Enabled;
  
}





void RenderGUIs() {
  
  GUI_TopBar_CellsData.Text = "Cells alive: " + AliveCells + ", Cells dead:" + DeadCells + ", Cells modified: " + ModifiedCells;
  
  GUI_TopBar     .Render();
  GUI_CellData   .Render();
  GUI_UGOCreation.Render();
  
}
