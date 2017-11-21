class TTTAim{
  PShape aim;
  TTTAim(){
    aim = new PShape();
  }
  void display(){
  pushMatrix();
  eye();
  translate(0,0,100);
  stroke(255);
  noFill();
  aim = createShape(ELLIPSE, 0, 0, 5, 5);
  aim.setStrokeWeight(3);
  aim.setStroke(color(255,255,255));
  shape(aim);
  popMatrix();
}
}