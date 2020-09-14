public class Camera {
  
  float XPos = 0;
  float YPos = 0;
  float Zoom = 1;
  
  public Camera() {
    Zoom = min (width, height);
    XPos = (width  - Zoom) / 2;
    YPos = (height - Zoom) / 2;
  }
  
}



public class Codon {
  
  int[] Info;
  float Health = 1;
  
  public Codon(){}
  
  public Codon (int[] InfoIn) {
    Info = InfoIn;
  }
  
}



public class CenterBlock {
  
  float XPos;
  float YPos;
  
  public CenterBlock (int BlockX, int BlockY) {
    XPos = BlockX * CellWidth;
    YPos = BlockY * CellHeight;
  }
  
  public void Draw() {
    float Buffer = Render_Buffer_Extension;
    float DBuffer = Buffer * 2;
    fill (Color_Center_Block);
    rect (XPos - Buffer, YPos - Buffer, CellWidth + DBuffer, CellHeight + DBuffer);
  }
  
}
