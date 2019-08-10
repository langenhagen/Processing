/* -------------------------------------------------------------------------------------------------
Contains all key bindings for Visualz.

@author: barn
@version: 160905
------------------------------------------------------------------------------------------------- */

// note: keyCodes could be dependent on the renderer.

//......................................         MAC     WIN
final int keyCodeScreenshot             = bind(  108,    108  );      // F12
final int keyCodeSwitchDebugMode        = bind(  106,    106  );      // F10
final int keyCodePrintTimestamp         = bind(  107,    107  );      // F11
final int keyCodeColorShift             = bind(    9,      9  );      // TAB
final int keyCodeResetAllEffects        = bind(   10,     10  );      // ENTER
final int keyCodeParamA                 = bind(   38,     38  );      // Arrow Up
final int keyCodeParamB                 = bind(   39,     39  );      // Arrow Right
final int keyCodeParamC                 = bind(   40,     40  );      // Arrow Down
final int keyCodeParamD                 = bind(   37,     37  );      // Arrow Left
final int keyCodeRestartBPMClock        = bind(    8,      8  );      // Delete
final int keyCodeBPMUp                  = bind(   61,     61  );      // + Button
final int keyCodeBPMDown                = bind(   45,     45  );      // - Button
final int keyCodeFast                   = bind(   16,     16  );      // Shift
final int keyCodeSlow                   = bind(   17,     17  );      // Control
final int keyCodeAl                     = bind(   18,     18  );      // Alt
final int keyCodeMode1                  = bind(   49,     49  );      // 1
final int keyCodeMode2                  = bind(   50,     50  );      // 2
final int keyCodeMode3                  = bind(   51,     51  );      // 3
final int keyCodeMode4                  = bind(   52,     52  );      // 4
final int keyCodeMode5                  = bind(   53,     53  );      // 5
final int keyCodeMode6                  = bind(   54,     54  );      // 6
final int keyCodeMode7                  = bind(   55,     55  );      // 7
final int keyCodeMode8                  = bind(   56,     56  );      // 8
final int keyCodeMode9                  = bind(   57,     57  );      // 9
final int keyCodeMode10                 = bind(   48,     48  );      // 0
final int keyCodePreviousImage          = bind(   97,     97  );      // F1
final int keyCodeNextImage              = bind(   98,     98  );      // F2
final int keyCodePreviousMovie          = bind(   99,     99  );      // F3
final int keyCodeNextMovie              = bind(  100,    100  );      // F4
final int keyCodePreviousCamera         = bind(  101,    101  );      // F5
final int keyCodeNextCamera             = bind(  102,    102  );      // F6
final int keyCodeSwitchInput            = bind(  103,    103  );      // F7

// ------------------------------------------------------------------------------------------------

/// Returns the given key code according to the set Operating system.
int bind( int macKey, int winKey ) {
    if( os == OS.MAC ) {
        return macKey;
    } else if( os == OS.WIN ) {
        return winKey;
    }

    logError( "KeyBindings.bind(): Value of variable 'os' can not be evaluated.");
    return -1;
}

// Shift : big
// Ctrl : invert

/*
Mouse Y Scroll   :  Amplitude Multiplier
Mouse X Scroll   :  NRU Fineshift in t Dimension
*/
