/* -------------------------------------------------------------------------------------------------
The Readme of the Visualz Programs.

@author: barn
@version: 160822
------------------------------------------------------------------------------------------------- */

CONTENTS:
    0. Overview
    1. Usage
    2. TODOs
    3. History



0. Overview ****************************************************************************************

TODO

1. Usage *******************************************************************************************

TODO

2. TODOs *******************************************************************************************

os set windows 10 os
implement standard functionalities like invert etc
Kaleidoscope

3. History *****************************************************************************************

160821  - Created Readme
        - Refactored Statics
        - Investigated External Processing libraries
        - Retrieved ImageLoader Library
        - organized general File Structure

160822  - first smooth approach for managing key bindings on Mac and Windows
        - refactoring

16085   - Implemented proof-of-concept prototype class instantiator
        - refactoring

160826  - implemented working VisualsProgram class instantiator

160828  - created _studies folder in VisualzProgram in order to keep & maintain
          prototypes and do-ability studies
        - prototype for texturing on Polygons
        - discovered, that Videos need the Video Library
        - prototype for playing videos

160830  - added prototype that uses Videos as textures on polygons. It's nice.

160901  - added Imports.pde that shall contain all import statements bundled for Visualz
        - added prototype of the DREIECK program
        - added functionality to start programs and to retrieve key codes
        - first implementation of running DREIECK program

160902  - Visualz now hides the mouse cursor
        - added the NULLProgram for as an initial program in order avoid checks for Null
        - added mode changing capability
        - finalized DREIECK
        - added Webcam-capture prototype

160904  - dynamized Image and Movie loading and switching
        - changed some key codes

160905  - added simple webcam support
        - added global variable input that is automatically an image, a movie or the webcam-stream
        - enhanced key inputs for switching between images, movies and the main camera.
        - renamed HelperFunctions to Helpers
        - added an enumeration to Helpers that defines the current input type: image, movie or cam
        - added a file GlobalMediaVars that contain all image, movie and cam related variables


*** END OF FILE ***
