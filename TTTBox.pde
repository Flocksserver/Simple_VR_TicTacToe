class TTTBox{
  
  PShape box;
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
      
  TTTBox(){
    boxSize = width/8;
    offset = boxSize/4;
    boxMin = new PVector(-boxSize/2, -boxSize/2, -boxSize/2);
    boxMax = new PVector(+boxSize/2, +boxSize/2, +boxSize/2);
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
      
      if(res && used == "" && !animate){
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
  
}