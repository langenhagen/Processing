/* -------------------------------------------------------------------------------------------------
The simplest emphasized Logger you can imagine Visualz.

@author: barn
@version: 1600904
------------------------------------------------------------------------------------------------- */

/// The simplest logger you can imagine.
void l( Object s ) { logInfo(s); }
void logInfo( Object s )  { println("[Info]    " + s); }
void logWarn( Object s )  { println("[Warning] " + s); }
void logError( Object s ) { println("[Error]   " + s); }
void logDebug( Object s ) { if(__DEBUG__) { println("[DEBUG]   " + s); } }