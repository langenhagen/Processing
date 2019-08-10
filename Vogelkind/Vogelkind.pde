final String sketchName = "Vogelkind Shader";

int width = 800;
int height = 600;

PImage vk1, vk2, vk3, vk4;
float vkStart = -1;
boolean vkAction = false;

void setup() {
  size(800, 600, P3D);

  vk1 = loadImage("vk1.png");
  vk2 = loadImage("vk2.png");
  vk3 = loadImage("vk3.png");
  vk4 = loadImage("vk4.png");
}

void draw() {
  setWinTitleAndFps();

  background(0);

  vkScreen();
}

boolean vkScreen() {
  if( vkStart == -1) {
    vkStart = millis();
  }

  float imgHeight = vk1.height * (float)width/vk1.width;
  float imgPosY = (height - imgHeight) * 0.5f;

  float time = millis() - vkStart;

  if( (time-2500)*0.05f < TAU+HALF_PI) {
    tint(255, (sin((time-2500)*0.05)+1)*128);
  } else {
    tint(255);
  }
  image( vk1, 0,imgPosY, width, imgHeight);

  tint( max(0, time - 3500)*0.3f );
  image( vk2, 0,imgPosY, width, imgHeight);

  tint( max(0, time - 3900)*0.3f);
  image( vk3, 0,imgPosY, width, imgHeight);

  tint( max(0, time - 5500)*0.17f);
  image( vk4, 0,imgPosY, width, imgHeight);

  float fillLast = max(0, time - 8000)*0.13f;
  fill(0, fillLast);
  rect( 0, 0, width, height);

  if( fillLast < 255) {
    return true;
  } else {
    return false;
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
    vkAction = true;
  }
  //println((int)key);
}

// STANDARD HELPER FUNCTIONS //////////////////////////////////////////////////////////////////////

String timestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}

void setWinTitleAndFps() {
  if( frameCount % 100 == 0)
    frame.setTitle( sketchName + " [" + (frameRate) + " fps]");
}
