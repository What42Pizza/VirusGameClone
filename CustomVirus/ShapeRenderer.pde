public class Shape_Renderer {
  
  public void Render (float[][] In, float XPos, float YPos) {
    beginShape();
    for (int i = 1; i < In.length; i ++) { // Start at 1 to skip shape center
      vertex (In[i][0] + XPos, In[i][1] + YPos);
    }
    endShape();
  }
  
  public void Render (float[][] In, float XPos, float YPos, float Angle) {
    beginShape();
    for (int i = 1; i < In.length; i ++) { // Start at 1 to skip shape center
      float[] Vertex = new float[] {In[i][0], In[i][1]};
      float[] RotatedVertex = RotateVertex (Vertex, Angle);
      vertex (RotatedVertex[0] + XPos, RotatedVertex[1] + YPos);
    }
    endShape();
  }
  
  public void Render (float[][] In, float XPos, float YPos, float Angle, float XSquish, float YSquish) {
    beginShape();
    for (int i = 1; i < In.length; i ++) { // Start at 1 to skip shape center
      float[] Vertex = new float[] {
        XSquish != 0 ? In[i][0] / XSquish : 0,
        YSquish != 0 ? In[i][1] / YSquish : 0
      };
      float[] RotatedVertex = RotateVertex (Vertex, Angle);
      vertex (RotatedVertex[0] + XPos, RotatedVertex[1] + YPos);
    }
    endShape();
  }
  
  
  
  public void Render (float[][] In, float XPos, float YPos, float Angle, float CenterAngle) {
    beginShape();
    for (int i = 1; i < In.length; i ++) { // Start at 1 to skip shape center
      float[] Vertex = new float[] {In[i][0], In[i][1]};
      Vertex[0] -= In[0][0];
      Vertex[1] -= In[0][1];
      Vertex = RotateVertex (Vertex, CenterAngle);
      Vertex[0] += In[0][0];
      Vertex[1] += In[0][1];
      float[] RotatedVertex = RotateVertex (Vertex, Angle);
      vertex (RotatedVertex[0] + XPos, RotatedVertex[1] + YPos);
    }
    endShape();
  }
  
  
  
  public float[] RotateVertex (float[] Vertex, float Angle) {
    return new float[] {
      Vertex[0] * cos(Angle) - Vertex[1] * sin(Angle), // Rotation formulas are from https://math.stackexchange.com/questions/270194/how-to-find-the-vertices-angle-after-rotation
      Vertex[0] * sin(Angle) + Vertex[1] * cos(Angle)
    };
  }
  
  
  
}
