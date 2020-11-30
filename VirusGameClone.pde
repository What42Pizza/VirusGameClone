// Start 09/11/20
// Last updated 11/30/20





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
final int Codon2_UGO = 8;



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
  Codon1_MoveHand, Codon2_Outward,
};



final String[] Codon1_Names = {
  "None",
  "Digest",
  "Remove",
  "Move Hand",
  "Read",
  "Write",
};



final String[] Codon2_Names = {
  "None",
  "Food",
  "Waste",
  "Wall",
  "Weakest Loc",
  "Inward",
  "Outward",
  "RGL",
  "UGO",
};



final int[][] Starting_Cells = {
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



/*
// This was used for the logo
final int[] Starting_Codons = {
  Codon1_MoveHand, Codon2_Inward,
  Codon1_MoveHand, Codon2_RGL, 0, 0,
  Codon1_Read    , Codon2_RGL, -1, 3,
  Codon1_MoveHand, Codon2_Outward,
  Codon1_Write   , Codon2_UGO
};

final int[][] Starting_Cells = {{1}};
//*/



final int Frame_Rate = 60;

final boolean Debug_Show_FPS           = true ;
final boolean Debug_Show_Millis        = true ;
final boolean Debug_Super_Speed        = false; // Use this to go really fast (use can also comment out fullScreen() to make it go faster)
final boolean Debug_Explain_Cell_Death = false;



final float CellWidth  = 1.0 / Starting_Cells   .length        ; // Not settings
final float CellHeight = 1.0 / Starting_Cells[0].length        ;
final float FrameRate  = Debug_Super_Speed ? 10000 : Frame_Rate;



final float Particle_Wall_Damage            = 0.5 ; // For particle collisions ---------------------------------------------------------------------------- Balance these
final float Cell_Energy_Gain_Percent        = 0.33; // For Digest_Food
final float Cell_Energy_Drain_Percent       = 0.5 ; // For Digest_Waste
final float Cell_Energy_Loss_Percent        = 0.3 ; // For just existing
final float Cell_Interpreter_Cost           = 2   ; // X% of energy is removed per codon interp
final float Cell_Wall_Health_Gain_Percent   = 0.33; // For Repair_Wall
final float Cell_Wall_Health_Gain_Cost      = 0.5 ; // X% of health gain takes X*this% of energy
final float Cell_Wall_Health_Drain_Percent  = 0.5 ; // For Digest_Wall
final float Cell_Wall_Health_Drain_Cost     = 0.33; // X% of health gives X*this% of energy
final float Cell_Codon_Health_Drain_Percent = 0.33; // For Digest_Inward or Digest_RGL
final float Cell_Codon_Damage_Percent_Low   = 0.01; // Random codon damage per update (low)
final float Cell_Codon_Damage_Percent_High  = 0.02; // Random codon damage per update (high)
final float Cell_Codon_Write_Cost           = 1.4 ; // For Write_

final int Num_Of_Food_Particles  = 350;
final int Num_Of_Waste_Particles = 200;



final float Food_Particle_Size  = CellWidth * 0.05;
final float Waste_Particle_Size = CellWidth * 0.05;
final float Cell_Interpreter_Hand_Edge_Size = CellWidth * 0.01;
final float Cell_Hand_Lines_Size = CellWidth * 0.02;

final int Particle_Removal_Age = 2 * 60 * 60; // 2 minutes



final color Color_Food_Particle  = color (255, 0, 0);
final color Color_Waste_Particle = color (127, 63, 0);
final color Color_Cell_Background = color (255, 191, 255);
final color Color_Cell_Background_Modified = color (255, 191, 0);
final color Color_Cell_Background_Selected = color (95, 223, 255);
final color Color_Cell_Wall = color (159, 95, 191);
final color Color_Cell_Hand = color (15, 239, 15);
final color Color_Cell_Hand_Track = color (15, 223, 15);
final color Color_Cell_Energy_Symbol = color (255, 255, 0);
final color Color_Cell_Interpreter_Hand = color (191);
final color Color_Cell_Interpreter_Hand_Edge = color (159);
final color Color_Cell_Hand_Lines = color (15, 191, 15);
final color Color_Center_Block = color (191);

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
final color Color_Codon2_UGO = color (255, 0, 0);

final color Color_Codon_Error = color (255, 0, 255);



final float Camera_Speed = 10;
final float Camera_Scroll_Speed = 0.075;



final float Render_Buffer_Extension = 0.0005;





final float[][] Cell_Hand_Shape = {
  {0, CellHeight * -0.32}, // Shape center
  {CellWidth * -0.075, CellHeight * -0.32}, // Bottom left ------------------------------------------------------------------------------- MAKE BACKUP BEFORE CHANGING ANY OF THESE
  {CellWidth *  0.0  , CellHeight * -0.4 }, // Top            // Update Cell.GetHandPoint() line 2 if the tip of the hand is changed
  {CellWidth *  0.075, CellHeight * -0.32}  // Bottom right
};


final float[][] Codon_Shape = {
  {0, CellHeight * -0.85}, // Shape center
  {CellWidth * -0.03 , CellHeight * -0.0601}, // Bottom left
  {CellWidth * -0.07 , CellHeight * -0.1099}, // Lower top left
  {CellWidth * -0.055, CellHeight * -0.1249}, // Higher top left
  {CellWidth *  0.055, CellHeight * -0.1249}, // Higher top right
  {CellWidth *  0.07 , CellHeight * -0.1099}, // Lower top right
  {CellWidth *  0.03 , CellHeight * -0.0601}  // Bottom right
};


final float[][] Codon1_Shape = {
  {0, 0}, // Shape center
  {CellWidth * -0.03 , CellHeight * -0.06}, // Bottom left
  {CellWidth * -0.054, CellHeight * -0.09}, // Mid left
  {CellWidth *  0.054, CellHeight * -0.09}, // Mid right
  {CellWidth *  0.03 , CellHeight * -0.06}  // Bottom right
};


final float[][] Codon2_Shape = {
  {0, 0}, // Shape center
  {CellWidth * -0.05 , CellHeight * -0.085}, // Mid left
  {CellWidth * -0.07 , CellHeight * -0.11 }, // Lower top left
  {CellWidth * -0.055, CellHeight * -0.125}, // Higher top left
  {CellWidth *  0.055, CellHeight * -0.125}, // Higher top right
  {CellWidth *  0.07 , CellHeight * -0.11 }, // Lower top right
  {CellWidth *  0.05 , CellHeight * -0.085}  // Mid right
};


final float[][] Interpreter_Shape = {
  {0, 0}, // Shape center
  {0               , 0                 }, // Bottom
  {CellWidth * -0.1, CellHeight * -0.14}, // Top left
  {CellWidth *  0.1, CellHeight * -0.14}, // Top right
  {0               , 0                 }  // Bottom again (needed to connect stroke)
};


final float[][] Cell_Energy_Symbol = {
  {0, 0}, // Shape center
  {CellWidth * -0.005, CellHeight *  0.037}, // Bottom
  {CellWidth *  0.004, CellHeight *  0.003}, // Middle bottom right
  {CellWidth * -0.025, CellHeight *  0.003}, // Middle bottom left
  {CellWidth * -0.015, CellHeight * -0.037}, // Top left
  {CellWidth *  0.01 , CellHeight * -0.037}, // Top right
  {CellWidth *  0.00 , CellHeight * -0.012}, // Middle top left
  {CellWidth *  0.025, CellHeight * -0.012}  // Middle top right
};










// Vars

boolean Paused = false;

ArrayList <Particle> FoodParticles  = new ArrayList <Particle> ();
ArrayList <Particle> WasteParticles = new ArrayList <Particle> ();
ArrayList <UGO> UGOs = new ArrayList <UGO> ();
ArrayList <Cell> Cells = new ArrayList <Cell> ();
ArrayList <CenterBlock> CenterBlocks = new ArrayList <CenterBlock> ();

int AliveCells;
int DeadCells;
int ModifiedCells;

Camera Camera;
Interpreter Interpreter = new Interpreter();
Shape_Renderer ShapeRenderer = new Shape_Renderer();

Cell[][] CellsGrid;
CenterBlock[][] CenterBlocksGrid;










void setup() {
  
  // Basic setup
  fullScreen();
  //size (512, 512);
  background (255);
  frameRate (FrameRate);
  
  // Other setup
  boolean SettingsAreValid = CheckIfSettingsAreValid();
  AliveCells = CountAliveCells (Starting_Cells);
  if (!SettingsAreValid) exit();
  CreateStartingCells();
  for (int i = 0; i < Num_Of_Food_Particles ; i ++) FoodParticles .add (new Particle (ParticleTypes.Food ));
  for (int i = 0; i < Num_Of_Waste_Particles; i ++) WasteParticles.add (new Particle (ParticleTypes.Waste));
  InitGUI();
  
  /*
  ArrayList <Codon> UGOCodons = new ArrayList <Codon> ();
  UGOCodons.add (new Codon (new int[] {Codon1_MoveHand, Codon2_Inward    }));
  UGOCodons.add (new Codon (new int[] {Codon1_MoveHand, Codon2_RGL,  0, 0}));
  UGOCodons.add (new Codon (new int[] {Codon1_Read    , Codon2_RGL, -1, 4}));
  UGOCodons.add (new Codon (new int[] {Codon1_MoveHand, Codon2_Outward   }));
  UGOCodons.add (new Codon (new int[] {Codon1_Write   , Codon2_UGO       }));
  UGOCodons.add (new Codon (new int[] {Codon1_Remove  , Codon2_UGO       }));
  UGOs.add (new UGO (0.05, 0.05, UGOCodons, false));
  */
  
}





void draw() {
  int TotalStartMillis = millis();
  if (Camera == null) Camera = new Camera();
  noStroke();
  
  DrawBackground();
  
  UpdateInputs();
  
  /*
  if (!Paused) { // Tells you how many microseconds each update type is taking
    println();
    
    long StartTime = System.nanoTime();
    UpdateFoodParticles();
    long NewTime = System.nanoTime();
    println ("Food: " + (NewTime - StartTime) / 1000);
    
    StartTime = NewTime;
    UpdateWasteParticles();
    NewTime = System.nanoTime();
    println ("Waste: " + (NewTime - StartTime) / 1000);
    
    StartTime = NewTime;
    UpdateUGOs();
    NewTime = System.nanoTime();
    println ("UGOs: " + (NewTime - StartTime) / 1000);
    
    StartTime = NewTime;
    UpdateCells();
    NewTime = System.nanoTime();
    println ("Cells: " + (NewTime - StartTime) / 1000);
    
  }
  */
  
  int UpdateStartMillis = millis();
  if (!Paused) {
    UpdateFoodParticles();
    UpdateWasteParticles();
    UpdateUGOs();
    UpdateCells();
  }
  UpdateGUIs();
  
  int DrawStartMillis = millis();
  int UpdateMillis = DrawStartMillis - UpdateStartMillis; // End - start; DrawStart = UpdateEnd
  
  if (!Debug_Super_Speed || (Debug_Super_Speed && Paused)) { // Disable rendering during super speed
    pushMatrix();
    translate (Camera.XPos, Camera.YPos);
    scale (Camera.Zoom);
    DrawCells();
    DrawCenterBlocks();
    DrawFoodParticles();
    DrawWasteParticles();
    DrawUGOs();
    popMatrix();
    RenderGUIs();
  }
  
  UpdateKeys();
  
  int NewMillis = millis();
  int DrawMillis = NewMillis - DrawStartMillis;
  int TotalMillis = NewMillis - TotalStartMillis;
  
  DrawFPSAndMillis (UpdateMillis, DrawMillis, TotalMillis);
  
}
