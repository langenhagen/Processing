/* -------------------------------------------------------------------------------------------------
Contains all global/static changeable parameters for Visualz.

@author: barn
@version: 160905
------------------------------------------------------------------------------------------------- */

boolean __DEBUG__                   = false;                            // Debug macro switch.
VisualzProgram currentProgram       = new NULLProgram();                // The current program.
ArrayList<VisualzProgram> programs  = new ArrayList<VisualzProgram>();  // All programs.

float amplitude                     = 100.0;                            // Amplitude parameter.
float bpm                           = 120.0;                            // BPM.
float bpmFineshiftMillis            = 0.0;      // Shift of the bpm start time in milliseconds.
float bpmClockStartTime             = 0.0;      // Starting time of the BPM Clock in milliseconds.

InputSource inputSource = InputSource.MOVIE;    // The currently chosen input source.