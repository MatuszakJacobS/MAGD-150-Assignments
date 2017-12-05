boolean mouseHeld;
String state;
Ball balls[];
int ballCount;
mouseBall mouse;
boolean rightHeld;
boolean rightToggle;
PFont font;
int previousSecond;

/*
*******************************************************************************************************

*******************************************************************************************************
*/

void setup() {
  font = createFont("Arial", 16, false);
  mouseHeld = false;
  rightHeld = false;
  rightToggle = false;
  previousSecond = int(second());
  state = "gameMode";
  balls = new Ball[20];
  for (int n = 0; n < balls.length; n++) {
    balls[n] = new Ball();
  }
  mouse = new mouseBall();
  ballCount = 0;
  size(400, 400);
  background(0);
}

/*
*******************************************************************************************************
In the draw method I only reset the background, which in this program is an empty black for the
benefit of the potentially pretty ball colors, and then calls the method of the game state.
*******************************************************************************************************
*/

void draw() {
  fill(0);
  rectMode(CENTER);
  rect(width/2, height/2, width, height);
  if (state.equals("gameMode")) {
    gameMode();
  }
}

/*
*******************************************************************************************************
The gameMode state, which is the primary loop.
I automatically disable the cursor here because of how the balls are drawn.
*******************************************************************************************************
*/

void gameMode() {
  noCursor();
  
  //If any key is pressed, then change the balls colors, flashes rapidly
  if (keyPressed) {
    for (int n = 0; n < ballCount; n++) {
    balls[n].changeColor();
    }
  }
  else {
    //If no key is being pressed, then change every balls color every second
    if (previousSecond != int(second())) {
      for (int n = 0; n < ballCount; n++) {
      balls[n].changeColor();
      }
    }
  }
  previousSecond = int(second());
  
  //If the right key has been pressed, then enable ball "physics", which are very basic here
  if (rightToggle) {
    for (int n = 0; n < ballCount - 1; n++) {
      for (int m = n + 1; m < ballCount; m++) {
        
        //If any ball comes too close to another ball, then both balls have both x and y speed reversed
        //Again, very, very simple.
        if (dist(balls[n].x, balls[n].y, balls[m].x, balls[m].y) <= balls[n].size/2 + balls[m].size/2) {
          balls[n].increaseX = -balls[n].increaseX;
          balls[n].increaseY = -balls[n].increaseY;
          balls[m].increaseX = -balls[m].increaseX;
          balls[m].increaseY = -balls[m].increaseY;
        }
      }
    }
  }
  
  //If the right mouse button is pressed and it is not being held, then toggle rightToggle
  if (mouseButton == RIGHT & mousePressed) { 
    if (!rightHeld) {
      rightHeld = true; 
      if (rightToggle) { rightToggle = false; }
      else { rightToggle = true; }
    }
  }
  else if (!mousePressed) { rightHeld = false; }
  
  //Draw all the balls that have been created, which is known by ballCount
  for (int n = 0; n < ballCount; n++) {
    balls[n].drawBall();
  }
  
  //Draw the ball cursor
  mouse.drawBall();
  fill(255);
  textFont(font);
  text("Ball Collisions (Unstable) are " + rightToggle, 20, height - 20);
}

/*
*******************************************************************************************************
This is the ball that replaces the mouse cursor, so you know how large and where a new ball will appear
*******************************************************************************************************
*/

class mouseBall {
  int x = mouseX;
  int y = mouseX;
  int size = 5;
  int R = 255;
  int G = 255;
  int B = 255;
  int sizeChange = 1;
  
  void drawBall() {
    x = mouseX;
    y = mouseY;
    stroke(0);
    ellipseMode(CENTER);
    fill(R, G, B);
    ellipse(x, y, size, size);
    
    //If the left mouse button IS being held down, then increase the size of this ball
    if (mouseButton == LEFT && mousePressed) {
      mouseHeld = true;
      if (size < 100) { 
        size++;
      }
    }
    
    //If the left mouse was being held and was released, then create the next ball at this x and y (the mouse x and y),
    // and reset the size of the mouse ball
    else if (mouseHeld == true) {
      mouseHeld = false;
      if (ballCount < 20) {
        balls[ballCount].createBall(x, y, size);
        ballCount++;
      }
      size = 5;
    }
  }
}

/*
*******************************************************************************************************
This class handles all of the ball individually
*******************************************************************************************************
*/

class Ball {
  int x = 200;
  int y = 200;
  int size = 20;
  int R = 0;
  int G = 0;
  int B = 0;
  int speed = 5;
  int increaseX = speed;
  int increaseY = speed;
  
  //This method is called when the mouse is release to set the new variables set by the user
  void createBall(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
    changeColor();
  }
  
  //Randomly select a color
  void changeColor() {
    R = int(random(255));
    G = int(random(255));
    B = int(random(255));
  }
  
  void drawBall() {
    if (x >= width - size/2) { increaseX = -speed; }
    else if (x <= 0 + size/2) { increaseX = speed; }
    if (y >= height - size/2) { increaseY = -speed; }
    else if (y <= 0 + size/2) { increaseY  = speed; }
    
    x += increaseX;
    y += increaseY;
    
    noStroke();
    ellipseMode(CENTER);
    
    //Create a temporary RGB and size to be modified for making a gradient inwards ball, just a little prettier.
    for (int tempR = R, tempG = G, tempB = B, tempSize = size; tempSize > 0; tempR-=2, tempG-=2, tempB-=2, tempSize--) {
      fill(max(tempR, 0), max(tempG, 0), max(tempB, 0));
      ellipse(x, y, tempSize, tempSize);
    }
  }
}
