/* -------------------------------------------------------------------------------------------------
DREIECK Visualz Programs.

note: you might also use movie.speed(4.0); or movie.frameRate(2); some day

@author: barn
@version: 160826
------------------------------------------------------------------------------------------------- */

class ProgramDREIECK extends VisualzProgram {

    float radius = 200.0;
    float rotation = 0;
    int xOffset=100;
    int yOffset=100;

    public ProgramDREIECK() {
        noStroke();
        textureWrap(REPEAT);
    }

    // getters -------------------------------------------------------------------------------------

    public String name() { return "DREIECK"; }
    public char key() { return 'd'; }

    // effect key methods --------------------------------------------------------------------------

    public void onEffectKeyA() {
        radius += 50;
    }

    public void onEffectKeyB() {
        xOffset = int(random(-input.width/3,  input.width/3 ));
        yOffset = int(random(-input.height/3, input.height/3));
    }

    public void onEffectKeyC() {
        radius -= 50;
    }

    public void onEffectKeyD() {
        rotation=random(360);
    }

    // methods -------------------------------------------------------------------------------------

    public void draw() {
        int nPoints = mode+2;

        image(input, 0, 0, width, height);

        beginShape();

        texture(input);

        for( float i=0; i<nPoints; ++i) {

            float thePoint = radians( i/nPoints * 360 + rotation);
            float x = halfWidth  + cos( thePoint) * radius;
            float y = halfHeight + sin( thePoint) * radius;

            vertex( x, y, x+xOffset, y+yOffset );
        }

        endShape();
    }
}
