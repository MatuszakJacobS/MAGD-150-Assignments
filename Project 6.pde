boolean mouseHeld;
Ball balls[];
int ballCount;
PFont font;

void setup() {
  
  //Screensavers don't have cursors visible
  noCursor();
  
  ballCount = 500;
  font = createFont("Arial", 16, true);
  
  balls = new Ball[ballCount];
  for (int xx = 0; xx < ballCount; xx++) {
    balls[xx] = new Ball();
  }
  mouseHeld = true;
  
  noStroke();
  //I set the program to run fullscreen, because screensavers should be fullscreen
  fullScreen();
  background(0);
}

void draw() {
  
  fill(0);
  rectMode(CENTER);
  //I decided it looks prettier to not clear the background every frame, but it is neat to watch the balls when the background is being cleared.
  //rect(width/2, height/2, width, height);
  
  //Find the first ball that doesn't "exist", and "create" it
  for (int xx = 0; xx < ballCount; xx++) {
    if (!balls[xx].exists) {
      balls[xx].createBall(width/2, height/2);
      break;
    }
  }
  
  //Draw every ball that "exists"
  for (int xx = 0; xx < ballCount; xx++) {
    if (balls[xx].exists) { balls[xx].drawBall(); }
  }
  
  //Draw text to tell the user how to exit the program, since we are not clearing the background I clear the text with a black version of the text just to look more consistent.
  textFont(font);
  textAlign(LEFT);
  fill(0);
  text("Press any key to exit", 20, height - 20);
  fill(255);
  text("Press any key to exit", 20, height - 20);
  
  if (keyPressed) {
    exit();
  }
}

class Ball {
  int stationX;
  int stationY;
  int x;
  int y;
  int size;
  int R;
  int G;
  int B;
  float delta;
  float sinX;
  float sinY;
  float pi;
  boolean increaseX;
  boolean increaseY;
  int offset;
  int pastX[];
  int pastY[];
  float drawRatio;
  boolean exists;
  int fifth;
  int distX;
  int distY;
  
  Ball() {
    R = int(random(255));
    G = int(random(255));
    B = int(random(255));
    delta = 0.01;
    sinX = 0;
    sinY = 0.5;
    pi = 3.14;
    increaseX = false;
    increaseY = false;
    pastX = new int[8];
    pastY = new int[8];
    drawRatio = 0;
    exists = false;
    fifth = 5;
  }
  
  //This method will basically reset whatever variables need to be reset when a ball reaches the edge of the screen
  void createBall(int x, int y) {
    
    offset = int(random(100)) + 25;
    
    distX = -3 + int(random(6));
    distY = -3 + int(random(6));
    
    if (distX == 0 && distY == 0) { distX = 1; }
    
    exists = true;
    this.stationX = x;
    this.stationY = y;
    size = 1;
    for (int xx = 0; xx < pastX.length; xx++) {
      pastX[xx] = 0;
      pastY[xx] = 0;
    }
  }
  
  void drawBall() {
    
    //The ball swirls around the station coordinates, which are moving in a random direction
    stationX += distX;
    stationY += distY;
    
    //Slowly increase the size of the ball
    if (fifth > 0) { fifth--; }
    else { fifth = 5; size++; }
    
    //If the ball is outside of view then it doesn't exist
    if (x < 0 - size || x > width + size || y < 0 - size || y > height + size) { exists = false; }
    
    sinX += delta;
    sinY += delta;
    
    x = int(sin(pi*sinX)*offset) + stationX;
    y = int(sin(pi*sinY)*offset) + stationY;
    
    ellipseMode(CENTER);
    fill(255);
    //Display the station
    //ellipse(stationX, stationY, 10, 10);
    
    noStroke();
    fill(R, G, B);
    ellipse(x, y, size, size);
  }
}
