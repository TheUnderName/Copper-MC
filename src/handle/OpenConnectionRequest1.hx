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
    private var Portocol:Int;
    public function new(buffer:Bytes) {
        this.buffer = buffer;
        Packet = new PacketSender();
    }
    public function decode() {
        var bytesinput:BytesInput = new BytesInput(buffer);
        var bytes:Bytes = bytesinput.read(1024);
        
        Logger.Debug("Open Connection Request 1");
        var packet:Int = bytesinput.readByte();
        Logger.Debug("Packet Id: " + "0x" + packet);
        bytesinput.bigEndian = false;

        magicsubs = bytesinput.read(16);
        var RakNetMagic:String = magicsubs.toHex();

        Logger.Debug("RakNet Magic:" + RakNetMagic);

        bytesinput.bigEndian = false;

        Portocol = bytesinput.readByte();

        Logger.Debug("Protocol Version:" + Portocol);

        MTU = bytesinput.read(300);

        Logger.Debug(MTU.length + 46);

        encode();
    }
    public function encode() {
        var data:Bytes = Bytes.alloc(1024);
        var output:BytesOutput = new BytesOutput();
        output.bigEndian = false;
        output.writeByte(0x06); // write replay 0x06
        output.bigEndian = false;
        output.write(magicsubs); // write magic
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