/* -------------------------------------------------------------------------------------------------
Contains functions to load and instantiate the media files
that should be stored in the 'data' folder.



TODO maybe instanciate asap to only keep valid files? also: faster file activation after loading.
     drawback: ram costs

@author: barn
@version: 160905
------------------------------------------------------------------------------------------------- */

/// Instantiates all media files.
void loadMedia() {

    getMediaFiles();

    images  = new PImage[imageFiles.size()];
    movies  = new Movie[movieFiles.size()];

    //cameras = new Capture[cameraConfigs.length];    // XXX dirty hack to enable at least
    camera = new Capture(Visualz.this);               //     the main cam for now
    cameras = new Capture[1];
    cameraConfigs = new String[] { "Main Camera" };

    for( int i=0; i<imageFiles.size(); ++i) {
        File f = imageFiles.get(i);

        PImage image = loadImage(f.getAbsolutePath());
        images[i] = image;
    }

    for( int i=0; i<movieFiles.size(); ++i) {
        File f = movieFiles.get(i);

        Movie movie = new Movie( Visualz.this, f.getAbsolutePath());
        movie.loop();
        movie.volume(0);
        movies[i] = movie;
    }

    if( useWebCam ) {
        for( int i=0; i<cameraConfigs.length; ++i) {
            cameras[i] = new Capture( Visualz.this, cameraConfigs[i]);
            cameras[i].start();
        }
    }

    image = images[0];
    movie = movies[0];
    camera = cameras[0];
}

// -------------------------------------------------------------------------------------------------

/// Special listFiles function that retrieves all files in 'data' recursively.
void getMediaFiles() {
    ArrayList<File> dataFiles = listFilesRecursive( dataPath(""));

    for( File f : dataFiles ) {

        String fname = f.getName();
        if( fname.endsWith(".jpg") || fname.endsWith(".png") || fname.endsWith(".bmp") ) {
            imageFiles.add(f);
        } else if ( fname.endsWith(".mov") || fname.endsWith(".mp4") ) {
            movieFiles.add(f);
        }
    }
}

// -------------------------------------------------------------------------------------------------

/// Function to get a list of all files in a directory and all subdirectories.
ArrayList<File> listFilesRecursive(String dir) {
    ArrayList<File> fileList = new ArrayList<File>();
    recurseDir(fileList, dir);
    return fileList;
}

// -------------------------------------------------------------------------------------------------

/// Recursive function to traverse subdirectories.
void recurseDir(ArrayList<File> fileList, String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {

        File[] subfiles = file.listFiles();
        for ( File subfile : subfiles ) {
            recurseDir(fileList, subfile.getAbsolutePath());
        }
    } else {
        fileList.add(file);
    }
}
