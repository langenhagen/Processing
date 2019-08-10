import processing.video.*;
Movie myMovie;

final String sketchName = "Sketch Name";
final boolean __DEBUG__ = false;          // debug macro switch

int width = 800;
int height = 600;
int halfWidth = width/2;
int halfHeight = height/2;

void settings() {
  size(width, height, P3D);
}

void setup() {
  myMovie = new Movie(this, "SampleVideo_1280x720_5mb.mp4");
  myMovie.loop();

  noStroke();
  background(255, 0, 0); // jawas
  textureWrap(REPEAT);
}

float radius = 200.0;
float rotation = 0;
int nPoints = 3;
int xOffset=100;
int yOffset=100;


void draw() {
  image(myMovie, 0, 0, width, height);


  beginShape();

  texture(myMovie);

  for( float i=0; i<nPoints; ++i) {
    float thePoint = radians( i/nPoints * 360 + rotation);
    float x = halfWidth  + cos( thePoint) * radius;
    float y = halfHeight + sin( thePoint) * radius;

    vertex( x, y, x+xOffset, y+yOffset );
  }

  endShape();

}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

// -------------------------------------------------------------------------------------------------
// Standard Helpers

void keyPressed() {
  // beware of the difference between key and keyCode

   println("(int)key: " + (int)key + "\tkey: " + key + "\tkeyCode: " + keyCode);

 if( key == 's') {
    xOffset = int(random(-myMovie.width/3, myMovie.width/3));
    yOffset = int(random(-myMovie.height/3,myMovie.height/3));
  }
  else if( key == 'p') {
    // print something
    println( " => " +sketchName + " " + millis() + " ms [" + (frameRate) + " fps]");
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