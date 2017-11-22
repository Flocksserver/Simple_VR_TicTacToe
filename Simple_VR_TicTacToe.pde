import processing.vr.*;

PMatrix3D eyeMat = new PMatrix3D();
PMatrix3D objMat = new PMatrix3D();
PVector cam = new PVector();
PVector dir = new PVector();
PVector front = new PVector();
PVector objCam = new PVector();
PVector objFront = new PVector();
PVector objDir = new PVector();

TTTGame game;
boolean showIntro = true;

void setup(){
   fullScreen(PVR.STEREO);
   PFont introFont = createFont("SansSerif", 12 * displayDensity);
   textFont(introFont);
   textAlign(CENTER, CENTER);
   game = new TTTGame();
}

void draw(){
  getEyeMatrix(eyeMat);
  cam.set(eyeMat.m03, eyeMat.m13, eyeMat.m23);
  dir.set(eyeMat.m02, eyeMat.m12, eyeMat.m22);
  PVector.add(cam, dir, front);
  background(0);
  translate(width/2, height/2);
  lights();
  if(showIntro){
    displayIntro();
  }else{
    game.display();
  }
}

void displayIntro(){
  eye();
  fill(255);
  text("Welcome to VR Tic-Tac-Toe\nThis is my litte Demo.\nPlease be indulgent with your\nopponent. I haven't implemented\na KI for him, yet.\nPress a button to start.",0,0,300);
}

void mousePressed() {
  if(showIntro){
    showIntro = false;
  }else{
    game.mouseIsPressed = true;
  }
}