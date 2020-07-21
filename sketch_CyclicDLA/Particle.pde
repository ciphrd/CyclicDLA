class Particle {
  public int x;
  public int y;
  
  Particle () {
    randPos();
  }
  
  public void update () {
    // maybe it is faster for the CPU to do logical comparaison rather than solving this with math ?
    int dir = (int) random(8);
    switch (dir) {
      case 0: x--; y--; break;
      case 1: y--; break;
      case 2: x++; y--; break;
      case 3: x++; break;
      case 4: x++; y++; break;
      case 5: y++; break;
      case 6: x--; y++; break;
      case 7: x--; break;
    }
    bound();
  }
  
  public void bound () {
    if (x < 0 || x >= SIZE || y < 0 || y >= SIZE) {
       randPos();
    }
  }
  
  public void randPos () {
    
    //
    float a = random(TWO_PI);
    float d = random(1);
    d = pow(d, 0.5);
    d*= RAD;
    
    x = (int) (cos(a) * d + SIZE2);
    y = (int) (sin(a) * d + SIZE2); 
    /*
    x = (int) random(SIZE);
    y = (int) random(SIZE);
    */
  }
  
  public void draw () {
    fill(255, 0, 0);
    noStroke();
    rect(x*cell, y*cell, cell, cell);
  }
}
