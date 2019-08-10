/* -------------------------------------------------------------------------------------------------
Instantiation function for VisualzProgram child classes.
Finds all inner classes of the Processing sketch that extend the abstract class VisualzProgram
and instantiates them into the given container.

@author: barn
@version: 160826
------------------------------------------------------------------------------------------------- */

/// Registers and instantiates all VisualzPograms in the given container.
void registerPrograms( ArrayList<VisualzProgram> programs) {

    for( Class clazz : getClass().getDeclaredClasses() ) {
        if( isSubclass( VisualzProgram.class, clazz ) &&
            !clazz.equals( NULLProgram.class )) {
            try {
                java.lang.reflect.Constructor ctor = clazz.getConstructor( getClass());
                VisualzProgram prog = (VisualzProgram)ctor.newInstance( this);
                programs.add( prog);

                String progName = fixedSizeString( prog.name(), "", 20 );
                String progClassName = fixedSizeString( "  (" + prog.getClass().getSimpleName() + ")", "", 30 );

                logInfo( progName + progClassName + "  Key code: '" + prog.key() + "'" );
            }
            catch( Exception e) {
                logError( e.toString() +
                          "\nDid you implement a constructor on this class?");
            }
        }
    }
    logInfo('.');
}

// -------------------------------------------------------------------------------------------------

/// Checks if the given child class is subclass of the given parent class.
boolean isSubclass( Class parent, Class child) {
    return parent.isAssignableFrom( child) && child != parent;
}
