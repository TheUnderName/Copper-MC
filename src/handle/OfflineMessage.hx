package handle;
import haxe.Int64;
import sys.net.UdpSocket;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import sys.net.Address;
using utils.Logger;
using src.PacketSender;
class OfflineMessage {
    private var PACKET_ID = 0x01;
    private var buf:Bytes;
    private var Packet:PacketSender;
    private var RakNetMagic:String;
    private var magicsubs:Bytes;
    private var guidsubs:Bytes;
    private var timeorginal:Int64;
    public function new(buf:Bytes) {
        this.buf = buf;
        Packet = new PacketSender();
    }
    public function decode() {
        var timeinput:BytesInput = new BytesInput(buf);
        var packetid = timeinput.readByte();
        Logger.Debug("Packet Id: " + "0x" + packetid);
        timeinput.bigEndian = true;
        var time_high = timeinput.readInt32();
        var time_low = timeinput.readInt32();
        timeorginal = Int64.make(time_high,time_low);
        Logger.Debug("Time: " + timeorginal);
        // RakNet Magic
        magicsubs = timeinput.read(16);
        RakNetMagic = magicsubs.toHex();
        Logger.Debug("RakNet Magic: " + RakNetMagic);
        // Client guid
        guidsubs = timeinput.read(8);
        var ClientGuid:String = guidsubs.toHex();
        Logger.Debug("Client guid: " + ClientGuid);
        encode();
    }
    public function encode():Bool {
        var data:Bytes = Bytes.alloc(1024);
        var output:BytesOutput = new BytesOutput();
        var ServerMOTD = 'MCPE;CopperMC Server;589;1.20.0;2;20;13253860892328930865;Powered by CopperMC;Survival;1;19132;19133;';
        // // packet id
        output.bigEndian = false;
        output.writeByte(0x1c);
        // // client time
        output.bigEndian = true;
        var client_time:Int64 = timeorginal;
        output.writeInt32(client_time.high);
        output.writeInt32(client_time.low);
        // // // server guid
        output.bigEndian = true;
        var serverguid:Int64 = 254556555;
        output.writeInt32(serverguid.high);
        output.writeInt32(serverguid.low);
        // // // magic
        output.bigEndian = false;
        output.write(magicsubs);
        //server string
        output.bigEndian = true;
        var motd:Int = ServerMOTD.length;
        output.writeUInt16(motd);
        output.writeString(ServerMOTD,UTF8);
        data = output.getBytes();        
        return Packet.SendPacket(data,0,data.length);
    }
    
}