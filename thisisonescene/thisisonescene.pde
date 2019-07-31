/*
 * This is an invitation to the Assembly Summer 2019 One Scene Compo
 * This invitation happens to also be an example of what a one scene demo means
 * See the actual compo rules here (COMPO SPECIFIC RULES -> Real Time compos -> One Scene competition): https://www.assembly.org/summer19/demoscene/rules
 */

// Import external functions here:

// Moonlander is a library for integrating Processing with GNU Rocket, https://github.com/anttihirvonen/moonlander
// GNURocket is a tool for synchronizing music and visuals in demoscene productions: https://github.com/rocket/rocket
import moonlander.library.*;
// Audio library for playing sound, http://code.compartmental.net/minim/
import ddf.minim.*;

// Some demo global variables 

// the time in seconds (taken from Moonlander / GNURocket)
float now = 0.0;

// These control how big the opened window is.
// Assembly has FullHD (a.k.a. 1080p, a.k.a. 1920x1080) maximum projector resolution
// ref. https://www.assembly.org/summer19/demoscene/rules
float CANVAS_WIDTH = 1920;
float CANVAS_HEIGHT = 1080;

Moonlander moonlander;

PShape gear;
PShape asmLogo;

PFont font;

PImage overlay;
String[] overlayFileNames = {
  "overlay2.png",
  "overlay3.png",
  "overlay4.png",
  "overlay5.png",
  "credits.png",
  "logo.png"
};
PImage[] overlayImages = new PImage[overlayFileNames.length];

String[] texts = {
  "We invite you to",
  "to compete in ONE SCENE COMPO",
  "60 seconds, one constant scene",
  "There will be workshop with assistants",
  "in the Scene Lounge",
  "Greetings fly out to",
  "Bad Felix",
  "Experimental Graphics Research Group",
  "Peisik",
  "Substandard",
  "Funny Curly Cat Code Factory",
  "Jumalauta",
  "Bjakke",
  "Qma",
  "Sooda",
  "Dekadence",
  "Nalleperhe",
  "Trilobit",
  "Adapt",
  "Paraguay",
  "MFX",
  "Byterapers",
  "Wide Load",
  "Prismbeings",
  "Conspiracy",
  "The Black Lotus",
  "Darklite",
  "Extend",
  "Primitive",
  "and you <3"
};

/*
 * Initialize the window
 */
void settings() {
  size((int)CANVAS_WIDTH,(int)CANVAS_HEIGHT, P3D);

  //Set the window fullscreen
  fullScreen();
}

/*
 * Load all assets in the demo
 */
void setup() {
  int fps = 60;
  // Assembly has 60Hz maximum projector framerate, ref. https://www.assembly.org/summer19/demoscene/rules
  frameRate(fps);

  // Loads 3D mesh. OBJ format can be created with, for example, Blender 3D program: https://www.blender.org/
  gear = loadShape("gear.obj");
  asmLogo = loadShape("assylogo.obj");
  
  // Load the font
  // NOTE: You can use system available fonts like "MS Comic Sans" but that usually makes your production less cross-platform
  //       hence we'd recommend to save the font as an asset to the production.
  //       Just remember that font creators have copyrights, so the license needs to be appropriate to use in a demo.
  
  font = createFont("Inter-ExtraLight-BETA.ttf", 200);

  // Load all images
  overlay = loadImage("overlay1.png");

  for (int i=0; i < overlayImages.length; i++){
    overlayImages[i] = loadImage(overlayFileNames[i]);
  }
  
  //hide mouse cursor
  noCursor();

  // Init & start moonlander
  int bpm = 120; // Tune's beats per minute
  int rowsPerBeat = 4; // How many rows one beat consists of in the sync editor (GNURocket or so)
  moonlander = Moonlander.initWithSoundtrack(this, "20190608_graffathon_onescene.mp3", bpm, rowsPerBeat);
  moonlander.start();
}


/*
 * The classic rotating cube from the begin
 */
void drawCube() {
  if (moonlander.getValue("cube:fill_alpha") <= 0.0 && moonlander.getValue("cube:line_alpha") <= 0.0) {
    //cube's line and fill alphas are zero or less, so let's skip trying to draw the cube at all
    return;
  }
  
  //pushMatrix / popMatrix functions ensure that matrix operations like rotation/translation/scaling will only happen inside the push/pop
  //so matrix operations called in between won't affect other 3D or 2D stuff drawn in the screen

  pushMatrix();

  // Matrices are calculated in an inverse order.
  // So matrix is calculated as rotate Z -> rotate Y -> rotate X -> translate -> (scale -> translate)
  // Note: last two steps, scale and translate, are called in draw() function

  // Move cube
  translate((float)moonlander.getValue("cube:x"), (float)moonlander.getValue("cube:y"), (float)moonlander.getValue("cube:z"));

  // Cube rotation is in degrees.
  // Note that usually rotation is done using radians but you can convert degrees to radians with the function radians()
  rotateX(radians((float)moonlander.getValue("cube:rotateX")));
  rotateY(radians((float)moonlander.getValue("cube:rotateY")));
  rotateZ(radians((float)moonlander.getValue("cube:rotateZ")));
  
  // black cube
  fill(0,0,0,(int)(moonlander.getValue("cube:fill_alpha") * 255));
  box((float)moonlander.getValue("cube:width"), (float)moonlander.getValue("cube:height"), (float)moonlander.getValue("cube:depth"));
  
  // white cube
  fill(255,255,255,(int)(moonlander.getValue("cube:line_alpha") * 255));
  box((float)moonlander.getValue("cube:width"), (float)moonlander.getValue("cube:height"), (float)moonlander.getValue("cube:depth"));

  popMatrix();
}

/*
 * Draw the gears/cogwheels that are visible throughout the demo
 */
void drawGears() {
  pushMatrix();

  // global positioning of all the gears
  translate((float)moonlander.getValue("gear:x"), (float)moonlander.getValue("gear:y"), (float)moonlander.getValue("gear:z"));
  
  gear.setFill(color(255, 255, 255, (int)(moonlander.getValue("gear:fill_alpha") * 255)));

  for(int i = 0; i < 5; i++) {
    pushMatrix();

    // odd/even gears should be placed apart in Y axis and rotate to different directions
    // to give a feeling that the wheels are moving each other
    float direction = 1.0;
    float y = (float)moonlander.getValue("gear:spacing_y1");
    if (i%2 == 0) {
      direction = -1.0;
      y = (float)moonlander.getValue("gear:spacing_y2");
    }
    
    // Note that matrix operations are in "reverse order" of the functions.
    // => So first scale, then rotateZ and then translate
    // => Things will look different if you change the function calling order, go ahead and try!

    //position gear in a "row"
    translate(i*(float)moonlander.getValue("gear:spacing"), y, 0);
    //rotate the gear, positive number is clock-wise and negative is counter clock-wise
    rotateZ(now * direction);
    //scale the gear
    scale((float)moonlander.getValue("gear:scale"));
    //draw the gear
    shape(gear);

    popMatrix();
  }
  popMatrix();
}

/*
 * Draw the 3D Assembly logo that is seen in the greetings part
 */
void drawAsmLogo() {
  if((float)moonlander.getValue("asmlogo:scale") <= 0.0) {
    return;
  }
  
  pushMatrix();
  
  translate((float)moonlander.getValue("asmlogo:x"), (float)moonlander.getValue("asmlogo:y"), (float)moonlander.getValue("asmlogo:z"));
  
  rotateX(PI*(float)moonlander.getValue("asmlogo:rotatex")/180);
  rotateY(PI*(float)moonlander.getValue("asmlogo:rotatey")/180);
  rotateZ(PI*(float)moonlander.getValue("asmlogo:rotatez")/180);
  
  scale((float)moonlander.getValue("asmlogo:scale"));
  
  shape(asmLogo);

  popMatrix();
}

/*
 * Draw window size 2D overlays throughout the demo
 */
void drawOverlays() {
  pushMatrix();

  // draw the stable overlay that is shown throughout the demo. image's color alpha is varying according to the beat
  tint(255,255,255,(int)(moonlander.getValue("overlay:alpha1") * 255));
  image(overlay, -CANVAS_WIDTH/2, -CANVAS_HEIGHT/2);

  // draw the overlays that are shown only shortly. image to be displayed and its alpha is defined in Rocket
  int overLayImageNumber = (int)moonlander.getValue("overlay:image") % overlayImages.length;
  if (overLayImageNumber >= 0) {
    tint(255,255,255,(int)(moonlander.getValue("overlay:alpha2") * 255));
    image(overlayImages[overLayImageNumber], -CANVAS_WIDTH/2 + (int)moonlander.getValue("overlay:x"), -CANVAS_HEIGHT/2 + (int)moonlander.getValue("overlay:y"));
  }

  popMatrix();
}

/*
 * Draw compo information and greetings texts
 */
void drawText() {
  if (moonlander.getValue("font:text") >= 0) {
    pushMatrix();
    scale((float)moonlander.getValue("font:scale"));
    textAlign(CENTER, CENTER);
    textFont(font);
    fill((int)(moonlander.getValue("font:r") * 255),(int)(moonlander.getValue("font:g") * 255),(int)(moonlander.getValue("font:b") * 255),(int)(moonlander.getValue("font:a") * 255));
    text(texts[(int)moonlander.getValue("font:text")%texts.length], (int)moonlander.getValue("font:x"), (int)moonlander.getValue("font:y"));
    popMatrix();
  }
}

/*
 * This function is called every time a screen is drawn, ideally that would be 60 times per second
 */
void draw() {
  // update Rocket sync data  
  moonlander.update();

  now = (float)moonlander.getCurrentTime();
  float end = 60.0; //end production after 60 secs which is the maximum time allowed by the One Scene Compo
  if (now > end) {
    exit();
  }
  
  // Set the background color
  background((int)(moonlander.getValue("bg:r") * 255),(int)(moonlander.getValue("bg:g") * 255),(int)(moonlander.getValue("bg:b") * 255),(int)(moonlander.getValue("bg:a") * 255));
  
  /*
   * Center coordinates to screen and make the window and canvas resolution independent
   * This is because actual window in full screen on a 4K monitor has more pixels than FullHD resolution
   * so scaling is needed to ensure that all objects (3D and 2D) are in correct places regardless of the desktop resolution
   */
  translate(width/2, height/2, 0);
  scale(width/CANVAS_WIDTH,height/CANVAS_HEIGHT,width/CANVAS_WIDTH);

  // Enable lights and depth testing to ensure that 3D meshes are drawn in correct order
  lights();
  hint(ENABLE_DEPTH_TEST);

  drawGears();

  drawCube();
  
  drawAsmLogo();

  // disable lights and depth testing so that 2D overlays and text can be draw on top of 3D
  noLights();
  hint(DISABLE_DEPTH_TEST);

  drawText();

  drawOverlays();
}
