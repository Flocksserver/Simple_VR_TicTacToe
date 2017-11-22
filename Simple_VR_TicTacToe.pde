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
   //fullScreen(PVR.MONO);
   PFont introFont = createFont("SansSerif", 10 * displayDensity);
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
  text("Welcome to VR Tic-Tac-Toe\nThis is a simple Demo.\nPlease be indulgent with\nyour opponent. I haven't\nimplemented a KI for him, yet.\nPress a button to start.",0,0,300);
}

void mousePressed() {
  if(showIntro){
    showIntro = false;
  }else{
    game.mouseIsPressed = true;
  }
}


  
/**
Algorithm by Amy Williams et.al. (2005) https://dl.acm.org/citation.cfm?id=1198748
from Andres Colubri (2017) Processing for Android ISBN: 978-1-4842-2718-3
**/  
boolean intersectsLine(PVector orig, PVector dir, PVector minPos, PVector maxPos, float minDist, float maxDist, PVector hit){
  PVector bbox;
  PVector invDir = new PVector(1/dir.x, 1/dir.y, 1/dir.z);
  
  boolean signDirX = invDir.x < 0;
  boolean signDirY = invDir.y < 0;
  boolean signDirZ = invDir.z < 0;
  
  bbox = signDirX ? maxPos : minPos;
  float txmin = (bbox.x - orig.x) * invDir.x;
  bbox = signDirX ? minPos : maxPos;
  float txmax = (bbox.x - orig.x) * invDir.x;
  bbox = signDirY ? maxPos : minPos;
  float tymin = (bbox.y - orig.y) * invDir.y;
  bbox = signDirY ? minPos : maxPos;
  float tymax = (bbox.y - orig.y) * invDir.y;
  
  if((txmin > tymax) || (tymin > txmax)){
    return false;
  }
  if(tymin > txmin){
    txmin = tymin;
  }
  if(tymax < txmax){
    txmax = tymax;
  }
  
  bbox = signDirZ ? maxPos : minPos;
  float tzmin = (bbox.z - orig.z) * invDir.z;
  bbox = signDirZ ? minPos : maxPos;
  float tzmax = (bbox.z - orig.z) * invDir.z;
  
  if((txmin > tzmax) || (tzmin > txmax)){
    return false;
  }
  if(tzmin > txmin){
    txmin = tzmin;
  }
  if(tzmax < txmax){
    txmax = tzmax;
  }
  
  if((txmin < maxDist) && (txmax > minDist)){
    hit.x = orig.x + txmin * dir.x;
    hit.y = orig.y + txmin * dir.y;
    hit.z = orig.z + txmin * dir.z;
    return true;
  }
  return false;
  
}