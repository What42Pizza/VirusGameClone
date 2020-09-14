public class Shape_Renderer {
  
  void Render (float[][] In, float XPos, float YPos) {
    beginShape();
    for (int i = 0; i < In.length; i ++) {
      vertex (In[i][0] + XPos, In[i][1] + YPos);
    }
    endShape();
  }
  
  void Render (float[][] In, float XPos, float YPos, float Angle) {
    beginShape();
    for (int i = 0; i < In.length; i ++) {
      float X = In[i][0];
      float Y = In[i][1];
      vertex (
        X * cos(Angle) - Y * sin(Angle) + XPos, // Rotation formulas are from https://math.stackexchange.com/questions/270194/how-to-find-the-vertices-angle-after-rotation
        X * sin(Angle) + Y * cos(Angle) + YPos
      );
    }
    endShape();
  }
  
  void Render (float[][] In, float XPos, float YPos, float Angle, float XSquish) {
    beginShape();
    for (int i = 0; i < In.length; i ++) {
      float X = In[i][0] / XSquish;
      float Y = In[i][1];
      vertex (
        X * cos(Angle) - Y * sin(Angle) + XPos, // Rotation formulas are from https://math.stackexchange.com/questions/270194/how-to-find-the-vertices-angle-after-rotation
        X * sin(Angle) + Y * cos(Angle) + YPos
      );
    }
    endShape();
  }
  
  void Render (float[][] In, float XPos, float YPos, float Angle, float XSquish, float YSquish) {
    beginShape();
    for (int i = 0; i < In.length; i ++) {
      float X = In[i][0] / XSquish;
      float Y = In[i][1] / YSquish;
      vertex (
        X * cos(Angle) - Y * sin(Angle) + XPos, // Rotation formulas are from https://math.stackexchange.com/questions/270194/how-to-find-the-vertices-angle-after-rotation
        X * sin(Angle) + Y * cos(Angle) + YPos
      );
    }
    endShape();
  }
  
}
