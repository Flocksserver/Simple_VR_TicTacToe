class TTTBox{
  
  PShape box;
  boolean isSelected = false;
  String used = "";
  color mainColor = color(#00bfff);
  color secondColor = color(#ff4000);

  float boxSize;
  float offset;
  PVector boxMin;
  PVector boxMax;
  PVector hit = new PVector();
  
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
      //bei grid 0,0 kommt position 1/1 raus
      translate(0+(x-1)*(boxSize+offset),0+(y-1)*(boxSize+offset));
      getObjectMatrix(objMat);
      objMat.mult(cam, objCam);
      objMat.mult(front, objFront);
      PVector.sub(objFront, objCam, objDir);
      boolean res = intersectsLine(objCam, objDir, boxMin, boxMax, 0, 1000, hit);
      box.setFill(mainColor);
      box.setStroke(mainColor);
      isSelected = false;
      if(res){
        box.setStrokeWeight(5);
        box.setStroke(secondColor);
        isSelected = true;
      }
      shape(box);
      popMatrix();
  
  }
  
  
  
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