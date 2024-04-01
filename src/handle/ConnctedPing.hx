package handle;

import utils.Logger;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.Int64;
class ConnctedPing {
    var PACKET_ID = 0x00;
    private var buf:Bytes;
    public function new(buf:Bytes) {
        this.buf = buf;
    }
    public function decode() {
        var timeinput:BytesInput = new BytesInput(buf);
        var byte:Int = timeinput.readByte();
        Logger.Debug("Conncted Ping ID: " + byte);
        timeinput.bigEndian = true;
        var time_high = timeinput.readInt32();
        var time_low = timeinput.readInt32();
        var timeorginal:Int64 = Int64.make(time_high,time_low);
        Logger.Debug("Conncted Ping Time: " + timeorginal);
    }

}