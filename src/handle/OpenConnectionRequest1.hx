package handle;
import haxe.Int64;
import haxe.io.Output;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
using utils.Logger;
using src.PacketSender;
class OpenConnectRequest1 {
    private var ID_PACKET = 0x05;
    private var buffer:Bytes;
    private var magicsubs:Bytes;
    private var MTU:Bytes;
    private var Packet:PacketSender;
    public function new(buffer:Bytes) {
        this.buffer = buffer;
        Packet = new PacketSender();
    }
    public function decode() {
        var bytesinput:BytesInput = new BytesInput(buffer);
        var bytes:Bytes = bytesinput.read(1024);
        
        Logger.Debug("Open Connection Request 1");
        var packet:Bytes = bytes.sub(0,1);
        Logger.Debug("Packet Id: " + "0x" + packet.toHex());

        magicsubs = bytes.sub(1,16);
        var RakNetMagic:String = magicsubs.toHex();

        Logger.Debug("RakNet Magic:" + RakNetMagic);

        var protocol:Bytes = bytes.sub(17,1);
        var timeinput:BytesInput = new BytesInput(protocol);
        timeinput.bigEndian = false;
        var protocolstr:Int = timeinput.readByte();

        Logger.Debug("Protocol Version:" + protocolstr);

        var timeinput:BytesInput = new BytesInput(buffer);

        MTU = bytes.sub(18,300);

        Logger.Debug(MTU.length + 46);

        encode();
    }
    public function encode() {
        var data:Bytes = Bytes.alloc(1024);
        var output:BytesOutput = new BytesOutput();
        output.bigEndian = false;
        output.writeByte(0x06);
        output.bigEndian = false;
        output.writeBytes(magicsubs,0,magicsubs.length);
        output.bigEndian = true;
        var serverguid:Int64 = 254556555;
        output.writeInt32(serverguid.high);
        output.writeInt32(serverguid.low);
        output.bigEndian = false;
        output.writeByte(0x00);
        output.bigEndian = false;
        output.writeUInt16(MTU.length + 46);
        data = output.getBytes(); 
        Packet.SendPacket(data,0,data.length);
    }
}