package handle;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
using utils.Logger;
using src.PacketSender;

class OpenConnecetRequest2 {
    private var PACKET_ID = 0x07;
    private var MAGIC:Bytes;
    private var Buffer:Bytes;
    private var MTU:Bytes;
    private var ClientGUID:Int;
    private var BytesInput:BytesInput;

    public function new(Buffer:Bytes) {
        this.Buffer = Buffer;
    }

    public function decode() {
        BytesInput = new BytesInput(Buffer);
        PACKET_ID = BytesInput.readByte();
        Logger.Debug("---Open Connection Request 2 ----");
        Logger.Debug(PACKET_ID);
    
    }

}