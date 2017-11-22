package processing.test.simple_vr_tictactoe;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.vr.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Simple_VR_TicTacToe extends PApplet {



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

public void setup(){
   
   PFont introFont = createFont("SansSerif", 10 * displayDensity);
   textFont(introFont);
   textAlign(CENTER, CENTER);
   game = new TTTGame();
}

public void draw(){
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

public void displayIntro(){
  eye();
  fill(255);
  text("Welcome to VR Tic-Tac-Toe\nThis is my litte Demo.\nPlease be indulgent with\nyour opponent. I haven't\nimplemented a KI for him, yet.\nPress a button to start.",0,0,300);
}

public void mousePressed() {
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
public boolean intersectsLine(PVector orig, PVector dir, PVector minPos, PVector maxPos, float minDist, float maxDist, PVector hit){
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
class TTTAim{
  PShape aim;
  TTTAim(){
    aim = new PShape();
  }
  public void display(){
  pushMatrix();
  eye();
  translate(0,0,100);
  stroke(255);
  noFill();
  aim = createShape(ELLIPSE, 0, 0, 4, 4);
  aim.setStrokeWeight(2);
  aim.setStroke(color(255,255,255));
  shape(aim);
  popMatrix();
}
}
class TTTBox{
  
  PShape box;
  TTTGameState state;
  boolean isSelected = false;
  String used = "";
  boolean animate = false;
  boolean animateInk = true; 
  boolean animateDek = false; 
  float animateZ = 0;
  int mainColor = color(0xff00bfff);
  int secondColor = color(0xffff4000);

  float boxSize;
  float offset;
  PVector boxMin;
  PVector boxMax;
  PVector hit = new PVector();
  PShape line1;
  PShape line2;
  PShape circle;
      
  TTTBox(TTTGameState s){
    state = s;
    boxSize = width/12;
    offset = boxSize/6;
    boxMin = new PVector(-boxSize/2, -boxSize/2, -boxSize/2);
    boxMax = new PVector(+boxSize/2, +boxSize/2, +boxSize/2);
    rectMode(CENTER);
    box = createShape(RECT, 0, 0, boxSize, boxSize);
  }
  
  public void display(int x, int y){
      pushMatrix();
      float rX = 0+(x-1)*(boxSize+offset);
      float rY = 0+(y-1)*(boxSize+offset);
      translate(rX,rY);
      getObjectMatrix(objMat);
      objMat.mult(cam, objCam);
      objMat.mult(front, objFront);
      PVector.sub(objFront, objCam, objDir);
      boolean res = intersectsLine(objCam, objDir, boxMin, boxMax, 0, 1000, hit);
      box.setFill(mainColor);
      box.setStroke(mainColor);
      isSelected = false;
      
       if(animate){
        if(animateZ == 0){
           animateInk = true;
           animateDek = false; 
        }
        if(animateZ == 40){
           animateInk = false;
           animateDek = true; 
        }
        if(animateInk){
          animateZ ++;
        }
        if(animateDek){
          animateZ --;
        }
      }
      
      if(res && used == "" && !state.finish){
        box.setStrokeWeight(5);
        box.setStroke(secondColor);
        isSelected = true;
      }
      
      
      noFill();
      strokeWeight(5);
      stroke(secondColor);
      if(used == "x"){
        float lOffset = 5;
        float l1x1 = box.getVertexX(0)+lOffset;
        float l1y1 = box.getVertexY(0)+lOffset;
        float l1x2 = box.getVertexX(2)-lOffset;
        float l1y2 = box.getVertexY(2)-lOffset;
        line1 = createShape(LINE, l1x1, l1y1, l1x2, l1y2);
        if(animate){
          line1.translate(0,0,animateZ);
        }
        shape(line1);
        float l2x1 = box.getVertexX(1)-lOffset;
        float l2y1 = box.getVertexY(1)+lOffset;
        float l2x2 = box.getVertexX(3)+lOffset;
        float l2y2 = box.getVertexY(3)-lOffset;
        line2 = createShape(LINE, l2x1, l2y1, l2x2, l2y2);
        if(animate){
          line2.translate(0,0,animateZ);
        }
        shape(line2);
      }
      if(used == "o"){
        ellipseMode(CENTER);
        float oOffset = 5;
        float oX = (box.getVertexX(1)+(box.getVertexX(0)))/2;
        float oY = (box.getVertexY(3)+(box.getVertexY(0)))/2;
        float oSize = boxSize-oOffset;
        circle = createShape(ELLIPSE, oX,oY, oSize, oSize);
        if(animate){
          circle.translate(0,0,animateZ);
        }
        shape(circle);
      }
              

      if(animate){
        translate(0,0,animateZ);
      }
      
      shape(box);
      popMatrix();
  
  }

  public void reset(){
    isSelected = false;
    used = "";
    animate = false;
    animateInk = true; 
    animateDek = false; 
    animateZ = 0;
  }
  
}
class TTTGame{
 
  /*
  0/0 1/0 2/0
  0/1 1/1 2/1
  0/2 1/2 2/2
  */
  TTTBox[][] gameGrid = new TTTBox[3][3];
  TTTAim aim;
  TTTGameState state;
  TTTRestartButton restartButton;
  boolean mouseIsPressed = false;

  int yourScore = 0;
  int computerScore = 0;

  TTTGame(){
   aim = new TTTAim();
   
   state = new TTTGameState();
   
   gameGrid[0][0] = new TTTBox(state);
   gameGrid[1][0] = new TTTBox(state);
   gameGrid[2][0] = new TTTBox(state);
    
   gameGrid[0][1] = new TTTBox(state);
   gameGrid[1][1] = new TTTBox(state);
   gameGrid[2][1] = new TTTBox(state);
   
   gameGrid[0][2] = new TTTBox(state);
   gameGrid[1][2] = new TTTBox(state);
   gameGrid[2][2] = new TTTBox(state);
   
   restartButton = new TTTRestartButton();

  }
  
  public void display(){
      for (int i = 0; i < gameGrid.length; i++) {
       for (int j = 0; j < gameGrid[i].length; j++) {
         gameGrid[i][j].display(i,j);
        }
      }
      aim.display();
      TTTBox selected = getSelectedBox();
      if(mouseIsPressed && selected != null){
          mouseIsPressed = false;
          selected.used = "x";
          isGameOver();
          if(!state.finish){
            doOpponentAction();
            isGameOver();
          }
      }
      if(state.finish){
        for(int i = 0 ; i < state.winningBoxes.length; i++){
          state.winningBoxes[i].animate = true;
        }
        restartButton.display();
         if(mouseIsPressed && restartButton.isSelected){
           mouseIsPressed = false;
           restartGame(); 
         }
      }      
  }
  
  
    public void doOpponentAction(){
     ArrayList<TTTBox> list = new ArrayList<TTTBox>();
     for (int i = 0; i < gameGrid.length; i++) {
     for (int j = 0; j < gameGrid[i].length; j++) {
         if(gameGrid[i][j].used == ""){
           list.add(gameGrid[i][j]);
         }
      }
    }
    if(list.size() > 0){
      float number = random(list.size()-1);
      list.get((int)number).used = "o";
    }
  }
 
  public TTTBox getSelectedBox(){
    TTTBox selected = null;
    for (int i = 0; i < gameGrid.length; i++) {
     for (int j = 0; j < gameGrid[i].length; j++) {
         if(gameGrid[i][j].isSelected){
           return gameGrid[i][j];
         }
      }
    }
    return selected;
  }
  
  public void restartGame(){
    if(state.winner == "x"){
      yourScore++;
    }else{
      computerScore++;
    }
    for (int i = 0; i < gameGrid.length; i++) {
       for (int j = 0; j < gameGrid[i].length; j++) {
         gameGrid[i][j].reset();
        }
      }
    state.reset();
  }
  
   public void isGameOver(){
    if(!state.finish){
    if(gameGrid[0][0].used == "x" && gameGrid[1][0].used == "x" && gameGrid[2][0].used == "x"){
      state.finish = true;
      state.winner = "x";
      state.winningBoxes[0] = gameGrid[0][0];
      state.winningBoxes[1] = gameGrid[1][0];
      state.winningBoxes[2] = gameGrid[2][0];
      return;
    }else if(gameGrid[0][1].used == "x" && gameGrid[1][1].used == "x" && gameGrid[2][1].used == "x"){
      state.finish = true;
      state.winner = "x";
      state.winningBoxes[0] = gameGrid[0][1];
      state.winningBoxes[1] = gameGrid[1][1];
      state.winningBoxes[2] = gameGrid[2][1];
      return;
    }else if(gameGrid[0][2].used == "x" && gameGrid[1][2].used == "x" && gameGrid[2][2].used == "x"){
      state.finish = true;
      state.winner = "x";
      state.winningBoxes[0] = gameGrid[0][2];
      state.winningBoxes[1] = gameGrid[1][2];
      state.winningBoxes[2] = gameGrid[2][2];
      return;
    }else if(gameGrid[0][0].used == "x" && gameGrid[0][1].used == "x" && gameGrid[0][2].used == "x"){
      state.finish = true;
      state.winner = "x";
      state.winningBoxes[0] = gameGrid[0][0];
      state.winningBoxes[1] = gameGrid[0][1];
      state.winningBoxes[2] = gameGrid[0][2];
      return;
    }else if(gameGrid[1][0].used == "x" && gameGrid[1][1].used == "x" && gameGrid[1][2].used == "x"){
      state.finish = true;
      state.winner = "x";
      state.winningBoxes[0] = gameGrid[1][0];
      state.winningBoxes[1] = gameGrid[1][1];
      state.winningBoxes[2] = gameGrid[1][2];
      return;
    }else if(gameGrid[2][0].used == "x" && gameGrid[2][1].used == "x" && gameGrid[2][2].used == "x"){
      state.finish = true;
      state.winner = "x";
      state.winningBoxes[0] = gameGrid[2][0];
      state.winningBoxes[1] = gameGrid[2][1];
      state.winningBoxes[2] = gameGrid[2][2];
      return;
    }else if(gameGrid[0][0].used == "x" && gameGrid[1][1].used == "x" && gameGrid[2][2].used == "x"){
      state.finish = true;
      state.winner = "x";
      state.winningBoxes[0] = gameGrid[0][0];
      state.winningBoxes[1] = gameGrid[1][1];
      state.winningBoxes[2] = gameGrid[2][2];
      return;
    }else if(gameGrid[2][0].used == "x" && gameGrid[1][1].used == "x" && gameGrid[0][2].used == "x"){
      state.finish = true;
      state.winner = "x";
      state.winningBoxes[0] = gameGrid[2][0];
      state.winningBoxes[1] = gameGrid[1][1];
      state.winningBoxes[2] = gameGrid[0][2];
      return;
    }else if(gameGrid[0][0].used == "o" && gameGrid[1][0].used == "o" && gameGrid[2][0].used == "o"){
      state.finish = true;
      state.winner = "o";
      state.winningBoxes[0] = gameGrid[0][0];
      state.winningBoxes[1] = gameGrid[1][0];
      state.winningBoxes[2] = gameGrid[2][0];
      return;
    }else if(gameGrid[0][1].used == "o" && gameGrid[1][1].used == "o" && gameGrid[2][1].used == "o"){
      state.finish = true;
      state.winner = "o";
      state.winningBoxes[0] = gameGrid[0][1];
      state.winningBoxes[1] = gameGrid[1][1];
      state.winningBoxes[2] = gameGrid[2][1];
      return;
    }else if(gameGrid[0][2].used == "o" && gameGrid[1][2].used == "o" && gameGrid[2][2].used == "o"){
      state.finish = true;
      state.winner = "o";
      state.winningBoxes[0] = gameGrid[0][2];
      state.winningBoxes[1] = gameGrid[1][2];
      state.winningBoxes[2] = gameGrid[2][2];
      return;
    }else if(gameGrid[0][0].used == "o" && gameGrid[0][1].used == "o" && gameGrid[0][2].used == "o"){
      state.finish = true;
      state.winner = "o";
      state.winningBoxes[0] = gameGrid[0][0];
      state.winningBoxes[1] = gameGrid[0][1];
      state.winningBoxes[2] = gameGrid[0][2];
      return;
    }else if(gameGrid[1][0].used == "o" && gameGrid[1][1].used == "o" && gameGrid[1][2].used == "o"){
      state.finish = true;
      state.winner = "o";
      state.winningBoxes[0] = gameGrid[1][0];
      state.winningBoxes[1] = gameGrid[1][1];
      state.winningBoxes[2] = gameGrid[1][2];
      return;
    }else if(gameGrid[2][0].used == "o" && gameGrid[2][1].used == "o" && gameGrid[2][2].used == "o"){
      state.finish = true;
      state.winner = "o";
      state.winningBoxes[0] = gameGrid[2][0];
      state.winningBoxes[1] = gameGrid[2][1];
      state.winningBoxes[2] = gameGrid[2][2];
      return;
    }else if(gameGrid[0][0].used == "o" && gameGrid[1][1].used == "o" && gameGrid[2][2].used == "o"){
      state.finish = true;
      state.winner = "o";
      state.winningBoxes[0] = gameGrid[0][0];
      state.winningBoxes[1] = gameGrid[1][1];
      state.winningBoxes[2] = gameGrid[2][2];
      return;
    }else if(gameGrid[2][0].used == "o" && gameGrid[1][1].used == "o" && gameGrid[0][2].used == "o"){
      state.finish = true;
      state.winner = "o";
      state.winningBoxes[0] = gameGrid[2][0];
      state.winningBoxes[1] = gameGrid[1][1];
      state.winningBoxes[2] = gameGrid[0][2];
      return;
    }
    }
  }
}
class TTTGameState{
  
  boolean finish;
  String winner;
  TTTBox[] winningBoxes = new TTTBox[3];
  TTTGameState(){
    finish = false;
    winner = "";
    winningBoxes = new TTTBox[3];
  }
  
  public void reset(){
    finish = false;
    winner = "";
    winningBoxes = new TTTBox[3];
  }
}
class TTTRestartButton{
 
  PShape button;
  PShape line;
  boolean isSelected = false;
  float size;
  PVector boxMin;
  PVector boxMax;
  PVector hit = new PVector();
  int mainColor = color(0xffff4000);
  int secondColor = color(255);
  float boxSize = width/8;
  float offset = boxSize/4;
      
  TTTRestartButton(){
    size = width/12;
    boxMin = new PVector(-size/2, -size/2, 0);
    boxMax = new PVector(+size/2, +size/2, 0);
    ellipseMode(CENTER);
    button = createShape(ELLIPSE, 0, 0, size, size);
    
    line = createShape();
    line.beginShape();
    line.fill(0, 0, 255);
    line.stroke(0, 0, 255);
    line.vertex(0,0,0);
    line.vertex(300,0,0);
    line.endShape(CLOSE);
  }
  
  public void display(){
      pushMatrix();
      translate(2*(boxSize+offset),0,200);
      rotateY(radians(-60));
      getObjectMatrix(objMat);
      objMat.mult(cam, objCam);
      objMat.mult(front, objFront);
      PVector.sub(objFront, objCam, objDir);
      boolean res = intersectsLine(objCam, objDir, boxMin, boxMax, 0, 1000, hit);
      button.setFill(color(mainColor));
      button.setStroke(color(mainColor));
      isSelected = false;
      
      if(res){
        button.setStrokeWeight(5);
        button.setStroke(secondColor);
        isSelected = true;
      }
      
      text("Restart",0,size/1.5f,1);
      shape(button);
      popMatrix();
 
      stroke(mainColor);
      line((boxSize+(offset/1.5f)),0,0,2*(boxSize+offset),0,170);
  }
}
  public void settings() {  fullScreen(PVR.STEREO); }
}
