/******************************************************************
Kaleidoscope visual

TODO put Kaleidoskope in its own class

******************************************************************/

final String sketchName = "Poster";

// something like a debug macro, works well whithin the whole project.
final boolean __DEBUG__ = false;

int width = 3072;
int height = 3072;
int halfWidth = width/2;
int halfHeight = height/2;

final color backColor = color(0, 0, 0,255);
int stroke = 5;

final int maxDivisions = 16;
int nDivisions = (int)random(2, maxDivisions);
final int bigRadius = min( halfWidth, halfHeight);

final float maxRotationSpeed = .001f;
float rotationSpeed = 0.000f;

PVector prevPoint1 = new PVector(0, 0);
PVector prevPoint2 = new PVector(0, 0);

int bgAlpha = 30;
float r, g, b;
float a = 50;
float rSpeed, gSpeed, bSpeed;
float count = 0;

boolean doFadeOutFrames = false;
int fadeoutFrames = 0;
final int maxFadeoutFrames = 60;


PImage cln_mask_1, cln_mask_2, cln_mask_3;

PGraphics pg;

boolean pgInit = false;

void setup() {

  size(1024, 1024, P3D);

  frameRate(600);

  cln_mask_2 = loadImage("cln_bw_1_t_i.png");
  noSmooth();
  pg = createGraphics(width, height);
  pg.imageMode(CENTER);
  pg.strokeWeight( stroke);
  pg.noSmooth();
  pg.background( 0,0,0);
  background(0,0,0);
  genColors();

}


void draw() {


  setWinTitleAndFps();

  if(doFadeOutFrames == true)
      fadeoutOld(bgAlpha);

  drawKaleidoscope(pg);

  pg.image(cln_mask_2, halfWidth, halfHeight, 2*bigRadius+2, 2*bigRadius+2);

  image(pg.get(), 0, 0, 1024, 1024);


}


void drawKaleidoscope(PGraphics pg) {
  pg.beginDraw();
  pg.pushMatrix();

  pg.translate(halfWidth, halfHeight);
  pg.rotate( frameCount * rotationSpeed);
  float thetaD = map(mouseX, 0, width, -.05, .05);
  float theta  = random(TWO_PI / nDivisions);

  r += rSpeed;
  g += gSpeed;
  b += bSpeed;
  if( r>255 || r<0)  rSpeed = -rSpeed;
  if( g>255 || g<0)  gSpeed = -gSpeed;
  if( b>255 || b<0)  bSpeed = -bSpeed;

  pg.stroke( r, g, b, a);

  float angle = random(TWO_PI);
  float radius = random(8*3);

  float tmpX = prevPoint1.x + radius * cos(angle);
  float tmpY = prevPoint1.y + radius * sin(angle);

  //adding the mouse rotation
  float x = tmpX * cos(thetaD) - tmpY * sin(thetaD);
  float y = tmpY * cos(thetaD) + tmpX * sin(thetaD);


  if (x*x + y*y > bigRadius*bigRadius) {
    x = bigRadius * cos(atan2(prevPoint1.y, prevPoint1.x));
    y = bigRadius * sin(atan2(prevPoint1.y, prevPoint1.x));
  }

  for (int i=0; i<nDivisions; ++i) {
    pg.rotate(TWO_PI / nDivisions);

    pg.line(prevPoint1.x, prevPoint1.y, x, y);
    pg.line(prevPoint2.x, prevPoint2.y, x, -y);

  }
  prevPoint1 = new PVector(x, y);
  prevPoint2 = new PVector(x, -y);

  pg.popMatrix();
}


void genColors() {
  float lowerMultiplier = .8;
  float upperMultiplier = 1.5;

  r = random(255);
  g = random(255);
  b = random(255);
  rSpeed = (random(1) > .5 ? 1 : -1) * random(lowerMultiplier, upperMultiplier);
  gSpeed = (random(1) > .5 ? 1 : -1) * random(lowerMultiplier, upperMultiplier);
  bSpeed = (random(1) > .5 ? 1 : -1) * random(lowerMultiplier, upperMultiplier);
}


void fadeoutOld( int alpha) {

  if( fadeoutFrames > maxFadeoutFrames) {
    doFadeOutFrames = false;
    fadeoutFrames = 0;
    return;
  }

  bgOverdraw( backColor, alpha);
  ++fadeoutFrames;
}


void reset( int divisions) {
  nDivisions = divisions;
  prevPoint1 = new PVector(0, 0);
  prevPoint2 = new PVector(0, 0);
  genColors();

  rotationSpeed = random(-maxRotationSpeed, maxRotationSpeed);
  pg.background( backColor);

}


void resetAndFadeout() {
  doFadeOutFrames = true;
  int n_divisions = (int)random(2, maxDivisions);
  reset( n_divisions);
}


void bgOverdraw( color backColor, int alpha) {
  pg.fill(red(backColor), green(backColor), blue(backColor), alpha);
  pg.noStroke();
  pg.rect(0, 0, width, height);
}



void keyPressed() {

  // beware of the difference between key and keyCode
  if( keyCode == 123) {
    // F12
    save("result_" + timestamp() + ".png");
  }
  if( key == 'p') {
    // PRINT SOMETHING
    println( " => " +sketchName + " " + millis() + " ms [" + (frameRate) + " fps]");
  }
  if( key == ' ') {
      // reset
      doFadeOutFrames = true;
      int n_divisions = (int)random(2, maxDivisions);
      reset( n_divisions);
  }
  if( key == ENTER || key == RETURN ) {
      // SAVE HI RES
      println( "do");
      pg.save("highres_" + timestamp() + ".png");
  }

  //println("(int)key: " + (int)key + "\tkey: " + key + "\tkeyCode: " + keyCode);
}



// STANDARD HELPER FUNCTIONS //////////////////////////////////////////////////////////////////////

String timestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}


void setWinTitleAndFps() {
  if( frameCount % 100 == 0)
    frame.setTitle( sketchName + " [" + (frameRate) + " fps]");
}


void saveHiRes(int scaleFactor) {
  PGraphics hires = createGraphics(width*scaleFactor, height*scaleFactor, P3D);
  beginRecord(hires);
  hires.scale(scaleFactor);
  draw();
  endRecord();
  hires.save("hires_" + timestamp() + ".png");
}
