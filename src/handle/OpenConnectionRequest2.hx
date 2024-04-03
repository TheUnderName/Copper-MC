package handle;

import haxe.Exception;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
using utils.Logger;
using src.PacketSender;
using utils.Binary;
class OpenConnecetRequest2 {
    private var PACKET_ID = 0x07;
    private var MAGIC:Bytes;
    private var Buffer:Bytes;
    private var MTU:Bytes;
    private var ClientGUID:Int;
    private var BytesInputs:BytesInput;
    private var BytesOutputs:BytesOutput;
    private var AdrVersion:Int;
    private var AdrByte:Bytes;
    private var IpADDR:String;
    private var AddreasPort:Int;

    public var input(get, never):BytesInput;
    public var output(get, never):BytesOutput;
    function get_input():BytesInput {return this.BytesInputs;}
    function get_output():BytesOutput {return this.BytesOutputs;}

    public function new(Buffer:Bytes) {
        this.Buffer = Buffer;
    }

    public function decode() {
        BytesInputs = new BytesInput(Buffer);
        PACKET_ID = BytesInputs.readByte();
        Logger.Debug("---Open Connection Request 2 ----");
        Logger.Debug(PACKET_ID);
        MAGIC = BytesInputs.read(16);
        Logger.Debug(MAGIC.toHex());
        AdrVersion = BytesInputs.readByte();
        if (AdrVersion == 4) {
            Logger.Debug(AdrVersion);
            var IpADDR = BytesInputs.ReadAddreas();
            BytesInputs.bigEndian = true;
            var AddreasPort:Int = BytesInputs.readUInt16();
        } else {
            Logger.Debug("ipv6 not supported");
            return;
        }

        
    
    }

}