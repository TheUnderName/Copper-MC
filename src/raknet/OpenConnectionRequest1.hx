package raknet;
import hl.UI16;
import haxe.Int64;
import haxe.io.Output;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
using utils.Logger;
using src.PacketSender;
using src.Server;
class OpenConnectRequest1 {
    private var ID_PACKET = 0x05;
    private var buffer:Bytes;
    private var magicsubs:Bytes;
    private var MTU:Bytes;
    private var Packet:PacketSender;
    private var Portocol:Int;
    public function new(buffer:Bytes) {
        this.buffer = Bytes.alloc(1024);
        this.buffer = buffer;
        Packet = new PacketSender();
    }
    public function decode() {
        var bytesinput:BytesInput = new BytesInput(buffer);
        
        Logger.Debug("Open Connection Request 1");
        var packet:Int = bytesinput.readByte();
        Logger.Debug("Packet Id: " + "0x" + packet);
        bytesinput.bigEndian = true;

        magicsubs = bytesinput.read(16);
        var RakNetMagic:String = magicsubs.toHex();

        Logger.Debug("RakNet Magic:" + RakNetMagic);

        bytesinput.bigEndian = true;

        Portocol = bytesinput.readByte();

        Logger.Debug("Protocol Version:" + Portocol);

        bytesinput.position = 17;

        Logger.Debug(Server.numBytes2);

        encode();
    }
    public function encode() {
        var data:Bytes = Bytes.alloc(1024);
        var output:BytesOutput = new BytesOutput();
        output.bigEndian = true;
        output.writeByte(0x06); // write replay 0x06
        output.write(magicsubs); // write magic
        var serverguid:Int64 = 254556555;
        output.writeInt32(serverguid.high);
        output.writeInt32(serverguid.low);
        output.writeByte(0x00);
        output.writeUInt16(Server.numBytes2);
        data = output.getBytes(); 
        Packet.SendPacket(data,0,data.length);
    }
}