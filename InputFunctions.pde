// Vars



boolean[] Keys     = new boolean [128];
boolean[] PrevKeys = new boolean [128];

boolean MouseJustPressed = false;
boolean MouseJustReleased = false;
boolean PrevMousePressed = false;
boolean MouseIsDragging = false;
boolean MouseWasDragging = false;
boolean MouseStoppedDragging = false;
int StartMouseX = 0;
int StartMouseY = 0;
float StartMouseWorldX = 0;
float StartMouseWorldY = 0;
float StartCameraXPos = 0;
float StartCameraYPos = 0;
int StartMouseButton = 0;





// Functions



void UpdateInputs() {
  
  
  
  // MouseJP && MouseJR
  
  MouseJustPressed = mousePressed && !PrevMousePressed;
  
  MouseJustReleased = false; // This is one of the first functions called in draw(), so this should be okay
  if (!mousePressed && PrevMousePressed) {
    int DeltaX = StartMouseX - mouseX;
    int DeltaY = StartMouseY - mouseY;
    if (abs (DeltaX) < 3 && abs (DeltaY) < 3) {
      MouseJustReleased = true;
    }
  }
  
  
  
  // Dragging
  
  if (MouseJustPressed && !MouseIsOverGUI()) StartMouseDrag();
  
  if (!mousePressed) MouseIsDragging = false;
  
  if (MouseIsDragging && StartMouseButton == RIGHT) MoveCameraToMouse();
  MouseStoppedDragging = MouseWasDragging && !MouseIsDragging;
  
  
  
  // Updating keys
  
  if (KeyJustPressed(' ')) Paused = !Paused;
  
  if (Keys['w']) Camera.YPos += Camera_Speed;
  if (Keys['a']) Camera.XPos += Camera_Speed;
  if (Keys['s']) Camera.YPos -= Camera_Speed;
  if (Keys['d']) Camera.XPos -= Camera_Speed;
  
  
  
}





void StartMouseDrag() {
  MouseIsDragging = true;
  StartMouseX = mouseX;
  StartMouseY = mouseY;
  StartCameraXPos = Camera.XPos;
  StartCameraYPos = Camera.YPos;
  float[] StartWorldPos = ConvertScreenPosToWorldPos (mouseX, mouseY);
  StartMouseWorldX = StartWorldPos[0];
  StartMouseWorldY = StartWorldPos[1];
  StartMouseButton = mouseButton;
}



void MoveCameraToMouse() {
  Camera.XPos = StartCameraXPos + (mouseX - StartMouseX);
  Camera.YPos = StartCameraYPos + (mouseY - StartMouseY);
}





void keyPressed() {
  GUIFunctions.keyPressed();
  if (key < 128) Keys[key] = true;
  if (key == 27) {EscKeyPressed(); key = 0;}
  if (keyCode == UP) UpdatesPerFrame = min (1024, UpdatesPerFrame * 2);
  if (keyCode == DOWN) UpdatesPerFrame = max (1, UpdatesPerFrame / 2);
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
  MouseWasDragging = MouseIsDragging;
}
