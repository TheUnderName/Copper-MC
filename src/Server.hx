package src;
import handle.ConnctedPing;
import haxe.io.BytesInput;
import sys.net.Address;
import sys.net.Host;
import sys.net.UdpSocket;
import haxe.io.Bytes;
import haxe.Exception;
import handle.OfflineMessage;
import handle.OpenConnectionRequest1;

using src.PacketSender;
using utils.Logger;
class Server {
    public static var UdpServer:UdpSocket;
    public static var ClientSender:Address;
    
    private var HostName:String;
    private var Ip:String;
    private var Port:Int;
    private var IpHost:Host;

    public function new(hostName:String, ip:String, port:Int) {
        Logger.Log("\x1b[31mSocket installing..\x1b[0m");
        
        this.HostName = hostName;
        this.Ip = ip;
        this.Port = port;
        this.IpHost = new Host(Ip.toString());
        UdpServer = new UdpSocket();
    }
    public function Start():Void {
        Logger.Log("Socket installed");
        UdpServer.bind(IpHost,Port);
        HandlePackets();
    }
    private function HandlePackets():Void {
        var buffersize:Int = 1024;
        while (true) {

            Sys.sleep(0.05);

            ClientSender = new Address();
            var buffer:Bytes = Bytes.alloc(buffersize);

            try {
                var numBytes:Int = UdpServer.readFrom(buffer, 0, buffersize, ClientSender); // read

            } catch(e:Any) {
                trace(e);
            }
            var bytesinput:BytesInput = new BytesInput(buffer);
            var bytes:Bytes = bytesinput.read(buffersize);
          
            var packet:Bytes = bytes.sub(0,1);
            var packetsend:String = packet.toHex();

            PacketSender.ClientAddreas = ClientSender;

            switch(packetsend) {
                case "01": {
                    var offlinepacket = new OfflineMessage(buffer);    
                    offlinepacket.decode();
                }
                case "05": {
                    var openconnect = new OpenConnectRequest1(buffer);
                    openconnect.decode();
                }
                case "00": {
                    var connctedping = new ConnctedPing(buffer);
                    connctedping.decode();
                }
            }      
        }
    }
}