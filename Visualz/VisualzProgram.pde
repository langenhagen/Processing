/* -------------------------------------------------------------------------------------------------
Abstract superclass for each Visualz Programs. Subclass this class in order to add new programs
to the Visualz app.

In order to auto-instantiate the child classes, they must implement a constructor.

@author: barn
@version: 1609011
------------------------------------------------------------------------------------------------- */

abstract class VisualzProgram {

    // getters -------------------------------------------------------------------------------------

    abstract public String name();  // Name of the program.
    abstract public char key();     // The key that must be pressed to activate the program.

    public int mode             = 1;                // current active mode of the program.
    public FloatList p          = new FloatList();  // Tweakable program parameters.

    // methods -------------------------------------------------------------------------------------

    public boolean start() { return true; }         // Starts the program with the given settings.
    public void stop() {}                           // Stops the program.
    public abstract void draw();                    // Draws one frame.

    public abstract void onEffectKeyA();                 // runs when effect key A is pressed.
    public abstract void onEffectKeyB();                 // runs when effect key B is pressed.
    public abstract void onEffectKeyC();                 // runs when effect key C is pressed.
    public abstract void onEffectKeyD();                 // runs when effect key D is pressed.
}