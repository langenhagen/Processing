/* -------------------------------------------------------------------------------------------------
 Generic helper functions for Visualz.

 @author: barn
 @version: 160905
 ------------------------------------------------------------------------------------------------ */

/// Retrieves a neat timestamp.
String timestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-" +
    nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}

// -------------------------------------------------------------------------------------------------

/// Sets window title w/ Sketch name and frames per second.
void setWinTitleAndFps() {
  if ( frameCount % 100 == 0)
    surface.setTitle( sketchName + " [" + (frameRate) + " fps]");
}

// -------------------------------------------------------------------------------------------------

/// Sets the current Image about the given offset in a circular buffer fashion.
void setCurrentImage( int offset) {
    currentImageIndex += offset;
    currentImageIndex %= images.length;
    if ( currentImageIndex<0)
        currentImageIndex = images.length+currentImageIndex;

    image = images[currentImageIndex];

    inputSource = InputSource.IMAGE;

    String info = fixedSizeString( imageFiles.get( currentImageIndex).getName(),
                                   "[" + (currentImageIndex+1) + "/" + images.length + "]",
                                   42);
    l( "Image:     " + info);
}

// -------------------------------------------------------------------------------------------------

/// Sets the current Movie about the given offset in a circular buffer fashion.
void setCurrentMovie( int offset) {
    currentMovieIndex += offset;
    currentMovieIndex %= movies.length;
    if ( currentMovieIndex<0)
        currentMovieIndex = movies.length+currentMovieIndex;

    movie = movies[currentMovieIndex];

    inputSource = InputSource.MOVIE;

    String info = fixedSizeString( movieFiles.get( currentMovieIndex).getName(),
                                   "[" + (currentMovieIndex+1) + "/" + movies.length + "]",
                                   42);
    l( "Movie:     " + info);
}

// -------------------------------------------------------------------------------------------------

/// Sets the current Camera about the given offset in a circular buffer fashion.
void setCurrentCamera( int offset) {
    currentCameraIndex += offset;
    currentCameraIndex %= cameras.length;
    if ( currentCameraIndex<0)
        currentCameraIndex = cameras.length+currentCameraIndex;

    camera = cameras[currentCameraIndex];

    inputSource = InputSource.CAMERA;

    String info = fixedSizeString( cameraConfigs[currentCameraIndex],
                                   "[" + (currentCameraIndex+1) + "/" + cameras.length + "]",
                                   42);
    l( "Camera:     " + info);
}

// -------------------------------------------------------------------------------------------------

// Returns a string concatenated from the beginning, some spaces, and the end
// with begin and the spaces combined will have the given length.
String fixedSizeString( String begin, String end, int length) {
    StringBuffer buffer = new StringBuffer(length);
    buffer.append(begin);
    for (int i = buffer.length(); i < length; ++i) {
        buffer.append(' ');
    }
    buffer.append(end);

    return buffer.toString();
}

// -------------------------------------------------------------------------------------------------

/// Defines the input source as either Movie or Camera.
enum InputSource {
    IMAGE,
    MOVIE,
    CAMERA
}

// --------------------------------------------------------------------------------------------------

/// switches the global input source variable in a circular fashion.
void switchInputSource() {
    if( inputSource == InputSource.IMAGE ) {
        inputSource = InputSource.MOVIE;
    }
    else if( inputSource == InputSource.MOVIE ) {
        inputSource = useWebCam ? InputSource.CAMERA : InputSource.IMAGE;
    }
    else {
        inputSource = InputSource.IMAGE;
    }

    l("Switched to " + inputSource);
}

// -------------------------------------------------------------------------------------------------

/// Updated the global input variable with the newest data.
void updateInputVariable() {

    if( inputSource == InputSource.IMAGE) {

        input = image;
    }
    else if( inputSource == InputSource.MOVIE) {

        if (movie.available()) {
            movie.read();
            input = movie;
        }
    }
    else {
        if ( useWebCam && camera.available()) {
            camera.read();
            input = camera;
        }
    }
}