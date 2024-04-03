package utils;

import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.Output;
import haxe.Int64;
import haxe.io.Input;

class Binary {
    public static function ReadAddreas(inp:BytesInput):String {
        var ipBytes:Array<Int> = [];
        for (i in 0...4) {
            ipBytes.push(inp.readByte());
        }
        // Construct an IPv4 out of the 4 bytes we just read.
        var ip1:Int = (-ipBytes[0] - 1) & 0xFF;
        var ip2:Int = (-ipBytes[1] - 1) & 0xFF;
        var ip3:Int = (-ipBytes[2] - 1) & 0xFF;
        var ip4:Int = (-ipBytes[3] - 1) & 0xFF;
        var ipAddr:String = ip1 + "." + ip2 + "." + ip3 + "." + ip4;

        return ipAddr;
    }
    public static function ReadPort(inp:BytesInput):Int {
        inp.bigEndian = true;
        return inp.readUInt16();
    }
}