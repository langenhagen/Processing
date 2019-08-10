// Inspired by
// http://www.clicktorelease.com/blog/vertex-displacement-noise-3d-webgl-glsl-three-js

final String sketchName = "ECHTZEIT";

int width = 1024;
int height = 768;

float sphereRadius = min( width*0.3f, height*0.3f);
int sphereDetail = 128;

boolean noStroke = false;

PShader shader;
float amount = 100;
int timeMultiplier = 50;
int verticalTimeMultiplier = 80;

boolean isFiltersActive = true;
int filterRadius = 20;
float filterCoveringPower = 0.7;
PShader horizontalBlur;
PShader verticalBlur;

void setup() {
  size(1024, 768, P3D);

  stroke(255, 50);

  shader = loadShader("frag.glsl", "vert.glsl");
  shader(shader);
  shader.set("amount", amount);

  horizontalBlur = loadShader("additive_linear_blur_horizontal_frag.glsl");
  verticalBlur = loadShader( "additive_linear_blur_vertical_frag.glsl");
  horizontalBlur.set("offsetPerPixel", 1.0/width);
  verticalBlur.set("offsetPerPixel", 1.0/height);
  horizontalBlur.set("coveringPower", 0.7f);
  verticalBlur.set("coveringPower", 0.7f);
  horizontalBlur.set("radius", filterRadius);
  verticalBlur.set("radius", filterRadius );
}

void draw() {
  setWinTitleAndFps();

  background(0);

  shader.set("time",         millis() * 0.000001f * timeMultiplier);
  shader.set("verticalTime", millis() * 0.000001f * verticalTimeMultiplier);

  translate(width*0.5f, height*0.5f, 0);
  rotateX(mouseY * 0.01f);
  rotateY(mouseX * 0.01f);

  sphereDetail(sphereDetail);
  sphere( sphereRadius);

  if( isFiltersActive) {
    filter(horizontalBlur);
    filter(verticalBlur);
  }
}

void keyPressed() {
  if( key == 10) {
    // ENTER
    save("result_" + timestamp() + ".png");
  }
  if( key == 'p') {
    // PRINT SOMETHING
    println( " => " +sketchName + " " + millis() + " ms [" + (frameRate) + " fps]");
  }
  if( key == 32) {
    // SPACE BAR
    if( noStroke) {
      noStroke = false;
      stroke( 255, 25);

    }else {
      noStroke = true;
      noStroke();
    }
  }
  if( key == 'f') {
    isFiltersActive = !isFiltersActive;

  }
  if( key == 43) {
    // PLUS BUTTON
    shader.set("amount", ++amount);
    println("Amount: " + amount);

  } else if( key == 45) {
    // MINUS BUTTON
    shader.set("amount", --amount);
    println("Amount: " + amount);
  }
  if( key == 'q') {

    sphereDetail = max(1, --sphereDetail);
    println("Sphere Detail: " + sphereDetail);

  } else if( key == 'w') {

    sphereDetail = min( 512, ++sphereDetail);
    println("Shpere Detail: " + sphereDetail);
  }
  if( key == 'a') {

    --timeMultiplier;
    println( "TimeMultiplier: " + timeMultiplier);

  } else if( key == 's') {

    ++timeMultiplier;
    println( "TimeMultiplier: " + timeMultiplier);
  }
  if( key == 'y') {

    --verticalTimeMultiplier;
    println( "VerticalTimeMultiplier: " + verticalTimeMultiplier);

  } else if( key == 'x') {

    ++verticalTimeMultiplier;
    println( "VerticalTimeMultiplier: " + verticalTimeMultiplier);
  }

  //println((int)key);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    filterCoveringPower += 0.1f;

  } else if (mouseButton == RIGHT) {
    filterCoveringPower -= 0.1f;

  } else {
  }

  println( "Filter covering power: " + filterCoveringPower);

  horizontalBlur.set("coveringPower", filterCoveringPower);
  verticalBlur.set("coveringPower", filterCoveringPower);
}

void mouseWheel(MouseEvent event) {
  float summand = event.getCount();

  filterRadius -= summand;

  if(filterRadius < 0) {
    filterRadius = 0;
  }

  println( "Filter radius: " + filterRadius);

  horizontalBlur.set("radius", filterRadius);
  verticalBlur.set("radius", filterRadius );
}

// STANDARD HELPER FUNCTIONS //////////////////////////////////////////////////////////////////////

String timestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}

void setWinTitleAndFps() {
  if( frameCount % 100 == 0)
    frame.setTitle( sketchName + " [" + (frameRate) + " fps]");
}
