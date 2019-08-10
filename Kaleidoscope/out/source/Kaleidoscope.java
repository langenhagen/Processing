import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Kaleidoscope extends PApplet {

/******************************************************************
Kaleidoscope visual

TODO put Kaleidoskope in its own class

******************************************************************/

final String sketchName = "Kaleidoscope";

// something like a debug macro, works well whithin the whole project.
final boolean __DEBUG__ = false;

int width = 1024;
int height = 768;
int halfWidth = width/2;
int halfHeight = height/2;

final int backColor = color(0, 0, 0);
int stroke = 2;

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

final float autoResetProbability = 0.071f;

float maskProbability = 78;
PImage cln_mask_1, cln_mask_2, cln_mask_3;
boolean doMask = false;

public void setup() {
  
  size(width, height, P3D);
  
  frameRate(60);
  
  background( backColor);
  strokeWeight( stroke);
  noSmooth();
  
  cln_mask_1 = loadImage("cln_bw_1_t.png");
  cln_mask_2 = loadImage("cln_bw_1_t_i.png");
  cln_mask_3 = loadImage("cln_mask_3.png");
  
  imageMode(CENTER);
  
  genColors();
  
}



public void draw() {
 
  setWinTitleAndFps();
  
  if(  autoResetProbability > random(100))
    resetAndFadeout();  

  if(doFadeOutFrames == true)
      fadeoutOld(bgAlpha);
  
  drawKaleidoscope();
  
  //image(cln_mask_1, halfWidth, halfHeight, 80, 80);
  
  if( doMask == true)
    image(cln_mask_2, halfWidth, halfHeight, 2*bigRadius+2, 2*bigRadius+2);

}


public void drawKaleidoscope() {
  pushMatrix();
  
  translate(halfWidth, halfHeight);
  rotate( frameCount * rotationSpeed);
  float thetaD = map(mouseX, 0, width, -.05f, .05f);
  float theta  = random(TWO_PI / nDivisions);
  
  r += rSpeed;
  g += gSpeed;
  b += bSpeed;
  if( r>255 || r<0)  rSpeed = -rSpeed;
  if( g>255 || g<0)  gSpeed = -gSpeed;
  if( b>255 || b<0)  bSpeed = -bSpeed;
  
  stroke( r, g, b, a);
  
  float angle = random(TWO_PI);
  float radius = random(8);
  
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
    rotate(TWO_PI / nDivisions);
    
    line(prevPoint1.x, prevPoint1.y, x, y);
    line(prevPoint2.x, prevPoint2.y, x, -y);

  }
  prevPoint1 = new PVector(x, y);
  prevPoint2 = new PVector(x, -y);
  
  popMatrix();
}


public void genColors() {
  float lowerMultiplier = .8f;
  float upperMultiplier = 1.5f;
    
  r = random(255);
  g = random(255);
  b = random(255);
  rSpeed = (random(1) > .5f ? 1 : -1) * random(lowerMultiplier, upperMultiplier);
  gSpeed = (random(1) > .5f ? 1 : -1) * random(lowerMultiplier, upperMultiplier);
  bSpeed = (random(1) > .5f ? 1 : -1) * random(lowerMultiplier, upperMultiplier);
}


public void fadeoutOld( int alpha) {
  
  if( fadeoutFrames > maxFadeoutFrames) {
    doFadeOutFrames = false;
    fadeoutFrames = 0;
    return;
  }
  
  bgOverdraw( backColor, alpha);
  ++fadeoutFrames;
}


public void reset( int divisions) {
  nDivisions = divisions;
  prevPoint1 = new PVector(0, 0);
  prevPoint2 = new PVector(0, 0);
  genColors();
  
  rotationSpeed = random(-maxRotationSpeed, maxRotationSpeed);
  
  doMask = maskProbability > random(100)  ? true : false;
}


public void resetAndFadeout() {
  doFadeOutFrames = true;
  int n_divisions = (int)random(2, maxDivisions);
  reset( n_divisions);
}


public void bgOverdraw( int backColor, int alpha) {
  fill(red(backColor), green(backColor), blue(backColor), alpha);
  noStroke();
  rect(0, 0, width, height);
}



public void keyPressed() {
  
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
      saveHiRes( 2);
  }
  
  //println("(int)key: " + (int)key + "\tkey: " + key + "\tkeyCode: " + keyCode);
}



// STANDARD HELPER FUNCTIONS //////////////////////////////////////////////////////////////////////

public String timestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}


public void setWinTitleAndFps() {
  if( frameCount % 100 == 0)
    frame.setTitle( sketchName + " [" + (frameRate) + " fps]");
}


public void saveHiRes(int scaleFactor) {
  PGraphics hires = createGraphics(width*scaleFactor, height*scaleFactor, P3D);
  beginRecord(hires);
  hires.scale(scaleFactor);
  draw();
  endRecord();
  hires.save("hires_" + timestamp() + ".png");
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Kaleidoscope" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
