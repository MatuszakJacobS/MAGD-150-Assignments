/*
*  For this lab I will create a tree with a large amount of individual leaves on the tree.
*  There will be a "slider" square available to the user, which the x value will determine the season, and the y value will determine the time of day
*  I realized after making this that for the day/night cycle I could've just made a black rectangle that changes in transparency over the screen.... But this works too.
*/

//  For the sake of my own sanity, rather than it being dark at 0 and 24 and light at 12, it will be light at 24 and get darker until 0, it cannot cycle beyond 24 back to 0.
int dayCycle;

//  The season will be more complex. There are 4 seasons, each with different characteristics.
//  Based on the slider, the seasons will be separated by 25% of the slider, winter = 0-25, spring = 25-50, summer = 50-75, fall = 75-100.
//  The seasons will all regulate back to a basic tree with 60% leaves, and a light green leaf.
int season;

//  For starters, the maximum amount of leaves will be 1000.
//  I liked this amount of leaves, so I kept it, and the math would have to be changed now if I were to change it.
int leaves;
Leaf leaf[];

//  Leaf colors, a different color format may be more efficient, but RGB for now.
int leafR;
int leafG;
int leafB;

//  Colors for the ground
int groundR;
int groundG;
int groundB;

Slider slider;

PFont font;

PShape tree;

PVector treePos;

void setup() {
  
  treePos = new PVector(300, 300);
  tree = createShape();
  tree.beginShape();
  tree.noStroke();
  tree.vertex(320, 650);
  tree.vertex(350, 550);
  tree.vertex(375, 400);
  
  tree.vertex(350, 350);
  tree.vertex(250, 450);
  tree.vertex(275, 400);
  tree.vertex(330, 320);
  
  tree.vertex(250, 250);
  tree.vertex(200, 260);
  tree.vertex(260, 230);
  tree.vertex(375, 325);
  
  tree.vertex(325, 200);
  tree.vertex(300, 175);
  tree.vertex(325, 190);
  tree.vertex(375, 125);
  tree.vertex(350, 200);
  tree.vertex(400, 300);
  
  tree.vertex(500, 200);
  tree.vertex(550, 220);
  tree.vertex(500, 230);
  tree.vertex(450, 300);
  tree.vertex(425, 350);
  
  tree.vertex(550, 325);
  tree.vertex(525, 300);
  tree.vertex(575, 325);
  tree.vertex(525, 350);
  tree.vertex(550, 375);
  tree.vertex(525, 400);
  tree.vertex(540, 375);
  tree.vertex(500, 350);
  
  tree.vertex(425, 400);
  tree.vertex(450, 550);
  tree.vertex(480, 650);
  tree.endShape(CLOSE);
  
  tree.translate(treePos.x, treePos.y);
  tree.scale(1);
  
  size(800, 800);
  background(0);
  
  dayCycle = 0;
  season = 50;
  leaves = 600;
  leafR = 0;
  leafG = 155;
  leafB = 0;
  groundR = 0;
  groundG = 0;
  groundB = 0;
  
  leaf = new Leaf[1000];
  
  for (int xx = 0; xx < 1000; xx++) {
    leaf[xx] = new Leaf();
  }
  
  slider = new Slider(50, 650, 150, 750);
  
  font = createFont("Arial", 16, false);
}

void draw() {
  drawBackground();
  slider.mouse();
  slider.drawSlider();
  textFont(font);
  fill(255);
  text("X: " + float(int(slider.xRatio*10))/10 + " \t Y: " + float(int(slider.yRatio*10))/10, 600, 700);
  season = int(slider.xRatio*100);
  dayCycle = 24 - int(slider.yRatio*24);
  text("Seaaon: " + season + " \t dayCycle: " + dayCycle, 600, 750);
  text("Leaves: " + leaves, 600, 650);
  
  if (season <= 25) {
    if (season >= 15) {
      leaves = int(norm(slider.xRatio - .15, 0, .1) * 600);
      leafR = int(map(slider.xRatio - .15, 0, .1, 255, 50));
      leafG = int(map(slider.xRatio - .15, 0, .1, 255, 200));
      leafB = int(map(slider.xRatio - .15, 0, .1, 255, 50));
      
      groundR = int(map(slider.xRatio - .15, 0, .1, 200, 0));
      groundG = 200;
      groundB = int(map(slider.xRatio - .15, 0, .1, 200, 0));
    }
    else { 
      leaves = 0; 
      
      groundR = 200;
      groundG = 200;
      groundB = 200;
    }
  }
  if (season <= 50 && season > 25) {
    leaves = 600 + int(norm(slider.xRatio, 0.25, 0.5) * 400);
    leafR = 0;
    leafG = 200;
    leafB = 0;
    
    groundR = 0;
    groundG = 200;
    groundB = 0;
  }
  if (season <= 75 && season > 50) {
    leaves = 1000;
    leafR = 0;
    leafG = 200;
    leafB = 0;
    
    groundR = 0;
    groundG = 200;
    groundB = 0;
  }
  if (season <= 100 && season > 75) {
    leaves = 1000 - int(norm(slider.xRatio, 0.75, 1) * 1000);
    leafR = int(map(slider.xRatio, 0.75, 1, 0, 200));
    leafG = int(map(slider.xRatio, 0.75, 1, 200, 100));
    leafB = int(map(slider.xRatio, 0.75, 1, 0, 0));
    
    groundR = int(map(slider.xRatio, 0.75, 1, 0, 150));
    groundG = int(map(slider.xRatio, 0.75, 1, 200, 150));
    groundB = int(map(slider.xRatio, 0.75, 1, 0, 50));
  }
  
  ellipseMode(CENTER);
  fill(map(dayCycle, 0, 24, 0, 1)*leafR, map(dayCycle, 0, 24, 0, 1)*leafG, map(dayCycle, 0, 24, 0, 1)*leafB);
  for (int xx = 0; xx < leaves; xx++) {
    leaf[xx].drawLeaf();
  }
}

void drawBackground() {
  fill(map(dayCycle, 0, 24, 0, 150), map(dayCycle, 0, 24, 0, 150), map(dayCycle, 0, 24, 0, 250));
  shapeMode(POINTS);
  beginShape();
  vertex(0, 600);
  vertex(width, 550);
  vertex(width, 0);
  vertex(0, 0);
  endShape();
  fill(map(dayCycle, 0, 24, 0, 1)*groundR, map(dayCycle, 0, 24, 0, 1)*groundG, map(dayCycle, 0, 24, 0, 1)*groundB);
  beginShape();
  vertex(0, 600);
  vertex(width, 550);
  vertex(width, height);
  vertex(0, height);
  endShape();
  rectMode(CENTER);
  tree.beginShape();
  tree.fill(map(dayCycle, 0, 24, 0, 1)*150, map(dayCycle, 0, 24, 0, 1)*120, 0);
  tree.endShape();
  shape(tree);
}

static PVector center = new PVector(400, 300);
static int treeSize = 200;

class Leaf {
  
  PVector pos;
  int xSize;
  int ySize;
  
  Leaf() {
    pos = PVector.random2D();
    pos.setMag(int(random(treeSize)));
    pos.add(center);
    xSize = int(random(10))+10;
    ySize = int(random(10))+10;
  }
  
  void drawLeaf() {
    ellipse(pos.x, pos.y, xSize, ySize);
  }
}

class Slider {
  float x;
  float y;
  int minX;
  int minY;
  float maxX;
  float maxY;
  float xRatio;
  float yRatio;
  int size;
  boolean clicked = false;
  
  Slider(int minx, int miny, int maxx, int maxy) {
    x = minx;
    y = miny;
    minX = minx;
    minY = miny;
    maxX = maxx;
    maxY = maxy;
    xRatio = minX/maxX;
    yRatio = minY/maxY;
    size = 25;
  }
  
  void mouse() {
    if (mousePressed && abs(mouseX - x) <= 25 && abs(mouseY - y) <= 25) {
      clicked = true;
    }
    else if (!mousePressed) { clicked = false; }
  }
  
  void drawSlider() {
    
    // I am handling the movement of the slider with the mouse separate from the checks for the mouse. This way, if the mouse isn't over the slider, but the mouse hasn't been released, it will still try to follow.
    // The slider gets really choppy and moves poorly otherwise, as it is easy to take the mouse off of it since it is normally quite small.
    if (clicked) {
      if (mouseX <= maxX && mouseX >= minX) { x = mouseX; }
      else if (mouseX > maxX) { x = maxX; }
      else if (mouseX < minX) { x = minX; }
      if (mouseY <= maxY && mouseY >= minY) { y = mouseY; }
      else if (mouseY > maxY) { y = maxY; }
      else if (mouseY < minY) { y = minY; }
    }
    xRatio = (x-minX)/(maxX-minX);
    yRatio = (y-minY)/(maxY-minY);
    fill(0);
    stroke(255);
    rectMode(CENTER);
    rect(maxX-(maxX-minX)/2, maxY-(maxY-minY)/2, maxX-minX+size, maxY-minY+size);
    fill(255);
    noStroke();
    rect(x, y, size, size);
  }
}
