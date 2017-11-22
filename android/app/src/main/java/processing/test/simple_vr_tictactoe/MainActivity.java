package processing.test.simple_vr_tictactoe;

import android.os.Bundle;

import processing.vr.PVR;
import processing.core.PApplet;

public class MainActivity extends PVR {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    PApplet sketch = new Simple_VR_TicTacToe();
    
    setSketch(sketch);
  }
}
