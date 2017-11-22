class TTTGameState{
  
  boolean finish;
  String winner;
  TTTBox[] winningBoxes = new TTTBox[3];
  TTTGameState(){
    finish = false;
    winner = "";
    winningBoxes = new TTTBox[3];
  }
  
  void reset(){
    finish = false;
    winner = "";
    winningBoxes = new TTTBox[3];
  }
}