// Vars



boolean[] Keys     = new boolean [128];
boolean[] PrevKeys = new boolean [128];

boolean PrevMousePressed = false;
boolean MouseJustReleased = false;
boolean MouseIsDragging = false;
int StartMouseX = 0;
int StartMouseY = 0;
float StartCameraXPos = 0;
float StartCameraYPos = 0;





// Functions



void UpdateInputs() {
  
  if (mousePressed && !PrevMousePressed && !MouseIsOverGUI()) {
    StartMouseDrag(); // It needs to be done like this because of StartMouseX&Y
    if (mouseButton == RIGHT) MouseIsDragging = true;
  }
  
  if (MouseIsDragging) MoveCameraToMouse();
  
  MouseJustReleased = false; // This is one of the first functions called in draw(), so this should be okay
  if (!mousePressed && PrevMousePressed) {
    int DeltaX = StartMouseX - mouseX;
    int DeltaY = StartMouseY - mouseY;
    if (abs (DeltaX) < 3 && abs (DeltaY) < 3) {
      MouseJustReleased = true;
    }
  }
  
  if (mousePressed) {
    if (MakingUGO) {
      
    }
  } else {
    MouseIsDragging = false;
  }
  
  if (KeyJustPressed(' ')) Paused = !Paused;
  
  if (Keys['w']) Camera.YPos += Camera_Speed;
  if (Keys['a']) Camera.XPos += Camera_Speed;
  if (Keys['s']) Camera.YPos -= Camera_Speed;
  if (Keys['d']) Camera.XPos -= Camera_Speed;
  
}



void StartMouseDrag() {
  StartMouseX = mouseX;
  StartMouseY = mouseY;
  StartCameraXPos = Camera.XPos;
  StartCameraYPos = Camera.YPos;
}



void MoveCameraToMouse() {
  Camera.XPos = StartCameraXPos + (mouseX - StartMouseX);
  Camera.YPos = StartCameraYPos + (mouseY - StartMouseY);
}





void keyPressed() {
  GUIFunctions.keyPressed();
  if (key < 128) Keys[key] = true;
  if (key == 27) {EscKeyPressed(); key = 0;}
}



void keyReleased() {
  if (key < 128) Keys[key] = false;
}



boolean KeyJustPressed (char Key) {
  return Keys[Key] && !PrevKeys[Key];
}



void mouseWheel (MouseEvent event) {
  GUIFunctions.mouseWheel(event);
  if (MouseIsOverGUI()) return;
  float[] MousePosBeforeScroll = ConvertScreenPosToWorldPos (mouseX, mouseY);
  
  float ScrollAmount = event.getAmount(); // This is deprecated but I don't know what to replace it with
  Camera.Zoom *= pow (2, ScrollAmount * Camera_Scroll_Speed * -1);
  
  float[] MousePosAfterScroll = ConvertScreenPosToWorldPos (mouseX, mouseY);
  float[] MousePosChange = new float[] {
    MousePosAfterScroll[0] - MousePosBeforeScroll[0],
    MousePosAfterScroll[1] - MousePosBeforeScroll[1]
  };
  
  Camera.XPos += MousePosChange[0] * Camera.Zoom; // Zoom towards mouse
  Camera.YPos += MousePosChange[1] * Camera.Zoom;
  
}



void UpdateKeys() {
  arrayCopy (Keys, PrevKeys); // This does PrevKeys = Keys;
  PrevMousePressed = mousePressed;
}
