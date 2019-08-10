/* -------------------------------------------------------------------------------------------------
Kaleidoscope Visualz Programs.

@author: barn
@version: 160911
------------------------------------------------------------------------------------------------- */

class ProgramKALEIDOSCOPE extends VisualzProgram {

    float rotation = 0;
    float speed = 0.0001;
    float zoom = 1.5;
    float offsetX = 0;
    float offsetY = 0;


    public ProgramKALEIDOSCOPE() {
        noStroke();
        textureWrap(REPEAT);
    }

    // getters -------------------------------------------------------------------------------------

    public String name() { return "Kaleidoscope"; }
    public char key() { return 'k'; }

    // effect key methods --------------------------------------------------------------------------

    public void onEffectKeyA() {
        rotation+=0.1;
    }

    public void onEffectKeyB() {
        speed+=0.00003;
    }

    public void onEffectKeyC() {
        rotation-=0.1;
    }

    public void onEffectKeyD() {
        speed-=0.00003;
    }

    // methods -------------------------------------------------------------------------------------

    public void draw() {
        // TODO
        // acc to mode, draw rectangles and move the texture
        simpleKaleidoscope();
    }

    // helpers -------------------------------------------------------------------------------------

    void simpleKaleidoscope() {

        // TODO make faster, maybe
        // incorp rotation w/ sin/cos
        float shift = ( millis() * speed);
        offsetX = ( offsetX + shift ) % input.width  * sin(rotation);
        offsetY = ( offsetY         ) % input.height * cos(rotation);


        float uvX = input.width/zoom  * sin(rotation);
        float uvY = input.height/zoom * cos(rotation);

        beginShape();
        texture(input);
        vertex( 0,         0,      0   + offsetX, 0   + offsetY );
        vertex( halfWidth, 0,      uvX + offsetX, 0   + offsetY );
        vertex( halfWidth, height, uvX + offsetX, uvY + offsetY );
        vertex( 0,         height, 0   + offsetX, uvY + offsetY );
        endShape();

        beginShape();

        vertex( halfWidth, 0,      uvX + offsetX, 0   + offsetY );
        vertex( width,     0,      0   + offsetX, 0   + offsetY );
        vertex( width,     height, 0   + offsetX, uvY + offsetY );
        vertex( halfWidth, height, uvX + offsetX, uvY + offsetY );
        endShape();
    }

    void windmillKaleidoscope() {

        // TODO make faster, maybe
        // incorp rotation w/ sin/cos
        float shift = ( millis() * speed);
        offsetX = ( offsetX + shift ) % input.width  * sin(rotation);
        offsetY = ( offsetY         ) % input.height * cos(rotation);

    }
}
