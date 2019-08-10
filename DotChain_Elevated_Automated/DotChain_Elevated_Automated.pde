String sketchName = "DotChain Elevated Automated";

final int BG_COLOR = 0;

PVector originePoint = new PVector(0, 0);
ArrayList<Tentacle> tabTentacles;
int[] tentaclesToRemove;//tentacles that die
ArrayList<Tentacle> tentaclesToAdd;//tentacles that were born
Boolean doAdd = true;

PImage img;

void setup()
{
  background(BG_COLOR);
  smooth();
  tabTentacles = new ArrayList<Tentacle>();

  img = loadImage("[CLN] flowerbeauty_clrshft200_round_psbrightup.png");
  //size(img.width, img.height, P2D);  // fails in Processing 3
  surface.setSize(img.width, img.height);

  noiseDetail(64,0.5);

  frameRate(1000);
}

void draw()
{
  tentaclesToRemove = new int[0];
  tentaclesToAdd = new ArrayList<Tentacle>();
  if (doAdd)
  {
    addTentacle();
  }

  int s1 = tabTentacles.size();
  for (int i = 0; i < s1; i ++)
  {
    tabTentacles.get(i).update(i);
  }

  int s2 = tentaclesToRemove.length;
  for (int i = s2-1; i > -1; i --)
  {
    tabTentacles.remove(tentaclesToRemove[i]);
  }

  int s3 = tentaclesToAdd.size();
  for (int i = 0; i < s3; i ++)
  {
    tabTentacles.add(tentaclesToAdd.get(i));
  }
  /*
  println("-----------------------");
   println("nb tentacles:" + tabTentacles.size());
   println("nb tentacles to remove:" + s2);
   println("nb tentacles to add:" + s3);
   */
}

void addTentacle()
{
  float x = noise(0, frameCount * 0.015)   * width * 2 - width  * 0.5;
  float y = noise(0,0, frameCount * 0.015) * height* 2 - height * 0.5;
  
  originePoint = new PVector(x, y);
  tabTentacles.add(new Tentacle(originePoint, 0, 0));
}

class Tentacle
{
  final int MAX_NEW_TENTACLES = 4 - 1;//max nb of new tentacles at a time
  final int NB_CIRCLES_MIN = 18;
  final int NB_CIRCLES_MAX = 75;
  final float DISTANCE_MIN = .25;//min percentage of the radius
  final float DISTANCE_MAX = .4;//max percentage of the radius
  final float DIST_VAR_MAX = .2;//max evolution of the distance
  final float EVOL_RANDOM = .5;//percentage of big/small circles center's moves
  final int TENTACLE_SIZE_MIN = 2;//min number of circles per tentacle
  final float DISPERTION_RATE = .065;//chance that a tentacle will split

  PVector center = new PVector(0, 0);
  float prevX;//previous x position of the circle
  float prevY;//previous y position of the circle
  float prevDist = random(DISTANCE_MIN, DISTANCE_MAX);//previous distance between two circles
  int nbCirclesTotal = (int)random(NB_CIRCLES_MIN, NB_CIRCLES_MAX);
  int nbCircles;//current count on the number of circles
  float m_angle = random(TWO_PI);//angle between two circles

  Tentacle(PVector p_center, int p_nbCircles, int p_nbCirclesTotal)
  {
    nbCirclesTotal = p_nbCirclesTotal > 0 ? p_nbCirclesTotal : nbCirclesTotal;
    nbCircles = p_nbCircles;
    center = p_center;
    prevX = center.x;
    prevY = center.y;
  }

  void update(int p_rank)
  {
    if (nbCircles < nbCirclesTotal)
    {
      if (random(1) < DISPERTION_RATE && (nbCirclesTotal-nbCircles) > NB_CIRCLES_MIN)
      {
        removeTentacleNb(p_rank);
        int nbNewTentacles = 1 + (int)random(MAX_NEW_TENTACLES);
        for (int i = 0; i < nbNewTentacles; i++)
        {
          tentaclesToAdd.add(new Tentacle(new PVector(prevX, prevY), nbCircles, (int)random(.9*nbCirclesTotal, nbCirclesTotal)));
        }
        return;
      }

      nbCircles++;
      if (prevDist < DISTANCE_MIN + (DISTANCE_MAX - DISTANCE_MIN)/2)
      {
        prevDist = prevDist + DIST_VAR_MAX * random(EVOL_RANDOM) * (random(1) < EVOL_RANDOM ? -1 : 1);
        }
      else
      {
        prevDist = prevDist + DIST_VAR_MAX * random(EVOL_RANDOM) * (random(1) < EVOL_RANDOM ? 1 : -1);
      }

      m_angle += (random(1) - .5) * PI / 4;
      float l_curDiameter = 6 * sqrt(.9 * (nbCirclesTotal - nbCircles));
      float l_curX = prevX + l_curDiameter * prevDist * cos(m_angle) / 3;
      float l_curY = prevY + l_curDiameter * prevDist * sin(m_angle) / 3;

      if (l_curX < 0 || l_curY < 0)
      {
        removeTentacleNb(p_rank);
        return;
      }

      img.loadPixels();
      img.updatePixels();

      int pixelIndex = max(0, min((int)l_curY * img.width + (int)l_curX, img.pixels.length-1));
      color c = img.pixels[pixelIndex];

      stroke(0,5);
      //color col = img.get((int)l_curX, (int)l_curY);
      fill(c, l_curDiameter);
      ellipse(l_curX, l_curY, l_curDiameter, l_curDiameter);

      prevX = l_curX;
      prevY = l_curY;
    }
    else
    {
      removeTentacleNb(p_rank);
    }
  }

  void removeTentacleNb(int p_rank)
  {
    int[] trmv = {
      p_rank
    };
    tentaclesToRemove = concat(tentaclesToRemove, trmv);
  }
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
}

void setWinTitleAndFps()
{
  if( frameCount % 100 == 0)
    frame.setTitle( sketchName + " [" + (frameRate) + " fps]");
}
