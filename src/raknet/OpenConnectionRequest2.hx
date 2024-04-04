package raknet;

import haxe.Int64;
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
    private var Packet:PacketSender;
    private var Buffer:Bytes;
    private var MTU:Int;
    private var ClientGUID:Int64;
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
        Packet = new PacketSender();
    }
    public function decode() {
        BytesInputs = new BytesInput(Buffer);
        BytesInputs.bigEndian = true;
        PACKET_ID = BytesInputs.readByte();
        Logger.Debug("---Open Connection Request 2 ----");
        Logger.Debug(PACKET_ID);
        MAGIC = BytesInputs.read(16);
        Logger.Debug(MAGIC.toHex());
        AdrVersion = BytesInputs.readByte();
        if (AdrVersion == 4) {
            Logger.Debug("IP v" + AdrVersion);
            var IpADDR = BytesInputs.ReadAddr();
            var AddreasPort:Int = BytesInputs.ReadPort();
            Logger.Debug(IpADDR + ": " + AddreasPort);
        } else {
            Logger.Debug("ipv6 not supported");
            return;
        }
        MTU = BytesInputs.readUInt16();
        Logger.Debug("MTU -> : " + MTU);
        ClientGUID = BytesInputs.readLong();
        Logger.Debug("Client guid Non Hex :" + ClientGUID);

        encode();
    }
    public function encode() {
        var data:Bytes = Bytes.alloc(MTU);
        BytesOutputs = new BytesOutput();
        BytesOutputs.bigEndian = true;
        BytesOutputs.writeByte(0x08);
        BytesOutputs.write(MAGIC);
        BytesOutputs.writeLong(254556555);
        BytesOutputs.writeAddr();
        BytesOutputs.writeUInt16(MTU);
        BytesOutputs.writeByte(0x00);
        data = BytesOutputs.getBytes(); 
        Packet.SendPacket(data,0,data.length);
    }
}