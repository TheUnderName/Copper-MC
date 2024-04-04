package utils;

import sys.net.Host;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.Output;
import haxe.Int64;
import haxe.io.Input;
using src.PacketSender;

class Binary {
    public static function ReadAddr(inp:BytesInput):String {
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
    public static function writeLong(out:Output, value:Int64) {
        out.writeInt32(value.high);
        out.writeInt32(value.low);
    }
    public static function readLong(inp:Input):Int64 {
        var high = inp.readInt32();
        var low = inp.readInt32();
        return Int64.make(high, low);
    }
    public static function writeAddr(out:Output):Void {
        var addr = PacketSender.ClientAddreas;
        trace(addr.host);
        var ips:Host = addr.getHost();
        var ipp:String = ips.toString();
        trace(ips);
        var port:Int = addr.port;
        out.writeByte(4);
        var hostnameParts:Array<String> = ipp.split('.');
        for (part in hostnameParts) {
            out.writeByte(~Std.parseInt(part) & 0xFF);
        }
        trace("port is " + port);
        out.writeUInt16(port);
    }
    
}