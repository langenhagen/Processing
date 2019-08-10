  
import processing.video.*;
Movie myMovie;

void setup() {
  size(600 , 600);
  myMovie = new Movie(this, "sample_mpeg4.mp4");
  myMovie.loop();
}

void draw() {
  tint(255, 20);
  image(myMovie, mouseX, mouseY);
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}