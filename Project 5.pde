/*
****************************************************************************************************************************************************
* For this program I created a game where you must click on a 10x10 grid of boxes to toggle them on or off.
* There are 3 patterns at the top of the screen that you must match, and a reset button on the bottom to clear the board.
* Once a pattern is correct, it is then removed.
* When the player clears all three patterns, the tiles fade away to reveal an eye following the mouse.
****************************************************************************************************************************************************
*/

tile tiles[][];
represent imageOne[][];
represent imageTwo[][];
represent imageThree[][];
int defX;
int defY;
int space;
int tileSize;
boolean mouseHeld;
button reset;
PFont font;
boolean check1;
boolean check2;
boolean check3;
int counter;
boolean game;
int eyeOpen;
eyeBall eye;
PShape s;

/*
****************************************************************************************************************************************************
* My setup method is very large, where I initialize all variables not within other classes, create my arrays for the grid and patterns, and
* create my shape for the eye cut out.
****************************************************************************************************************************************************
*/

void setup() {
  
  size(800, 800);
  background(0);
  
  defX = 200;
  defY = 200;
  space = 5;
  tileSize = 40;
  eyeOpen = 0;
  mouseHeld = true;
  reset = new button();
  font = createFont("Arial", 16, true);
  check1 = false;
  check2 = false;
  check3 = false;
  game = true;
  eye = new eyeBall();
  s = createShape();
  
  // I created a shape that would have a space for the eyeball cut out, so the pupil does not go outside of the eyeball
  shapeMode(POINTS);
  s.beginShape();
  s.vertex(0, 0);
  s.vertex(0, height);
  s.vertex(width, height);
  s.vertex(width, 0);
  s.vertex(0, 0);
  endShape();
  
  s.beginContour();
  s.vertex(99, 399);
  s.vertex(205, 340);
  s.vertex(299, 303);
  s.vertex(394, 284);
  s.vertex(512, 305);
  s.vertex(617, 351);
  s.vertex(702, 399);
  s.vertex(589, 464);
  s.vertex(488, 505);
  s.vertex(407, 520);
  s.vertex(281, 500);
  s.vertex(180, 450);
  s.vertex(99, 399);
  s.endContour();
  
  s.fill(0);
  
  //It appears that if I start the game the drawMode method, the translate happens twice, but only once if I skip straight to the endMode by making game false by default. Weird.
  //s.translate(width/2, height/2);
  
  imageOne = new represent[10][10];
  for (int xx = 0; xx < 10; xx++) {
    for (int yy = 0; yy < 10; yy++) {
      imageOne[xx][yy] = new represent();
      imageOne[xx][yy].createTile(100 + (xx*10), 20 + (yy*10));
    }
  }
  
  for (int xx = 0; xx < 10; xx++) { imageOne[xx][1].on = false; imageOne[xx][3].on = false; imageOne[xx][5].on = false; imageOne[xx][7].on = false; imageOne[xx][9].on = false; }
  
  imageTwo = new represent[10][10];
  for (int xx = 0; xx < 10; xx++) {
    for (int yy = 0; yy < 10; yy++) {
      imageTwo[xx][yy] = new represent();
      imageTwo[xx][yy].createTile(350 + (xx*10), 20 + (yy*10));
    }
  }
  
  for (int xx = 0; xx < 10; xx++) { imageTwo[xx][1].on = false; imageTwo[xx][8].on = false; imageTwo[1][xx].on = false; imageTwo[8][xx].on = false; }
  
  imageThree = new represent[10][10];
  for (int xx = 0; xx < 10; xx++) {
    for (int yy = 0; yy < 10; yy++) {
      imageThree[xx][yy] = new represent();
      imageThree[xx][yy].createTile(600 + (xx*10), 20 + (yy*10));
    }
  }
  
  for (int xx = 0; xx < 10; xx++) { imageThree[xx][xx].on = false; imageThree[xx][9-xx].on = false; }
  
  tiles = new tile[10][10];
  for (int xx = 0; xx < 10; xx++) {
    for (int yy = 0; yy < 10; yy++) {
      tiles[xx][yy] = new tile();
      tiles[xx][yy].createTile(defX + (xx*tileSize) + (xx*space), defY + (yy*tileSize) + (yy*space), xx, yy);
    }
  }
}

/*
****************************************************************************************************************************************************
* Like normal, the draw method contains only pointers to other methods, and the draw method only controls what part of the game is being run.
****************************************************************************************************************************************************
*/

void draw() {
  if (game) {
    drawMode();  
  }
  else { endMode(); }
}

/*
****************************************************************************************************************************************************
* The endMode is run after all 3 patterns have been created, and it creates the eye, which then follows you, and fades the tiles out.
****************************************************************************************************************************************************
*/

void endMode() {
  
  
  if (eyeOpen < 150) { eyeOpen++; }
  
  fill(0);
  rectMode(CENTER);
  rect(width/2, height/2, width, height);
   
  fill(255);
  stroke(255);
  bezier(100, height/2, 350, height/2 + eyeOpen, 450, height/2 + eyeOpen, 700, height/2);
  bezier(100, height/2, 350, height/2 - eyeOpen, 450, height/2 - eyeOpen, 700, height/2);
  eye.drawEyeball();
  
  shape(s);
  
  reset.fadeButton();
  
  for (int xx = 0; xx < 10; xx++) {
    for (int yy = 0; yy < 10; yy++) {
      tiles[xx][yy].fadeTile(xx);
    }
  }
}

/*
****************************************************************************************************************************************************
* The drawMode is the main "game" part, where the tiles, patterns, and button are being drawn and checked for interaction with the mouse.
* If check1 is not true, the it checks the imageOne array and compares it against the board. If they are the same, then check1 is made true.
* This follows for check2 and check3, and once all three are true, then change the game to false, which moves to endMode.
****************************************************************************************************************************************************
*/

void drawMode() {
  fill(0);
  rectMode(CENTER);
  rect(width/2, height/2, width, height);
  
  reset.drawButton();
  
  for (int xx = 0; xx < 10; xx++) {
    for (int yy = 0; yy < 10; yy++) {
      tiles[xx][yy].drawTile();
      if (tiles[xx][yy].mouseOver) {
        if (mousePressed && mouseButton == RIGHT) {
          mouseHeld = true;
          tiles[xx][yy].toggle(true);
        }
        else if (mousePressed && mouseButton == LEFT) {
          mouseHeld = true;
          tiles[xx][yy].toggle(false);
        }
        else { mouseHeld = false; }
      }
    }
  }
  
  if (!check1) {
    for (int xx = 0; xx < 10; xx++) {
      for (int yy = 0; yy < 10; yy++) {
        imageOne[xx][yy].drawTile();
      }
    }
    
    //I added a couple red x's to notify the user that this pattern was not yet made.
    fill(255, 0, 0);
    noStroke();
    shapeMode(QUAD);
    beginShape();
    vertex(120, 130);
    vertex(130, 120);
    vertex(170, 160);
    vertex(160, 170);
    endShape();
    beginShape();
    vertex(160, 120);
    vertex(170, 130);
    vertex(130, 170);
    vertex(120, 160);
    endShape();
    counter = 0;
    for (int xx = 0; xx < 10; xx++) {
      for (int yy = 0; yy < 10; yy++) {
        if (tiles[xx][yy].on == imageOne[xx][yy].on) { counter++; }
      }
    }
    if (counter == 100) { check1 = true; }
  }
  else {
    fill(0, 255, 0);
    noStroke();
    shapeMode(QUAD);
    beginShape();
    vertex(120, 160);
    vertex(130, 150);
    vertex(140, 160);
    vertex(160, 120);
    vertex(170, 130);
    vertex(140, 170);
    endShape();
  }
  
  if (!check2) {
    for (int xx = 0; xx < 10; xx++) {
      for (int yy = 0; yy < 10; yy++) {
        imageTwo[xx][yy].drawTile();
      }
    }
    fill(255, 0, 0);
    noStroke();
    shapeMode(QUAD);
    beginShape();
    vertex(370, 130);
    vertex(380, 120);
    vertex(420, 160);
    vertex(410, 170);
    endShape();
    beginShape();
    vertex(410, 120);
    vertex(420, 130);
    vertex(380, 170);
    vertex(370, 160);
    endShape();
    counter = 0;
    for (int xx = 0; xx < 10; xx++) {
      for (int yy = 0; yy < 10; yy++) {
        if (tiles[xx][yy].on == imageTwo[xx][yy].on) { counter++; }
      }
    }
    if (counter == 100) { check2 = true; }
  }
  else {
    fill(0, 255, 0);
    noStroke();
    shapeMode(QUAD);
    beginShape();
    vertex(370, 160);
    vertex(380, 150);
    vertex(390, 160);
    vertex(410, 120);
    vertex(420, 130);
    vertex(390, 170);
    endShape();
  }
  
  if (!check3) {
    for (int xx = 0; xx < 10; xx++) {
      for (int yy = 0; yy < 10; yy++) {
        imageThree[xx][yy].drawTile();
      }
    }
    fill(255, 0, 0);
    noStroke();
    shapeMode(QUAD);
    beginShape();
    vertex(620, 130);
    vertex(630, 120);
    vertex(670, 160);
    vertex(660, 170);
    endShape();
    beginShape();
    vertex(670, 130);
    vertex(660, 120);
    vertex(620, 160);
    vertex(630, 170);
    endShape();
    counter = 0;
    for (int xx = 0; xx < 10; xx++) {
      for (int yy = 0; yy < 10; yy++) {
        if (tiles[xx][yy].on == imageThree[xx][yy].on) { counter++; }
      }
    }
    if (counter == 100) { check3 = true; }
  }
  else {
    fill(0, 255, 0);
    noStroke();
    shapeMode(QUAD);
    beginShape();
    vertex(620, 160);
    vertex(630, 150);
    vertex(640, 160);
    vertex(660, 120);
    vertex(670, 130);
    vertex(640, 170);
    endShape();
  }
  
  if (mousePressed) {
    if (!mouseHeld) {
      mouseHeld = true;
    }
  }
  else { mouseHeld = false; }
  
  if (check1 && check2 && check3) { 
    game = false;
  }
}

/*
****************************************************************************************************************************************************
* This class controls the iris and pupil of the eyeball, which follows the mouse if it isn't out of range.
****************************************************************************************************************************************************
*/

class eyeBall {
  int x = width/2;
  int y = 400;
  int size = 0;
  
  void drawEyeball() {
    
    if (size < 150) { size++; }
    
    else {
      
      if (mouseX <= 200) { x = 200; }
      else if (mouseX >= 600) { x = 600; }
      else { x = mouseX; }
      
      if (mouseY <= 300) { y = 300; }
      else if (mouseY >= 500) { y = 500; }
      else { y = mouseY; }
      
    }
    
    noStroke();
    fill(0);
    ellipseMode(CENTER);
    ellipse(x, y, size, size);
    fill(255);
    ellipse(x, y, size/3, size/3);
  }
}

/*
****************************************************************************************************************************************************
* A simple button class, draws an ellipse slightly larger than the button under it, as well as draw text over it. Also checks for mouse input.
****************************************************************************************************************************************************
*/

class button {
  int x = width/2;
  int y = 700;
  int size = 100;
  boolean mouseOver = false;
  
  void drawButton() {
    
    if (mouseOver && !mouseHeld && mousePressed) {
      for (int xx = 0; xx < 10; xx++) {
        for (int yy = 0; yy < 10; yy++) {
          tiles[xx][yy].on = true;
        }
      }
    }    
    ellipseMode(CENTER);
    fill(200);
    ellipse(x, y, size*1.1, size*1.1);
    
    if (dist(mouseX, mouseY, x, y) < size/2) {
      mouseOver = true;
      fill(200, 0, 0);
    }
    else { fill(255, 0, 0); mouseOver = false; }
    
    ellipse(x, y, size, size);
    
    fill(0);
    textFont(font);
    textAlign(CENTER);
    text("RESET", x, y);
  }
  
  void fadeButton() {
    if (size > 0) {
      size--;
         
      ellipseMode(CENTER);
      fill(200);
      ellipse(x, y, size*1.1, size*1.1);
      
      fill(255, 0, 0);
      ellipse(x, y, size, size);
      
      fill(255 - size*3);
      textFont(font);
      textAlign(CENTER);
      text("RESET", x, y);
    }
  }
}

/*
****************************************************************************************************************************************************
* The tile class is every tile of the "game board", which is very reactive to the mouse.
* If the mouse is over the tile, and it is off, then it is a dark grey. If the mouse is over the tile and it is on, then it is a light grey.
* Otherwise, if the tile is on it is white, and if it is off, then it is black with a white outline.
* If the user presses the right mouse, then the toggle method is called to all adjacent tiles as well. Just for fun more than anything.
* If the tile has been changed in this mousePressed duration, then do not let it be changed again until the mouse is released.
* The fade method makes the tiles move away from the center of the screen, as well as slowly fade in color.
****************************************************************************************************************************************************
*/

class tile {
  int x = 0;
  int y = 0;
  int posX;
  int posY;
  boolean on = true;
  int size = 40;
  boolean mouseOver = false;
  boolean hasChanged = false;
  int fade = 255;
  
  void createTile(int setX, int setY, int setPosX, int setPosY) {
    x = setX; y = setY;
    posX = setPosX;
    posY = setPosY;
  }
  
  void toggle(boolean start) {
    if (start) {
      if (posX > 0) { tiles[posX-1][posY].toggle(false); }
      if (posX < 9) { tiles[posX+1][posY].toggle(false); }
      if (posY > 0) { tiles[posX][posY-1].toggle(false); }
      if (posY < 9) { tiles[posX][posY+1].toggle(false); }
    }
    if (!hasChanged) {
      hasChanged = true;
      if (on) { on = false; }
      else { on = true; }
    }
  }
  
  void drawTile() {
    stroke(255);
    
    if (abs(x - mouseX) < size/2 && abs(y - mouseY) < size/2) {
      mouseOver = true;
      if (on) { fill(200); }
      else { fill(50); }
    }
    else if (on) { mouseOver = false; fill(255); }
    else { mouseOver = false; fill(0); }
    if (!mouseOver && mouseButton != RIGHT) { hasChanged = false; }
    rectMode(CENTER);
    rect(x, y, size, size);
  }
  
  void fadeTile(int xPos) {
    
    if (xPos >= 5) { x+=2; }
    else { x-=2; }
    
    fade--;
    stroke(max(fade, 0));
    
    if (on) { mouseOver = false; fill(max(fade, 0)); }
    else { mouseOver = false; fill(0); }
    
    rectMode(CENTER);
    rect(x, y, size, size);
  }
}

/*
****************************************************************************************************************************************************
* I figured it would just be clearer to make a separate tile class for the image arrays that compare the state of the board.
****************************************************************************************************************************************************
*/

class represent {
  int x = 0;
  int y = 0;
  boolean on = true;
  int size = 10;
  
  void createTile(int setX, int setY) {
    x = setX; y = setY;
  }
  
  void drawTile() {
    noStroke();
    if (on) { fill(255); }
    else { fill(0); }
    
    rectMode(CENTER);
    rect(x, y, size, size);
  }
}
