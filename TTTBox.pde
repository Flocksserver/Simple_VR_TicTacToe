class TTTBox{
  
  PShape box;
  TTTGameState state;
  boolean isSelected = false;
  String used = "";
  boolean animate = false;
  boolean animateInk = true; 
  boolean animateDek = false; 
  float animateZ = 0;
  color mainColor = color(#00bfff);
  color secondColor = color(#ff4000);

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
    boxMin = new PVector(-boxSize/2, -boxSize/2, 0);
    boxMax = new PVector(+boxSize/2, +boxSize/2, 0);
    rectMode(CENTER);
    box = createShape(RECT, 0, 0, boxSize, boxSize);
  }
  
  void display(int x, int y){
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

  void reset(){
    isSelected = false;
    used = "";
    animate = false;
    animateInk = true; 
    animateDek = false; 
    animateZ = 0;
  }
  
}