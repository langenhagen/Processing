import processing.video.*;

int width = 800;
int height = 600;
int halfWidth = width/2;
int halfHeight = height/2;

Capture cam;

float radius = 200.0;
float rotation = 0;
int nPoints = 3;
int xOffset=100;
int yOffset=100;


void settings() {
  size(width, height, P3D);
}

void setup() {
  //cam = new Capture(this, 80, 45, 15s); // parent, width, height, fps
  cam = new Capture(this);
  noStroke();
  background(255, 0, 0); // jawas
  textureWrap(REPEAT);



  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
  }


  cam.start();
}

void draw() {

  if (cam.available()) {
    // Reads the new frame
    cam.read();
  }

  image(cam, 0, 0, width, height);

  beginShape();

  texture(cam);

  for( float i=0; i<nPoints; ++i) {
    float thePoint = radians( i/nPoints * 360 + rotation);
    float x = halfWidth  + cos( thePoint) * radius;
    float y = halfHeight + sin( thePoint) * radius;

    vertex( x, y, x+xOffset, y+yOffset );
  }

  endShape();
}

//void captureEvent(Capture c) {
//  c.read();
//}



void keyPressed() {
  // beware of the difference between key and keyCode

   println("(int)key: " + (int)key + "\tkey: " + key + "\tkeyCode: " + keyCode);

 if( key == 's') {
    xOffset = int(random(-cam.width/3, cam.width/3));
    yOffset = int(random(-cam.height/3,cam.height/3));
  }
else if( keyCode == 38 /*up*/) {
    nPoints++;
  }
  else if( keyCode == 40 /*down*/) {
    nPoints--;
  }
  else if( keyCode == 37 /*left*/) {
    radius-=50;
  }
  else if( keyCode == 39 /*right*/) {
    radius+=50;
  }
  else if( key == 'r' ) {
    rotation=random(360);
  }

}