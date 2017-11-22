class TTTRestartButton{
 
  PShape button;
  PShape line;
  boolean isSelected = false;
  float size;
  PVector boxMin;
  PVector boxMax;
  PVector hit = new PVector();
  color mainColor = color(#ff4000);
  color secondColor = color(255);
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
  
  void display(){
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
      
      text("Restart",0,size/1.5,1);
      shape(button);
      popMatrix();
 
      stroke(mainColor);
      line((boxSize+(offset/1.5)),0,0,2*(boxSize+offset),0,170);
  }
}