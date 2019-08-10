/* -------------------------------------------------------------------------------------------------
Was geht. The Main file of the Visualz visualizing software. It's nice.

TODO
simple polygon video shifter

@author: barn
@version: 160826
------------------------------------------------------------------------------------------------- */

void settings() {

    l( "Starting...");
    size(width, height, P3D);
}

// -------------------------------------------------------------------------------------------------

void setup() {
    logDebug( "*** Debug mode is active ***");
    logDebug( "Running on " + os );

    loadMedia();
    registerPrograms( programs);

    noCursor();
    background(96, 96, 255); // jawas
}

// -------------------------------------------------------------------------------------------------

void draw() {
    setWinTitleAndFps();

    updateInputVariable();

    currentProgram.draw();
}
