public class Triangle {  
  PVector v1, v2, v3;
  
  // CONSTRUCTOR
  
  public Triangle( PVector v1, PVector v2)
  {  
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = new PVector(0,0,0);
  }
  
  public Triangle( PVector v1, PVector v2, PVector v3)
  {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
  }
  
  // METHODS
  
  public void draw(){
    // draw vertices
    vertex(v1.x, v1.y, v1.z);
    vertex(v2.x, v2.y, v2.z);
    vertex(v3.x, v3.y, v3.z);
    
  }
  
  // discards the z coordinates because PGraphics obviously dont support P3D renderers. (version win 2.2.1)
  public void draw( PGraphics graphics){
    // draw vertices
    graphics.vertex(v1.x, v1.y);
    graphics.vertex(v2.x, v2.y);
    graphics.vertex(v3.x, v3.y);
    
  }
 
  public void rotateXY( float radians){
    // calculate sin / cos of the angle
    float s = sin(radians);
    float c = cos(radians);
      
    // translate vertices back to origin
    PVector center = this.getCenter();  
    
    v1.sub(center);
    v2.sub(center);
    v3.sub(center);

    // rotate points
    float np1x = v1.x * c - v1.y * s;
    float np1y = v1.x * s + v1.y * c;
    float np2x = v2.x * c - v2.y * s;
    float np2y = v2.x * s + v2.y * c;
    float np3x = v3.x * c - v3.y * s;
    float np3y = v3.x * s + v3.y * c;

    // assign new positions & translate points back
    v1.x = np1x;
    v1.y = np1y;
    v2.x = np2x;
    v2.y = np2y;
    v3.x = np3x;
    v3.y = np3y;

    v1.add(center);
    v2.add(center);
    v3.add(center);
    
  }
  
  public void translate( PVector translation) {    
    v1.add( translation);
    v2.add( translation);
    v3.add( translation);
  }
  
  public PVector getCenter() {
    PVector ret = PVector.add( PVector.add( v1, v2), v3);
    ret.mult( 0.333333f);
    
    return ret;
  } 
}
