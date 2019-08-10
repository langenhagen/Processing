/* -------------------------------------------------------------------------------------------------
The key handler for Visualz.

@author: barn
@version: 1600905
------------------------------------------------------------------------------------------------- */

/// Entry point for all keyPressed() signals.
public void keyPressed() {
    // beware of the difference between key and keyCode

    logDebug( "(int)key: " + (int)key + "\tkey: " + key + "\tkeyCode: " + keyCode);

    if( keyCode == keyCodeScreenshot ) {
        String fname = "result_" + timestamp() + ".png";
        l( "saving " + fname);
        save(fname);
    }
    else if( keyCode == keyCodeSwitchDebugMode ) {
        __DEBUG__ = !__DEBUG__;
        logInfo( "Debug Mode: " + __DEBUG__ );
    }
    else if( keyCode == keyCodePrintTimestamp ) {
        logInfo( " => " +sketchName + " " + millis() + " ms [" + (frameRate) + " fps]");
    }
    else if( keyCode == keyCodeParamA ) {
        currentProgram.onEffectKeyA();
    }
    else if( keyCode == keyCodeParamB ) {
        currentProgram.onEffectKeyB();
    }
    else if( keyCode == keyCodeParamC ) {
        currentProgram.onEffectKeyC();
    }
    else if( keyCode == keyCodeParamD ) {
        currentProgram.onEffectKeyD();
    }
    else if( keyCode == keyCodeMode1 ) {
        currentProgram.mode = 1;
    }
    else if( keyCode == keyCodeMode2 ) {
        currentProgram.mode = 2;
    }
    else if( keyCode == keyCodeMode3 ) {
        currentProgram.mode = 3;
    }
    else if( keyCode == keyCodeMode4 ) {
        currentProgram.mode = 4;
    }
    else if( keyCode == keyCodeMode5 ) {
        currentProgram.mode = 5;
    }
    else if( keyCode == keyCodeMode6 ) {
        currentProgram.mode = 6;
    }
    else if( keyCode == keyCodeMode7 ) {
        currentProgram.mode = 7;
    }
    else if( keyCode == keyCodeMode8 ) {
        currentProgram.mode = 8;
    }
    else if( keyCode == keyCodeMode9 ) {
        currentProgram.mode = 9;
    }
    else if( keyCode == keyCodeMode10 ) {
        currentProgram.mode = 10;
    }
    else if( keyCode == keyCodePreviousImage ) {
        setCurrentImage( -1);
    }
    else if( keyCode == keyCodeNextImage ) {
        setCurrentImage( +1);
    }
    else if( keyCode == keyCodePreviousMovie ) {
        setCurrentMovie( -1);
    }
    else if( keyCode == keyCodeNextMovie ) {
        setCurrentMovie( +1);
    }
    else if( keyCode == keyCodePreviousCamera ) {
        setCurrentCamera( -1);
    }
    else if( keyCode == keyCodeNextCamera ) {
        setCurrentCamera( +1);
    }
    else if( keyCode == keyCodeSwitchInput) {
        switchInputSource();
    }

    for( VisualzProgram prog : programs) {
      if( key == prog.key() ) {
        currentProgram = prog;
        l( "Switched to Program '" + prog.name() + "'");
      }
    }
}
