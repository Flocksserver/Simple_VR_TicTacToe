class TTTGame{
 
  /*
  0/0 1/0 2/0
  0/1 1/1 2/1
  0/2 1/2 2/2
  */
  TTTBox[][] gameGrid = new TTTBox[3][3];
  TTTAim aim;
  boolean mouseIsPressed = false;
  boolean gameOver = false;

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
      TTTBox selected = getSelectedBox();
      if(mouseIsPressed && selected != null){
          mouseIsPressed = false;
          selected.used = "x";
          gameOver = isGameOver();
          if(!gameOver){
            doOpponentAction();
          }
      }
      gameOver = isGameOver();
      if(gameOver){
         //show restart button
         //animate winning sequenz
         String winner = "x";
         //if(mouseIsPressed && restartButton.isSelected){
         //   restartGame(winner); 
         //}
      }
      
  }
  
  
    void doOpponentAction(){
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
  
  boolean isGameOver(){
    if(
    gameGrid[0][0].used == "x" && gameGrid[1][0].used == "x" && gameGrid[2][0].used == "x" ||
    gameGrid[0][1].used == "x" && gameGrid[1][1].used == "x" && gameGrid[2][1].used == "x" ||
    gameGrid[0][2].used == "x" && gameGrid[1][2].used == "x" && gameGrid[2][2].used == "x" ||
    
    gameGrid[0][0].used == "x" && gameGrid[0][1].used == "x" && gameGrid[0][2].used == "x" ||
    gameGrid[1][0].used == "x" && gameGrid[1][1].used == "x" && gameGrid[1][2].used == "x" ||
    gameGrid[2][0].used == "x" && gameGrid[2][1].used == "x" && gameGrid[2][2].used == "x" ||

    gameGrid[0][0].used == "x" && gameGrid[1][1].used == "x" && gameGrid[2][2].used == "x" ||
    gameGrid[2][0].used == "x" && gameGrid[1][1].used == "x" && gameGrid[0][2].used == "x" ||
    
    gameGrid[0][0].used == "o" && gameGrid[1][0].used == "o" && gameGrid[2][0].used == "o" ||
    gameGrid[0][1].used == "o" && gameGrid[1][1].used == "o" && gameGrid[2][1].used == "o" ||
    gameGrid[0][2].used == "o" && gameGrid[1][2].used == "o" && gameGrid[2][2].used == "o" ||
    
    gameGrid[0][0].used == "o" && gameGrid[0][1].used == "o" && gameGrid[0][2].used == "o" ||
    gameGrid[1][0].used == "o" && gameGrid[1][1].used == "o" && gameGrid[1][2].used == "o" ||
    gameGrid[2][0].used == "o" && gameGrid[2][1].used == "o" && gameGrid[2][2].used == "o" ||

    gameGrid[0][0].used == "o" && gameGrid[1][1].used == "o" && gameGrid[2][2].used == "o" ||
    gameGrid[2][0].used == "o" && gameGrid[1][1].used == "o" && gameGrid[0][2].used == "o" 
    ){
      return true;
    }else{
      return false;
    }
  }
  
  TTTBox getSelectedBox(){
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
}