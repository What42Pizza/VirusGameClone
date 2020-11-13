boolean[] Keys     = new boolean [128];
boolean[] PrevKeys = new boolean [128];



void keyPressed() {
  GUIFunctions.keyPressed();
  if (key < 128) Keys[key] = true;
  if (key == 27) {GUIFunctions_EscKeyPressed(); key = 0;}
}



void keyReleased() {
  if (key < 128) Keys[key] = false;
}



boolean InputFunctions_KeyJustPressed (char Key) {
  return Keys[Key] && !PrevKeys[Key];
}



void mouseWheel (MouseEvent event) {
  GUIFunctions.mouseWheel(event);
  float[] MousePosBeforeScroll = OtherFunctions_ConvertScreenPosToWorldPos (mouseX, mouseY);
  
  float ScrollAmount = event.getAmount(); // This is deprecated but I don't know what to replace it with
  Camera.Zoom *= pow (2, ScrollAmount * Camera_Scroll_Speed * -1);
  
  float[] MousePosAfterScroll = OtherFunctions_ConvertScreenPosToWorldPos (mouseX, mouseY);
  float[] MousePosChange = new float[] {
    MousePosAfterScroll[0] - MousePosBeforeScroll[0],
    MousePosAfterScroll[1] - MousePosBeforeScroll[1]
  };
  
  Camera.XPos += MousePosChange[0] * Camera.Zoom; // Zoom towards mouse
  Camera.YPos += MousePosChange[1] * Camera.Zoom;
  
}
