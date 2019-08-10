/* ------------------------------------------------------------------------------------------------
Contains all global media variables for Visualz.

@author: barn
@version: 160905
------------------------------------------------------------------------------------------------- */

ArrayList<File> imageFiles = new ArrayList<File>();  // Contains all image file handles from data.
ArrayList<File> movieFiles = new ArrayList<File>();  // Contains all movie file handles from data.
String[] cameraConfigs = Capture.list();             // The available cameras.

PImage[] images;                                     // Instanciated images.
Movie[] movies;                                      // Instanciated movies.
Capture[] cameras;                                   // Available Cameras.

int currentImageIndex  = 0;                          // The index of the current Image in the array.
int currentMovieIndex  = 0;                          // The index of the current Movie in the array.
int currentCameraIndex = 0;                          // The index of the current Cam in the array.

PImage image;                                        // Current image.
Movie movie;                                         // Current Movie;
Capture camera;                                      // CURRENT camera.

PImage input = createImage(16, 16, RGB);             // The current input, either img, vid or cam.
