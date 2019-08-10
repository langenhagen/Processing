final String sketchName = "4 RAW";

ProgramMode mode = ProgramMode.Intro;
ProgramMode modeInLastFrame;
FilterMode filterMode = FilterMode.Default;
ShaderMode shaderMode = ShaderMode.Default;
PShader shader;
int modeMillis;
int modeMillisBegin;

final int width = 800;
final int height = 600;

// vogelkind
PImage vk1, vk2, vk3, vk4;

// next EffectTime
int nextEffectTime = -1;

// ring geometry
ArrayList<Triangle> ring;
float ringCenterX = width*0.5f;
float ringCenterY = height*0.5f;
float outsideRadius = height*0.4;
float insideRadius = outsideRadius * 0.7629;
int radialParts = 4;
int numSegments = 80;

// black bars
float blackBarWidth = outsideRadius * 0.0963;
float blackBarOpeningSpeed = 3.2f;
float blackBarRotationOffset = 30;
float blackBarRotationSpeed = 0.0000000008f;

// build
float buildSpeed = 1.5f;

// fade in quarters
int[] fadeQuartersTimeOffset = {1, 2, 3, 4 };
float fadeQuartersOffsetTime = 550;

// explosion & crippled explosion
ArrayList<PVector> explosionDirections;
FloatList explosionRotationSpeeds;
float explosionCenterVarianceX = 55;
float explosionCenterVarianceY = 55;
float explosionSpeed = 15;
float explosionSpeedVariance = 0.4f;
float explosionSpeedReduction = 0.995f;
float explosionSpeedReductionVariance = 0.2f; // TRY VALUES LIKE 2.0
float explosionRotationSpeedVariance = 1;
float explosionRotationSpeedReduction = 0.98f;

float crippledExplosionSpeed = 5;
float crippledExplosionSpeedVariance = 5.5f;
float crippledExplosionRotationSpeedVariance = 0;
float crippledExplosionSpeedReductionVariance = 1.5f;

// rotate fast
float rotateFastSpeed = 0.001f;

// rotate slow
float rotateSlowSpeed = 0.0001f;

// fade in bars
int fadeBarsOffsetTime = 400;
int[] fadeBars = { 0, 1, 2, 3 };

// quarter switch
PGraphics quarter;
int[] switchTo = {0, 1, 2, 3};

// blur shader
PShader horizontalBlur;
PShader verticalBlur;
int horizontalBlurRadius = 15;
int verticalBlurRadius = 15;

// wide additive blur shader
PShader additiveHorizontalBlur;
PShader additiveVerticalBlur;
float additiveBlurCoveringPower = 0.7f;
int additiveHorizontalBlurRadius = 60;
int additiveVerticalBlurRadius = 60;

// narrow additive blur shader
PShader additiveHorizontalBlur2;
PShader additiveVerticalBlur2;
float additiveBlurCoveringPower2 = 0.7f;
int additiveHorizontalBlurRadius2 = 25;
int additiveVerticalBlurRadius2 = 25;

// perlin noise shader
PShader perlin;

// random distort shader
PShader randomDistort;

// line distort shader;
PShader linesDistort;

// STANDARD METHODS //////////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup() {
  size(800, 600, P3D);

  vk1 = loadImage("vk1.png");
  vk2 = loadImage("vk2.png");
  vk3 = loadImage("vk3.png");
  vk4 = loadImage("vk4.png");
  tint(0,0);
  image( vk1, 0,0, width, height);
  image( vk2, 0,0, width, height);
  image( vk3, 0,0, width, height);
  image( vk4, 0,0, width, height);
  
  perlin = loadShader("perlin_frag.glsl", "perlin_vert.glsl");
  
  createQuarter();
  
  horizontalBlur = loadShader( "linear_blur_horizontal_frag.glsl");
  horizontalBlur.set("offsetPerPixel", 1.0/width);
  horizontalBlur.set("radius", horizontalBlurRadius);
  
  verticalBlur = loadShader( "linear_blur_vertical_frag.glsl");
  verticalBlur.set("offsetPerPixel", 1.0/height);
  verticalBlur.set("radius", verticalBlurRadius);
  
  additiveHorizontalBlur = loadShader( "additive_linear_blur_horizontal_frag.glsl");
  additiveHorizontalBlur.set("offsetPerPixel", 1.0/width);
  additiveHorizontalBlur.set("radius", additiveHorizontalBlurRadius);
  additiveHorizontalBlur.set("coveringPower", additiveBlurCoveringPower);
  
  additiveVerticalBlur = loadShader( "additive_linear_blur_vertical_frag.glsl");
  additiveVerticalBlur.set("offsetPerPixel", 1.0/height);
  additiveVerticalBlur.set("radius", additiveVerticalBlurRadius);
  additiveVerticalBlur.set("coveringPower", additiveBlurCoveringPower);
  
  additiveHorizontalBlur2 = loadShader( "additive_linear_blur_horizontal_frag.glsl");
  additiveHorizontalBlur2.set("offsetPerPixel", 1.0/width);
  additiveHorizontalBlur2.set("radius", additiveHorizontalBlurRadius2);
  additiveHorizontalBlur2.set("coveringPower", additiveBlurCoveringPower2);
  
  additiveVerticalBlur2 = loadShader( "additive_linear_blur_vertical_frag.glsl");
  additiveVerticalBlur2.set("offsetPerPixel", 1.0/height);
  additiveVerticalBlur2.set("radius", additiveVerticalBlurRadius2);
  additiveVerticalBlur2.set("coveringPower", additiveBlurCoveringPower2);
  
  randomDistort = loadShader("random_distort_brightness_subtract_frag.glsl");
  randomDistort.set("variance", 0.3);
  
  linesDistort = loadShader("random_distort_brightness_lines_frag.glsl");
  linesDistort.set("lineWidth", 0.03);
  linesDistort.set("power", 0.8);
  
  noiseDetail(2,0.75f);
  
  println("num ring segments: " + numSegments); 

  stroke(255, 0);
}

void draw() {
  setWinTitleAndFps();
  
  if ( modeInLastFrame != mode) {  
    modeInLastFrame = mode;
    
    modeMillis = 0;
    modeMillisBegin = millis();
    
    println( "Program Mode: " + mode); 
    
  } else {
    modeMillis = millis() - modeMillisBegin;  
  }
  
  if( shaderMode == ShaderMode.Default) {
    resetShader();
  } else if( shaderMode == ShaderMode.Perlin) {
    shader = perlin;
    
    perlin.set("time",         millis() * 0.0000001f * 300);
    perlin.set("verticalTime", millis() * 0.000001f * 0);
    perlin.set("amount", 80.0f);
  }
  
  switch( mode) {
  case Intro:
    modeIntro();
    break;
  case InitNormal:
    modeInitNormal();
  case Normal:
    modeNormal();
    break;
  case InitBuild:
    background(0);
    modeInitBuild();
  case Build:
    background(0);
    modeBuild();
    break;
  case InitFadeInQuarters:
    modeInitFadeInQuarters();
  case FadeInQuarters:
    modeFadeInQuarters();
    break;
  case InvertOpen:
    modeInvertOpen();
    break;
  case ClockBars:
    background(0);
    modeClockBars();
    break;
  case FlickeringBars:
    background(0);
    modeFlickeringBars();
    break;
  case InitFadeInBars:
    modeInitFadeInBars();
  case FadeInBars:
    modeFadeInBars();
    break;
  case ClockQuarters:
    modeClockQuarters();
    break;
     
  case InitExplosion:
    modeInitExplosion();
  case Explosion:
    background(0);
    modeExplosion();
    break;
  case InitCrippledExplosion:
    modeInitCrippledExplosion();
  case CrippledExplosion:
    background(0);
    modeCrippledExplosion();
    break;
  case RotateFast:
    background(0);
    modeRotateFast();
    break;
  case RotateSlow:
    background(0);
    modeRotateSlow();
    break;
  case FlickeringQuarters:
    background(0);
    modeFlickeringQuarters();
    break;
  case InitQuarterSwitch:
    modeInitQuarterSwitch();
  case QuarterSwitch:
    modeQuarterSwitch();
    break;
    
  case Black:
    background(0);
    break;
  case BlackOut:
    modeBlackOut();
    break;
  default:
    background( 128, 0, 0);
    println( "Mode " + mode + " not known by draw() function.");
  }
  
  if( filterMode == FilterMode.Blur) {
    filter(horizontalBlur);
    filter(verticalBlur);
  } else if( filterMode == FilterMode.AdditiveBlur) {
    filter(additiveHorizontalBlur);
    filter(additiveVerticalBlur);
  } else if( filterMode == FilterMode.AdditiveBlurNarrow) {
    filter(additiveHorizontalBlur2);
    filter(additiveVerticalBlur2);
  } else if( filterMode == FilterMode.RandomBrightnessDistort) {
    randomDistort.set("seed", (float)modeMillis);
    filter( randomDistort);
  } else if( filterMode == FilterMode.LinesDistort) {
    linesDistort.set("seed", (float)modeMillis);
    linesDistort.set("offset", (float)modeMillis/20000.0f);
    filter( linesDistort);
  }  
} // END draw()

void keyPressed() {
  if ( key == 10) {
    // ENTER
    save("result_" + timestamp() + ".png");
  }
  if ( key == 'p') {
    // PRINT SOMETHING
    println( " => " +sketchName + " [" + (frameRate) + " fps]");
  }
  
  // standards
  if ( key == 9) {
    // TAB
    mode = ProgramMode.InitNormal;
  
  //aufbau
  } else if ( key == '1') {
    mode = ProgramMode.InitBuild;
  } else if ( key == '2') {
    mode = ProgramMode.InvertOpen;
  } else if ( key == '3') {
    mode = ProgramMode.InitFadeInQuarters;
  } else if ( key == '4') {
    mode = ProgramMode.ClockQuarters;
  } else if ( key == '8') {
    mode = ProgramMode.ClockBars;
  } else if ( key == '9') {
    mode = ProgramMode.FlickeringBars;
  } else if ( key == '0') {
    mode = ProgramMode.InitFadeInBars;

  // effekt
  } else if ( key == 'q') {
    mode = ProgramMode.FlickeringQuarters;
  } else if ( key == 'w') {
    mode = ProgramMode.InitCrippledExplosion;
  } else if ( key == 'e') {
    mode = ProgramMode.InitExplosion;
  } else if ( key == 'r') {
    mode = ProgramMode.RotateFast;
  } else if ( key == 't') {
    mode = ProgramMode.RotateSlow;
  } else if ( key == 'z') {
    mode = ProgramMode.InitQuarterSwitch;
    
  // abbau
  } else if ( key == 'a') {
    mode = ProgramMode.Black;
  } else if ( key == 's') {
    mode = ProgramMode.BlackOut;
  }
  
  // filter
  if( key == 'y' ) {
    filterMode = FilterMode.Blur;
  } else if( key == 'x') {
    filterMode = FilterMode.AdditiveBlur;
  } else if( key == 'c') {
    filterMode = FilterMode.AdditiveBlurNarrow;
  } else if( key == 'v') {
    shaderMode = ShaderMode.Perlin;
  } else if( key == 'b') {
    filterMode = FilterMode.RandomBrightnessDistort;
  } else if( key == 'n') {
      filterMode = FilterMode.LinesDistort;
  } else if( key == '-') {
    filterMode = FilterMode.Default;
    shaderMode = ShaderMode.Default;
  }    
}

// MODE FUNCTIONS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void modeInitNormal() {
  buildRing(ringCenterX, ringCenterY, outsideRadius, insideRadius, radialParts, numSegments);

  mode = ProgramMode.Normal;
}

void modeNormal() { 
  background(0);
  
  drawRing();
  
  drawBar( blackBarWidth, 0 );
  drawBar( blackBarWidth, HALF_PI );
  drawBar( blackBarWidth, PI );
  drawBar( blackBarWidth, 1.5f*PI );
  
  if( nextEffectTime == -1) {
    nextEffectTime = (int)random(3000,5000);
  } else if( modeMillis >= nextEffectTime) {;
    mode = randomEffectMode();
    nextEffectTime = -1;
  }
}

void modeInitExplosion() {
  modeInitNormal();

  explosionDirections = new ArrayList<PVector>();
  explosionRotationSpeeds = new FloatList();

  // calc explosion directions an  rotation speeds
  for ( int i = 0; i < ring.size (); ++i) {

    Triangle triangle = ring.get(i);

    explosionRotationSpeeds.append( random( -explosionRotationSpeedVariance, explosionRotationSpeedVariance));

    PVector explosionCenter = new PVector( ringCenterX + random( -explosionCenterVarianceX, explosionCenterVarianceX), 
    ringCenterY + random( -explosionCenterVarianceY, explosionCenterVarianceY), 
    0);

    PVector direction = PVector.sub( triangle.getCenter(), explosionCenter);

    float speed = explosionSpeed + random( -explosionSpeedVariance, explosionSpeedVariance);

    direction.setMag( speed);
    direction.z = 0;

    explosionDirections.add(direction);
  }

  drawRing();

  mode = ProgramMode.Explosion;
}

void modeExplosion() {

  for ( int i = 0; i < ring.size (); ++i) {
    Triangle triangle = ring.get(i);

    PVector direction = explosionDirections.get( i);
    PVector oldDirection = new PVector(direction.x, direction.y, 0);

    triangle.translate( direction);
    triangle.rotateXY( explosionRotationSpeeds.get(i));

    float speedReduction = explosionSpeedReduction + random( -explosionSpeedReductionVariance, explosionSpeedReductionVariance);

    direction.mult(  speedReduction);
    explosionRotationSpeeds.set(i, explosionRotationSpeeds.get(i) * explosionRotationSpeedReduction);

  }
  
  drawRing();
  
  if( modeMillis > 2000.0f) {
    buildRing(ringCenterX, ringCenterY, outsideRadius, insideRadius, radialParts, numSegments);
    mode = randomBlackMode();
  }
}

void modeInitCrippledExplosion() {
  modeInitNormal();

  explosionDirections = new ArrayList<PVector>();
  explosionRotationSpeeds = new FloatList();

  // calc explosion directions an  rotation speeds
  for ( int i = 0; i < ring.size (); ++i) {
    Triangle triangle = ring.get(i);

    explosionRotationSpeeds.append( random( -crippledExplosionRotationSpeedVariance, crippledExplosionRotationSpeedVariance));

    PVector explosionCenter = new PVector(
      ringCenterX + random( -explosionCenterVarianceX, explosionCenterVarianceX), 
      ringCenterY + random( -explosionCenterVarianceY, explosionCenterVarianceY), 
      0);

    PVector direction = PVector.sub( triangle.getCenter(), explosionCenter);

    float speed = crippledExplosionSpeed  + random( -crippledExplosionSpeedVariance, crippledExplosionSpeedVariance);

    direction.setMag( speed);
    direction.z = 0;

    explosionDirections.add(direction);
  }

  drawRing();

  mode = ProgramMode.CrippledExplosion;
}

void modeCrippledExplosion() {
  for ( int i = 0; i < ring.size (); ++i) {

    Triangle triangle = ring.get(i);

    PVector direction = explosionDirections.get( i);
    PVector oldDirection = new PVector(direction.x, direction.y, 0);

    triangle.translate( direction);
    triangle.rotateXY( explosionRotationSpeeds.get(i));

    float speedReduction = explosionSpeedReduction + random( -crippledExplosionSpeedReductionVariance, crippledExplosionSpeedReductionVariance);

    direction.mult(  speedReduction);
    explosionRotationSpeeds.set(i, explosionRotationSpeeds.get(i) * explosionRotationSpeedReduction);
  }

  drawRing();
  
  if( modeMillis > 2000.0f) {
    buildRing(ringCenterX, ringCenterY, outsideRadius, insideRadius, radialParts, numSegments);
    mode = randomBlackMode();
  }
}

void modeInitBuild() {
  buildRing(ringCenterX, ringCenterY, outsideRadius, insideRadius, radialParts, numSegments);
  
  fill(255);
  
  mode = ProgramMode.Build;  
}

void modeBuild() {
  int numSegments = min( (int)(modeMillis*buildSpeed), ring.size());

  beginShape(TRIANGLES);
  for ( int i=0; i < numSegments; ++i) {
    ring.get(i).draw();
  }

  endShape();
  
  if( numSegments >= ring.size()) {
    mode = randomBarCreationMode();
  }
}

void modeClockBars() {
  drawRing();

  float barWidth = min( log(modeMillis)*blackBarOpeningSpeed, blackBarWidth);
  
  float tempRotation = sq((modeMillis - blackBarRotationOffset)*(modeMillis*modeMillis)*blackBarRotationSpeed)-HALF_PI;
  
  fill(0);
  
  // bars east - sout - west - north
  drawBar( barWidth, 0 );
  drawBar( barWidth, min(max( 0, tempRotation), 1.5f*PI));
  drawBar( barWidth, min(max( 0, tempRotation), PI     ));
  drawBar( barWidth, min(max( 0, tempRotation), HALF_PI));
  
  if( tempRotation > TAU) {
    mode = ProgramMode.Normal; 
  }
}


void modeRotateFast() {
  float angle = (noise(millis()*rotateFastSpeed)-0.5f)*10;
  
  pushMatrix();
  translate( width/2, height/2);
  rotate( angle);
  translate( -width/2, -height/2);
  modeNormal();
  
  popMatrix();  
  
  if( abs(angle) < 0.015f ||
      abs(angle + HALF_PI ) < 0.015f ||
      abs(angle - HALF_PI) < 0.015f   ) {
    mode = ProgramMode.Normal;
  }
}


void modeRotateSlow() {
  float angle = (noise(millis()*rotateSlowSpeed)-0.5f)*10;
  
  pushMatrix();
  translate( width/2, height/2);
  rotate( angle);
  translate( -width/2, -height/2);
  modeNormal();
  
  popMatrix();  
  
  if( abs(angle) < 0.015f ||
      abs(angle + HALF_PI ) < 0.015f ||
      abs(angle - HALF_PI) < 0.015f   ) {
    mode = ProgramMode.Normal;
  }
} 

void modeFlickeringQuarters() {
  drawRing();

  float flickerProbability = 0.5f ;
  float time = millis()/40;
  
  drawBar( blackBarWidth, 0 );
  drawBar( blackBarWidth, HALF_PI );
  drawBar( blackBarWidth, PI );
  drawBar( blackBarWidth, 1.5f*PI );
  
  fill(0);
  
  if( noise(time) < flickerProbability) {
    rect( 0,0, width/2, height/2);
  }
  if( noise(time+10000) < flickerProbability) {
    rect( width/2,0, width/2, height/2);
  }  
  if( noise(time+20000) < flickerProbability) {
    rect( 0,height/2, width/2, height/2);
  }
  if( noise(time+30000) < flickerProbability) {
    rect( width/2, height/2, width/2, height/2);
  }
    
  if( modeMillis > 800 && random(100) > 80) {
    mode = ProgramMode.Normal;
  } 
  
  fill(255);
}

void modeInvertOpen() {
  float openSpeedWhite = 48.0f;
  float openSpeedBlack = 35.0f;
  int openOffsetMillis = 500;
  float whiteRadius = min( log(modeMillis) * openSpeedWhite, outsideRadius)*2;
  float blackRadius = min( log( max(0, (modeMillis-openOffsetMillis))) * openSpeedBlack, insideRadius)*2;
 
  fill(255);
  ellipse(ringCenterX, ringCenterY, whiteRadius, whiteRadius);
  fill(0);
  ellipse(ringCenterX, ringCenterY, blackRadius, blackRadius);
  
  if( blackRadius == insideRadius*2 &&
      modeMillis > 1200) {
    
    buildRing(ringCenterX, ringCenterY, outsideRadius, insideRadius, radialParts, numSegments);    

    mode = randomBarCreationMode();
  }
}


void modeFlickeringBars() {
  drawRing();

  float flickerProbability = 0.3f + log(modeMillis/300);
  float time = millis()/40.0f;
  
  fill(0);
  
  if( noise(time) < flickerProbability) {
    drawBar( blackBarWidth, 0 );
  }
  if( noise(time+10000) < flickerProbability) {
    drawBar( blackBarWidth, HALF_PI );
  }  
  if( noise(time+20000) < flickerProbability) {
    drawBar( blackBarWidth, PI );
  }
  if( noise(time+30000) < flickerProbability) {
    drawBar( blackBarWidth, 1.5f*PI );
  }
  
  if( flickerProbability >= 1 ) {
    mode = ProgramMode.Normal;
  } 
}

void modeInitFadeInBars() {
  shuffleArray(fadeBars);  
  mode = ProgramMode.FadeInBars; 
}

void modeFadeInBars() {
  background(0);
  
  drawRing();

  float barWidthEast  = min( log( max(0,modeMillis - fadeBarsOffsetTime * fadeBars[0] )) * blackBarOpeningSpeed, blackBarWidth);
  float barWidthSouth = min( log( max(0,modeMillis - fadeBarsOffsetTime * fadeBars[1] )) * blackBarOpeningSpeed, blackBarWidth);  
  float barWidthWest  = min( log( max(0,modeMillis - fadeBarsOffsetTime * fadeBars[2] )) * blackBarOpeningSpeed, blackBarWidth);
  float barWidthNorth = min( log( max(0,modeMillis - fadeBarsOffsetTime * fadeBars[3] )) * blackBarOpeningSpeed, blackBarWidth);
  
  fill(0);
  
  // bars east - sout - west - north
  drawBar( barWidthEast,  0 );
  drawBar( barWidthSouth, HALF_PI);
  drawBar( barWidthWest,  PI);
  drawBar( barWidthNorth, 1.5f*PI);
  
  if( barWidthEast  >= blackBarWidth &&
      barWidthSouth >= blackBarWidth &&
      barWidthWest  >= blackBarWidth &&
      barWidthNorth >= blackBarWidth ) {
        mode = ProgramMode.Normal;
    } 
}

void modeBlackOut() {
  fill(0);
  
  float diameter = modeMillis * 4; 
  
  ellipse( ringCenterX, ringCenterY, diameter, diameter);
  
  if( diameter >= sqrt( width*width + height*height)*4  ) {
    mode = randomCreationMode();
  } 
}

void modeInitQuarterSwitch() {
  shuffleArray( switchTo);
  
  mode = ProgramMode.QuarterSwitch;
}

void modeQuarterSwitch() {
  float maxTime = 650.0f;
  
  float[] initRotations = { 0, HALF_PI, PI, 1.5f*PI };
  PVector[] initPositions = { new PVector( ringCenterX + quarter.width*0.5f, ringCenterY + quarter.height*0.5f),    // s e
                              new PVector( ringCenterX - quarter.width*0.5f, ringCenterY + quarter.height*0.5f),    // s w
                              new PVector( ringCenterX - quarter.width*0.5f, ringCenterY - quarter.height*0.5f),    // n w
                              new PVector( ringCenterX + quarter.width*0.5f, ringCenterY - quarter.height*0.5f) };  // n e
  
  background(0);
  imageMode(CENTER);
  
  float halfBarWidth = blackBarWidth*0.5f;
  
  for( int quarterIdx = 0; quarterIdx < 4; ++quarterIdx) {
    // move every quarter to its place
    
    int targetQuarterIdx = switchTo[quarterIdx]; 

    float rotation = map( modeMillis, 0.0f, maxTime, initRotations[quarterIdx],   initRotations[targetQuarterIdx]);
    float newPosX  = map( modeMillis, 0.0f, maxTime, initPositions[quarterIdx].x, initPositions[targetQuarterIdx].x);
    float newPosY  = map( modeMillis, 0.0f, maxTime, initPositions[quarterIdx].y, initPositions[targetQuarterIdx].y);
    
    pushMatrix();
    
    translate( newPosX, newPosY);
    rotate(rotation);
    image(quarter,halfBarWidth, halfBarWidth);
    
    popMatrix(); 
  }
  
  if( modeMillis >= maxTime) {
    if( random(1) > 0.38f) {
      mode = ProgramMode.Normal;
    } else {
      mode = ProgramMode.InitQuarterSwitch;
    }
  }
}


void modeInitFadeInQuarters() {
  shuffleArray(fadeQuartersTimeOffset);  
  
  mode = ProgramMode.FadeInQuarters;
}


void modeFadeInQuarters() {
  background(0);
  
  modeNormal();
  
  fill(0, fadeQuartersOffsetTime * fadeQuartersTimeOffset[0] - modeMillis);  // n w
  rect( 0, 0, width*0.5f, height*0.5f);
  
  fill(0, fadeQuartersOffsetTime * fadeQuartersTimeOffset[1] - modeMillis);  // n e
  rect( width*0.5f, 0, width*0.5f, height*0.5f);
  
  fill(0, fadeQuartersOffsetTime * fadeQuartersTimeOffset[2] - modeMillis);  // s w
  rect( 0, height*0.5f, width*0.5f, height*0.5f);

  fill(0, fadeQuartersOffsetTime * fadeQuartersTimeOffset[3] - modeMillis);  // s e
  rect( width*0.5f, height*0.5f, width*0.5f, height*0.5f);
  
  if( modeMillis >= fadeQuartersOffsetTime*4) {
    mode = ProgramMode.Normal;
  }
}


void modeIntro() {  
  background(0,0,0);
    
  float imgHeight = vk1.height * (float)width/vk1.width;
  float imgPosY = (height - imgHeight) * 0.5f;
  
  float time = modeMillis;
  
  if( (time-200)*0.05f < TAU+HALF_PI) {
    tint(255, (sin((time-200)*0.05f)+1)*128);
  } else {
    tint(255);
  }
  image( vk1, 0,imgPosY, width, imgHeight);

  tint( max(0, time - 1000)*0.3f );
  image( vk2, 0,imgPosY, width, imgHeight);

  tint( max(0, time - 1400)*0.3f);
  image( vk3, 0,imgPosY, width, imgHeight);

  tint( max(0, time - 3000)*0.17f);
  image( vk4, 0,imgPosY, width, imgHeight);
  
  float fillLast = max(0, time - 6500)*0.13f;
  fill(0, fillLast);
  rect( 0, 0, width, height);
  
  if( fillLast >= 255) {
    mode = randomCreationMode();
  }
}

void modeClockQuarters() {
  float maxTime = 250.0f;
  
  float[] targetRotations = { 1.3f*HALF_PI, HALF_PI, PI, 1.5f*PI };
  PVector targetPosition = new PVector( ringCenterX + quarter.width*0.5f, ringCenterY + quarter.height*0.5f);    // s e
                              
  background(0);
  imageMode(CENTER);
  
  float halfBarWidth = blackBarWidth*0.5f;
  
  for( int quarterIdx = 0; quarterIdx < 4; ++quarterIdx) {
    // move every quarter to its place
    
    int targetQuarterIdx = switchTo[quarterIdx];
    
    float rotation = map( (modeMillis- (quarterIdx+1)*100)*3, 0.0f, maxTime, 0, targetRotations[quarterIdx]);
    
    pushMatrix();
    
    translate( width*0.5f, height*0.5f);
    rotate(rotation);
    translate( targetPosition.x-width*0.5f, targetPosition.y-height*0.5f);
    image(quarter,halfBarWidth, halfBarWidth);

    popMatrix(); 
  }
  
  if( modeMillis >= maxTime) {
      mode = ProgramMode.Normal;
  }  
}

// HELPERS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void shuffleArray(int[] arr)
{
  for (int i = 0; i < arr.length; ++i)
    {
      int randomIndex = (int)random(i+1);
      int tmp = arr[randomIndex];
      arr[randomIndex] = arr[i];
      arr[i] = tmp;
    }
}

ProgramMode randomCreationMode() {
  ProgramMode ret;
  
  int r = (int)random(6);
  
  if( r == 0) {
    ret = ProgramMode.InitNormal;
  } else if( r == 1) {
    ret = ProgramMode.InitBuild;
  } else if( r == 2) {
    ret = ProgramMode.InvertOpen;
  } else if( r == 3) {
    ret = ProgramMode.InitFadeInQuarters;
  } else if( r == 4) {
    modeInitNormal();
    ret = ProgramMode.FlickeringQuarters;
  } else {
    ret = ProgramMode.ClockQuarters;
  }
  
  return ret;
}

ProgramMode randomBarCreationMode() {
  ProgramMode ret;
  
  int r = (int)random(3);
  if( r == 0) {
    ret = ProgramMode.ClockBars;
  } else if( r == 1) {
    ret = ProgramMode.FlickeringBars;
  } else {
    ret = ProgramMode.InitFadeInBars;
  }
  
  return ret; 
}

ProgramMode randomEffectMode() {
  ProgramMode ret;
  
  int r = (int)random(6);
  
  if( r == 0) {
    ret = ProgramMode.InitExplosion;
  } else if( r == 1) {
    ret = ProgramMode.InitCrippledExplosion;
  } else if( r == 2) {
    ret = ProgramMode.RotateSlow;
  } else if( r == 3) {
    ret = ProgramMode.RotateFast;
  } else if( r == 4) {
    ret = ProgramMode.FlickeringQuarters;
  } else {
    ret = ProgramMode.InitQuarterSwitch;
  }
  
  return ret;
}

ProgramMode randomBlackMode() {
  ProgramMode ret = ProgramMode.BlackOut;
  return ret;
}


void createQuarter() {
  buildRing(ringCenterX, ringCenterY, outsideRadius, insideRadius, radialParts, numSegments);
  
  quarter = createGraphics((int)ceil(outsideRadius -blackBarWidth/2), (int)ceil(outsideRadius - blackBarWidth*0.5f),P2D);

  quarter.beginDraw();  
  quarter.background(0,0,0,0);
  quarter.noStroke();
  quarter.fill( 255);

  // draw all triangles;
  quarter.beginShape(TRIANGLES);
  quarter.translate( -(width + blackBarWidth)*0.5f,-(height + blackBarWidth)*0.5f);
  
  for ( int i=0; i < ring.size(); ++i) {
    ring.get(i).draw(quarter);
  }

  quarter.endShape();
  quarter.endDraw();  
}

void drawRing() {
  if( shaderMode != ShaderMode.Default) {
    shader(shader);
  }
  
  fill( 255);

  // draw all triangles;
  beginShape(TRIANGLES);

  for ( int i=0; i < ring.size(); ++i) {
    ring.get(i).draw();
  }

  endShape();
}


void drawBar( float barWidth, float angle) {  
  fill(0);

  pushMatrix();
  translate( width*0.5f, height*0.5f);
  rotate( angle);
  translate( 0, -barWidth*0.5f);
  rect( 0, 0, width*0.5f, barWidth);
  popMatrix();
}

void buildRing(float centerX, float centerY, float outsideRadius, float insideRadius, int radialParts, int numSegments) {

  ring = new ArrayList<Triangle>();

  float radialPartWidth = (outsideRadius - insideRadius) / radialParts;

  for (int i = 0; i < radialParts; ++i)
  {
    float angleStep = 180.0/numSegments;
    float angle = angleStep * i;

    float rOut = outsideRadius - radialPartWidth*i;
    float rIn  = rOut - radialPartWidth;


    for ( int j = 0; j < numSegments; ++j)
    {
      // outside triangle
      float px = centerX + cos(radians(angle)) * rOut;
      float py = centerY + sin(radians(angle)) * rOut;
      PVector v1 = new PVector(px, py);

      angle += angleStep;
      px = centerX + cos(radians(angle)) * rIn;
      py = centerY + sin(radians(angle)) * rIn;
      PVector v2 = new PVector(px, py);

      angle += angleStep;
      px = centerX + cos(radians(angle)) * rOut;
      py = centerY + sin(radians(angle)) * rOut;
      PVector v3 = new PVector(px, py);

      ring.add( new Triangle( v1, v2, v3));

      // inside triangle
      px = centerX + cos(radians(angle - angleStep)) * rIn;
      py = centerY + sin(radians(angle - angleStep)) * rIn;
      v1 = new PVector(px, py);

      px = centerX + cos(radians(angle)) * rOut;
      py = centerY + sin(radians(angle)) * rOut;
      v2 = new PVector(px, py);

      px = centerX + cos(radians(angle + angleStep)) * rIn;
      py = centerY + sin(radians(angle + angleStep)) * rIn;
      v3 = new PVector(px, py);

      ring.add( new Triangle( v1, v2, v3));
    }
  }
}

// STANDARD METHODS ////////////////////////////////////////////////////////////////////////////////////////////////////////////

String timestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}

void setWinTitleAndFps()
{
  if ( frameCount % 100 == 0)
    frame.setTitle( sketchName + " [" + (frameRate) + " fps]");
}
