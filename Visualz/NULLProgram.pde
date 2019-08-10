/* -------------------------------------------------------------------------------------------------
Null Program is a dummy program effectively doing nothing. It is the initial program
and saves you from checking whether the current program is null by ensuring that
the currentProgram variable is not null.

It is a special Program that cannot be called by some key again. Its just an initial one that
shall make the rest of the code easier to read and write.

@author: barn
@version: 160902
------------------------------------------------------------------------------------------------- */

class NULLProgram extends VisualzProgram {

    public NULLProgram() {}

    // getters -------------------------------------------------------------------------------------

    public String name() { return "Visualz"; }
    public char key() { return '˜'; }

    // effect key methods --------------------------------------------------------------------------

    public void onEffectKeyA() {}
    public void onEffectKeyB() {}
    public void onEffectKeyC() {}
    public void onEffectKeyD() {}

    // methods -------------------------------------------------------------------------------------

    public void draw() {
        background( 96,96,255);
    }
}
