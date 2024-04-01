package utils;

class Logger {
    public static var DEBUG_STATS:Bool;
    public static var LOG_STATS:Bool;

    public static function Debug(s:Any):Bool {
        if(DEBUG_STATS) {
            trace(s);
            return true;
        }
        return false;
    }
    public static function Log(s:Any):Bool {
        if(LOG_STATS) {
            trace(s);
            return true;
        }
        return false;
    }
}