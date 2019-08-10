/* -------------------------------------------------------------------------------------------------
Contains an enumeration to distinguis between Mac, Linux or Windows.

@author: barn
@version: 160902
------------------------------------------------------------------------------------------------- */

/// Defines different operating systems that can be used.
public enum OS {
    LINUX,
    MAC,
    WIN
}

// -------------------------------------------------------------------------------------------------

/// Retrieves the current operating system.
OS getOperatingSystem() {
    String operatingSystem = System.getProperty("os.name");

    if( operatingSystem.equals( "Mac OS X" )) {
        return OS.MAC;
    }
    else if( operatingSystem.equals( "Windows 7" )) {
        return OS.WIN;
    }
    else {
        logWarn( "Operating System '" + operatingSystem + "' not supported. Falling back to WIN" );
        return OS.WIN;
    }
}
