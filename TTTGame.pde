class TTTGame{
 
  /*
  0/0 1/0 2/0
  0/1 1/1 2/1
  0/2 1/2 2/2
  */
  TTTBox[][] gameGrid = new TTTBox[3][3];
  TTTAim aim;

  TTTGame(){
   aim = new TTTAim();
   
   gameGrid[0][0] = new TTTBox();
   gameGrid[1][0] = new TTTBox();
   gameGrid[2][0] = new TTTBox();
    
   gameGrid[0][1] = new TTTBox();
   gameGrid[1][1] = new TTTBox();
   gameGrid[2][1] = new TTTBox();
   
   gameGrid[0][2] = new TTTBox();
   gameGrid[1][2] = new TTTBox();
   gameGrid[2][2] = new TTTBox();

  }
  
  void display(){
    for (int i = 0; i < gameGrid.length; i++) {
       for (int j = 0; j < gameGrid[i].length; j++) {
         gameGrid[i][j].display(i,j);
        }
      }
    aim.display();
  }
}