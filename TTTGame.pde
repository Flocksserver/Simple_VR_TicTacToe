class TTTGame{
 
  /*
  0/0 1/0 2/0
  0/1 1/1 2/1
  0/2 1/2 2/2
  */
  TTTBox[][] gameGrid = new TTTBox[3][3];
  TTTAim aim;
  TTTGameState state;
  boolean mouseIsPressed = false;

  TTTGame(){
   aim = new TTTAim();
   
   state = new TTTGameState();
   
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
         //show restart button
         //animate winning sequenz
         //String winner = "x";
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
  
  void isGameOver(){
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