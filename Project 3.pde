Bubble bubbles[];
boolean mouseHeld;
Pin pin;
boolean gameStart;
boolean gameEnd;
PFont newFont;
boolean stalagtites;
Fall caveIn;
//***************************************************************************** Float values, set and used in lines: 
float trueMouseX;
float trueMouseY;

/*
********************************************************************************
*/

void setup() {
  newFont = createFont("Arial", 16, false);
  stalagtites = false;
  caveIn = new Fall();
  gameEnd = false;
  size(800, 800);
  mouseHeld = true;
  gameStart = false;
  drawBackground();
  pin = new Pin();
  bubbles = new Bubble[5];
  for (int xx = 0; xx < bubbles.length; xx++) {
    bubbles[xx] = new Bubble();
  }
}

/*
********************************************************************************
*/

// I decided to use the draw method as a general caller to other methods, so the less code here the better
void draw() {
  if (gameEnd) { endMode(); }
  else if (gameStart) { gameMode(); }
  else { menuMode(); }
}

/*
********************************************************************************
*/

// I made a main "menu" to just give a basic idea of what will happen, and waits for the user to click before continuing
void menuMode() {
  
  noStroke();
  drawBackground();
  textAlign(CENTER);
  
  String lines[] = new String[6];
  textFont(newFont, 16);
  fill(255);
  
  // An array of strings is much prettier in code to create and output than printing many different strings
  lines[0] = "Welcome to your first day at the Bubble Cave!";
  lines[1] = "The floor in the cave is constantly making bubbles.";
  lines[2] = "Your job is to pop the bubbles before they hit the top of the cave.";
  lines[3] = "If one bubble hits the top, then stalagtites will fall!";
  lines[4] = "If you needle gets hit by a stalagtite, then you're fired!";
  lines[5] = "Click the mouse to begin.";
  for (int xx = 0; xx < 6; xx++) {
    text(lines[xx], width/2, 200 + xx*20);
  }
  
  // I use a mouseHeld variable throughout my code to check if the use has pressed the mouse previously, and if so then it is being held. I don't want it to skip something or infinitely popped bubbles
  if (mousePressed) {
    if (!mouseHeld) {
      gameStart = true;
      mouseHeld = true;
    }
  }
  else { mouseHeld = false; }
}

/*
********************************************************************************
*/

// I also added a basic end screen, basically the same as the menu but just saying you are fired and closing the program when you click
void endMode() {
  
  noStroke();
  drawBackground();
  textAlign(CENTER);
  
  String lines[] = new String[6];
  textFont(newFont, 32);
  fill(255);
  
  lines[0] = "You let a stalagtite break you pin!";
  lines[1] = "YOU ARE FIRED";
  for (int xx = 0; xx < 2; xx++) {
    text(lines[xx], width/2, 200 + xx*40);
  }
  
  if (mousePressed) {
    if (!mouseHeld) {
      exit();
    }
  }
  else { mouseHeld = false; }
}

/*
********************************************************************************
*/

// The main game state! Here I hide the cursor, and start the normal game loop. This calls all of the other classes which handle what they do on their own
void gameMode() {
  noStroke();
  noCursor();
  drawBackground();
  
  for (int xx = 0; xx < bubbles.length; xx++) {
    bubbles[xx].drawBubble();
  }
  
  caveIn.drawStalagtites();
  
  if (mousePressed) {
    if (!mouseHeld) {
     click(); 
     mouseHeld = true;
    }
  }
  else { mouseHeld = false; }
  pin.drawPin();
  
  textAlign(LEFT);
  textFont(newFont);
  fill(255);
  trueMouseX = mouseX; trueMouseY = mouseY;
  text("X: " + trueMouseX + "  Y: " + trueMouseY, 20, height - 20);
}

/*
********************************************************************************
*/

// I added a separate click method just to make the other methods prettier on their own. I check for collision with bubbles here and pop if so
void click() {
  for (int xx = 0; xx < bubbles.length; xx++) {
    //************************************************************************** Distance for finding collision with bubbles
    
    if (dist(mouseX, mouseY, bubbles[xx].bubbleX, bubbles[xx].bubbleY) < bubbles[xx].bubbleSize/2 && bubbles[xx].popped == 0) {
      bubbles[xx].clickBubble();
      //************************************************************************ System.out.println for showing which bubble was popped
      System.out.println("You popped bubble " + (xx + 1) + "!");
    }
  }
}

/*
********************************************************************************
*/

// Again I separated the backgound being drawn so it is very clean as it gets called in several other places. Also this way I can have a pretty cave ceiling.
void drawBackground() {
  fill(80, 50, 0);
  shapeMode(TRIANGLE);
  beginShape();
  vertex(0, 0);
  vertex(0, 50);
  vertex(width, 0);
  endShape();
  for (int xx = 0; xx < 50; xx++) {
    fill(80-xx, 50-xx, 0);
    beginShape();
    vertex(0, 50+xx*2);
    vertex(0, 50+xx*2+2);
    vertex(width, xx*2+2);
    vertex(width, xx*2);
    endShape();
  }
  fill(0);
  shapeMode(QUAD);
  beginShape();
  vertex(0, 100);
  //**************************************************************************** Width and Height for draw a pretty background
  vertex(width, 50);
  vertex(width, height);
  vertex(0, height);
  endShape();
}

/*
********************************************************************************
*/

// I made a class for the pin, which replaces the mouse cursor. If held, the pin won't continue to pop, but will be held up.
class Pin {
  //***************************************************************************** mouseX and mouseY to set pin x and y
  int x = mouseX;
  int y = mouseY;
  int pinSpeed = 15;
  
  public void drawPin() {
    
    x = mouseX;
    y = mouseY;
    
    if (mouseHeld) {
      ellipseMode(CENTER);
      fill(255, 0, 0);
      ellipse(x, y, 30, 30);
    }
    else {
      fill(200);
      shapeMode(TRIANGLE);
      beginShape();
      vertex(x, y);
      vertex(x + 50, y + 40);
      vertex(x + 40, y + 50);
      endShape();
      fill(255, 0, 0);
      ellipseMode(CENTER);
      ellipse(x + 50, y + 50, 25, 25);
    }
  }
}

/*
********************************************************************************
*/

// This is the master class for the stalagtites and cave ins. It draws stalagtites when the stalagtite count is > 0 and resets when a cave in happens.
class Fall {
  boolean init = true;
  int stalagtites = 0;
  Stalagtite arr[] = new Stalagtite[10];
  
  public void drawStalagtites() {
    
    if (stalagtites > 0) {
      if (init) {
        for (int xx = 0; xx < 10; xx++) {
          arr[xx] = new Stalagtite();
        }
        init = false;
      }
      for (int xx = 0; xx < 10; xx++) {
        if (arr[xx].y < height) {
          stalagtites -= arr[xx].drawSelf();
        }
      }
    }
  }
  
  public void reset() {
    if (init) {
        for (int xx = 0; xx < 10; xx++) {
          arr[xx] = new Stalagtite();
        }
        init = false;
      }
    if (stalagtites == 0) {
      stalagtites = 10;
      for (int xx = 0; xx < 10; xx++) {
        arr[xx].reset();
      }
    }
  }
}

/*
********************************************************************************
*/

// This is the stalagtite class to control every stalagtite individually. They have a random X coordinate which changes each time they reset, as well as they fall at a random time
// The draw class here is unique because it isn't void and actually returns and integer, which is only 0 when it reaches the end of the screen and should decrease the amount of stalagtites
class Stalagtite {
  int x = int(random(width));
  int y = -30;
  int shake = int(random(300));
  int speed = 20;
  
  public int drawSelf() {
    if (y < height) {
      if (shake > 0) { shake--; }
      else {
        fill(100, 60, 0);
        shapeMode(TRIANGLE);
        beginShape();
        vertex(x - 20, y - 60);
        vertex(x + 20, y - 60);
        vertex(x, y + 60);
        endShape();
        y += speed;
        if (y >= height) { 
          y = height + 120;;
          return 1; 
        }
        if (abs(pin.x-x) <= 15 && abs(pin.y-y) <= 50) {
          gameEnd = true;
        }
      }
    }
    return 0;
  }
  
  public void reset() {
    y = 0;
    x = int(random(width));
    shake = int(random(60));
  }
}

/*
********************************************************************************
*/

// The bubble class was the most fun to make, and the bubbles all have their own unique patterns, speeds, and sizes. They "swirl" back and forth by having an increasing and decreasing X modifier.
class Bubble {
  int popped = int(random(200));
  int bubbleSize = int(random(80)) + 50;
  int bubbleX = int(random(width - 100)) + 50;
  int bubbleY = height;
  int deltaX = 10;
  boolean everyOther = false;
  boolean increaseX = false;
  int bubbleSpeed = int(random(3)) + 2;
  
  public void drawBubble() {
    if (popped == 0) {
      
      // If the bubble reaches the top of the cave then cause a cave in and reset the bubble.
      if (bubbleY < 0) { 
        popped = 50;
        bubbleY = height;
        caveIn.reset();
        //********************************************************************* System.out.println for telling when a bubble hits the ceiling
        System.out.println("CAVE IN!!!");
      }
      else {
        fill(0, 150, 255, 50);
        ellipse(bubbleX, bubbleY, bubbleSize/2, bubbleSize/2);
        ellipse(bubbleX - bubbleSize/4, bubbleY - bubbleSize/4, bubbleSize/3, bubbleSize/3);
        fill(0, 150, 255, 100);
        ellipse(bubbleX, bubbleY, bubbleSize, bubbleSize);
        bubbleY -= bubbleSpeed;
        bubbleX += deltaX;
        
        //************************************************************************ Min and Max for not letting bubbles go off screen entirely
        if (bubbleX >= width) { bubbleX = min(bubbleX, width); }
        else if (bubbleX <= 0) { bubbleX = max(bubbleX, 0); }
        if (increaseX == false && everyOther) { deltaX--; everyOther = false; }
        else if (increaseX && everyOther) { deltaX++; everyOther = false; }
        else if (!everyOther) { everyOther = true; }
        if (deltaX >= 10) { increaseX = false; }
        else if (deltaX <= -10) { increaseX = true; }
      }
    }
    else { popped--; }
  }
  
  // This gets call if clicked on when within reach of the mouse and creates a split second pop animation relative to the bubble's size.
  public void clickBubble() {
    fill(0, 150, 255, 100);
    arc(bubbleX, bubbleY, bubbleSize*2, bubbleSize*2, 0.3, HALF_PI - 0.3, OPEN);
    arc(bubbleX, bubbleY, bubbleSize*2, bubbleSize*2, HALF_PI + 0.3, PI - 0.3, OPEN);
    arc(bubbleX, bubbleY, bubbleSize*2, bubbleSize*2, PI + 0.3, PI + HALF_PI - 0.3, OPEN);
    arc(bubbleX, bubbleY, bubbleSize*2, bubbleSize*2, PI + HALF_PI + 0.3, TWO_PI - 0.3, OPEN);
    popped = int(random(200));
    bubbleX = int(random(width - 100)) + 50;
    bubbleY = height;
  }
}
