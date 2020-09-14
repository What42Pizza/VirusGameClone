// Start 09/11/20
// Last updated 09/13/20





// Settings



final int Codon1_None = 0;
final int Codon1_Digest = 1;
final int Codon1_Remove = 2;
final int Codon1_MoveHand = 3;
final int Codon1_Read = 4;
final int Codon1_Write = 5;

final int Codon2_None = 0;
final int Codon2_Food = 1;
final int Codon2_Waste = 2;
final int Codon2_Wall = 3;
final int Codon2_WeakestLocation = 4;
final int Codon2_Inward = 5;
final int Codon2_Outward = 6;
final int Codon2_RGL = 7;



final int[] Starting_Codons = {
  Codon1_Digest  , Codon2_Food,
  Codon1_Remove  , Codon2_Waste,
  Codon1_Write   , Codon2_Wall,
  Codon1_Digest  , Codon2_Food,
  Codon1_Remove  , Codon2_Waste,
  Codon1_Write   , Codon2_Wall,
  Codon1_MoveHand, Codon2_Inward,
  Codon1_MoveHand, Codon2_WeakestLocation,
  Codon1_Read    , Codon2_RGL, 0, 0,
  Codon1_Write   , Codon2_RGL, 0, 0,
  Codon1_MoveHand, Codon2_Outward
};



final int[][] Starting_Cells = new int[][] {
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0},
  {0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
  {0, 1, 1, 0, 1, 2, 2, 1, 0, 1, 1, 0},
  {0, 1, 1, 0, 1, 2, 2, 1, 0, 1, 1, 0},
  {0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0},
  {0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
};



final float CellWidth  = 1.0 / Starting_Cells   .length; // Not settings
final float CellHeight = 1.0 / Starting_Cells[0].length;



final int FrameRate = 60;

final boolean Show_FPS = true;



final float Particle_Wall_Damage            = 1.0 ; // For particle collisions
final float Cell_Energy_Gain_Percent        = 0.33; // For Digest_Food
final float Cell_Energy_Drain_Percent       = 0.5 ; // For Digest_Waste
final float Cell_Wall_Health_Gain_Percent   = 0.33; // For Repair_Wall
final float Cell_Wall_Health_Gain_Cost      = 1.0 ; // X% of health gain takes X% of energy
final float Cell_Wall_Health_Drain_Percent  = 0.5 ; // For Digest_Wall
final float Cell_Wall_Health_Drain_Cost     = 0.5 ; // X% of health gives 0.5X% of energy
final float Cell_Codon_Health_Drain_Percent = 0.33; // For Digest_Inward or Digest_RGL

final int Num_Of_Food_Particles  = 100;
final int Num_Of_Waste_Particles = 80;



final float Food_Particle_Size  = CellWidth * 0.05;
final float Waste_Particle_Size = CellWidth * 0.05;
final float Cell_Interpreter_Hand_Edge_Size = CellWidth * 0.01;
final float Cell_Hand_Lines_Size = CellWidth * 0.02;

final int Particle_Removal_Age = 2 * 60 * 60; // 2 minutes



final color Color_Food_Particle  = color (255, 0, 0);
final color Color_Waste_Particle = color (127, 63, 0);
final color Color_Cell_Wall = color (255, 63, 255);
final color Color_Cell_Hand = color (15, 239, 15);
final color Color_Cell_Hand_Track = color (15, 223, 15);
final color Color_Center_Block = color (191);
final color Color_Cell_Interpreter_Hand = color (191);
final color Color_Cell_Interpreter_Hand_Edge = color (159);
final color Color_Cell_Hand_Lines = color (15, 191, 15);

final color Color_Codon1_None = color (0);
final color Color_Codon1_Digest = color (255, 95, 95);
final color Color_Codon1_Remove = color (255, 0, 0);
final color Color_Codon1_MoveHand = color (95, 255, 95);
final color Color_Codon1_Read  = color (95, 95, 255);
final color Color_Codon1_Write = color (15, 15, 255);

final color Color_Codon2_None = color (0);
final color Color_Codon2_Food = color (255, 0, 0);
final color Color_Codon2_Waste = color (127, 63, 0);
final color Color_Codon2_Wall = color (255, 95, 255);
final color Color_Codon2_WeakestLocation = color (255, 95, 95);
final color Color_Codon2_Inward = color (0, 0, 255);
final color Color_Codon2_Outward = color (95, 95, 255);
final color Color_Codon2_RGL = color (191, 191, 191);

final color Color_Codon_Error = color (255, 0, 255);



final float Camera_Speed = 7;
final float Camera_Scroll_Speed = 0.075;



final float Render_Buffer_Extension = 0.0005;







// Vars

boolean Paused = false;

ArrayList <Particle> FoodParticles  = new ArrayList <Particle> ();
ArrayList <Particle> WasteParticles = new ArrayList <Particle> ();
ArrayList <UGO> UGOs = new ArrayList <UGO> ();
ArrayList <Cell> Cells = new ArrayList <Cell> ();
ArrayList <CenterBlock> CenterBlocks = new ArrayList <CenterBlock> ();

Camera Camera;
Interpreter Interpreter = new Interpreter();
Shape_Renderer ShapeRenderer = new Shape_Renderer();



float[][] CellHandShape;
float[][] CodonShape;
float[][] Codon1Shape;
float[][] Codon2Shape;
float[][] InterpShape;





void setup() {
  
  // Basic setup
  fullScreen();
  background (255);
  frameRate (FrameRate);
  
  // Other setup
  boolean SettingsAreValid = CheckIfSettingsAreValid();
  if (!SettingsAreValid) exit();
  CreateStartingCells();
  for (int i = 0; i < Num_Of_Food_Particles ; i ++) FoodParticles .add (new Particle (ParticleTypes.Food ));
  for (int i = 0; i < Num_Of_Waste_Particles; i ++) WasteParticles.add (new Particle (ParticleTypes.Waste));
  
  CellHandShape = new float[][] {
    {0, CellHeight * -0.32}, // Shape center
    {CellWidth * -0.075, CellHeight * -0.32}, // Bottom left ------------------------ MAKE BACKUP BEFORE CHANGING ANY OF THESE
    {CellWidth *  0.0  , CellHeight * -0.4 }, // Top
    {CellWidth *  0.075, CellHeight * -0.32}  // Bottom right
  };
  
  CodonShape = new float[][] {
    {0, CellHeight * -0.85}, // Shape center
    {CellWidth * -0.03 , CellHeight * -0.06 }, // Bottom left
    {CellWidth * -0.07 , CellHeight * -0.11 }, // Lower top left
    {CellWidth * -0.055, CellHeight * -0.125}, // Higher top left
    {CellWidth *  0.055, CellHeight * -0.125}, // Higher top right
    {CellWidth *  0.07 , CellHeight * -0.11 }, // Lower top right
    {CellWidth *  0.03 , CellHeight * -0.06 }  // Bottom right
  };
  
  Codon1Shape = new float[][] {
    {0, 0}, // Shape center
    {CellWidth * -0.03 , CellHeight * -0.06}, // Bottom left
    {CellWidth * -0.054, CellHeight * -0.09}, // Mid left
    {CellWidth *  0.054, CellHeight * -0.09}, // Mid right
    {CellWidth *  0.03 , CellHeight * -0.06}  // Bottom right
  };
  
  Codon2Shape = new float[][] {
    {0, 0}, // Shape center
    {CellWidth * -0.05 , CellHeight * -0.085}, // Mid left
    {CellWidth * -0.07 , CellHeight * -0.11 }, // Lower top left
    {CellWidth * -0.055, CellHeight * -0.125}, // Higher top left
    {CellWidth *  0.055, CellHeight * -0.125}, // Higher top right
    {CellWidth *  0.07 , CellHeight * -0.11 }, // Lower top right
    {CellWidth *  0.05 , CellHeight * -0.085}  // Mid right
  };
  
  InterpShape = new float[][] {
    {0, 0}, // Shape center
    {0               , 0                 }, // Bottom
    {CellWidth * -0.1, CellHeight * -0.14}, // Top left
    {CellWidth *  0.1, CellHeight * -0.14}, // Top right
    {0               , 0                 }  // Bottom again (needed to connect stroke)
  };
  
}





void draw() {
  int StartingMillis = millis();
  if (Camera == null) Camera = new Camera();
  DrawBackground();
  
  UpdateInputs();
  
  if (!Paused) {
    UpdateFoodParticles();
    UpdateWasteParticles();
    UpdateUGOs();
    UpdateCells();
  }
  
  pushMatrix();
  translate (Camera.XPos, Camera.YPos);
  scale (Camera.Zoom);
  DrawCells();
  DrawCenterBlocks();
  DrawFoodParticles();
  DrawWasteParticles();
  DrawUGOs();
  popMatrix();
  
  UpdateKeys();
  
  if (Show_FPS) DrawFPS(StartingMillis);
  
}
