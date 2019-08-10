String sketchName = "Triangled Circle";

// for triangled circle

PGraphics canvas;

int triangledCirclePositionX;
int triangledCirclePositionY;

int numPoints = 3;

// for waterlike blobs

ArrayList<PVector> blobPositionsAndRadii = new ArrayList<PVector>(); // (poxX, posY, radius)

void setup() {
  size(1000, 1000, P3D);
  canvas = createGraphics(width, height, P3D);

  noSmooth();
  canvas.noSmooth();

  noStroke();

  // ** triangled circle stuff **

  triangledCirclePositionX = width / 2;
  triangledCirclePositionY = height / 2;

  // ** waterlike blobs stuff **

  //noiseDetail(64,0.2);
}

void draw() {
  setWinTitleAndFps();

  color color1 = color(192);
  color color2 = color(128);
  color color3 = color(33);

  drawTriangledCircle(color1, color2, color3);

  image(canvas, 0,0);

  //drawWaterlikeBlobs(1,0.7f, 5);
}


void drawWaterlikeBlobs(float reduction, float randomReductionVariance, float minRadius)
{
  canvas.loadPixels();

  float time = millis();

  if( noise( -time) > 0.7f)
  {
    // create new blob

    PVector vec = new PVector();

    vec.z = noise(time) * 70; // radius

    vec.x = noise(0, time * 0.0003f)    * width;  // x coordinate
    vec.y = noise(0, 0, time * 0.0003f) * height; // y coordinate

    blobPositionsAndRadii.add( vec);
  }

  // ** reduce blob sizes and delete verry small blobs and draw the remaining ones **
  for (int i = blobPositionsAndRadii.size()-1; i >= 0; i--)
  {
    PVector v = blobPositionsAndRadii.get(i);

    v.z -= reduction + random(randomReductionVariance);

    if (v.z < minRadius)
    {
      // delete small blobs
      blobPositionsAndRadii.remove(i);
    }
    else
    {
      // draw blobs

      int pixelIndex = (int)v.y * canvas.width + (int)v.x;
      color c = canvas.pixels[ pixelIndex];
      fill( c, 220);
      ellipse(v.x, v.y, v.z, v.z);
    }
  }
}

void drawTriangledCircle(color color1, color color2, color color3)
{
  canvas.beginDraw();

  canvas.background(0);
  canvas.noStroke();

  float time = millis() * 0.0003f;
  float maxSize = width*0.4f;

  float outsideRadius = map( (sin(time)), -1, 1, 0, maxSize);
  float insideRadius =  map( (cos(time)), -1, 1, 0, maxSize);

  /*
  outsideRadius = map(mouseX, 0, width, -width, width);
  insideRadius =  map(mouseY, 0, width, -width, width);
  */

  float angle = 0;
  float angleStep = 180.0f/numPoints;

  canvas.beginShape(TRIANGLES);

  // outside triangles

  for (int i = 0; i <= numPoints; i++) {
    canvas.fill(color1);
    float px = triangledCirclePositionX + cos(radians(angle)) * outsideRadius;
    float py = triangledCirclePositionY + sin(radians(angle)) * outsideRadius;
    canvas.vertex(px, py);
    angle += angleStep;

    px = triangledCirclePositionX + cos(radians(angle)) * insideRadius;
    py = triangledCirclePositionY + sin(radians(angle)) * insideRadius;
    canvas.vertex(px, py);

    canvas.fill(color3);
    angle += angleStep;
    px = triangledCirclePositionX + cos(radians(angle)) * outsideRadius;
    py = triangledCirclePositionY + sin(radians(angle)) * outsideRadius;
    canvas.vertex(px, py);
  }

  angle = -angleStep;

  // inside triangles

  for (int i = 0; i <= numPoints; i++) {
    canvas.fill(color2);
    float px = triangledCirclePositionX + cos(radians(angle)) * insideRadius;
    float py = triangledCirclePositionY + sin(radians(angle)) * insideRadius;
    canvas.vertex(px, py);
    angle += angleStep;

    px = triangledCirclePositionX + cos(radians(angle)) * outsideRadius;
    py = triangledCirclePositionY + sin(radians(angle)) * outsideRadius;
    canvas.vertex(px, py);

    canvas.fill(color3);
    angle += angleStep;
    px = triangledCirclePositionX + cos(radians(angle)) * insideRadius;
    py = triangledCirclePositionY + sin(radians(angle)) * insideRadius;
    canvas.vertex(px, py);
  }

  canvas.endShape();

  canvas.endDraw();
}

void keyPressed() {
  int keyIndex = -1;

  if( key == 10)
  {
    // ENTER
    String timestamp = year() + nf(month(),2) + nf(day(),2) + "-"  + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
    save("result_" + timestamp + ".png");
  }
  if( key == 'p')
  {
    // PRINT SOMETHING
    println( " => " +sketchName + " [" + (frameRate) + " fps]");
  }
  if( key == 'q')
  {
    numPoints++;
  }
  if( key == 'w')
  {
    numPoints--;
  }

}

void setWinTitleAndFps()
{
  if( frameCount % 100 == 0)
    frame.setTitle( sketchName + " [" + (frameRate) + " fps]");
}
