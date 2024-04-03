package src;
import handle.OpenConnectionRequest2;
import handle.ConnctedPing;
import haxe.io.BytesInput;
import sys.net.Address;
import sys.net.Host;
import sys.net.UdpSocket;
import haxe.io.Bytes;
import haxe.Exception;
import handle.OfflineMessage;
import handle.OpenConnectionRequest1;
import sys.thread.Thread;
using src.PacketSender;
using utils.Logger;
class Server {
    public static var UdpServer:UdpSocket;
    public static var ClientSender:Address;
    public static var numBytes:Int;
    private var HostName:String;
    private var Ip:String;
    private var Port:Int;
    private var IpHost:Host;
    private var thread:Thread;
    public function new(hostName:String, ip:String, port:Int) {
        Logger.Log("\x1b[31mSocket installing..\x1b[0m");
        this.HostName = hostName;
        this.Ip = ip;
        this.Port = port;
        this.IpHost = new Host(Ip.toString());
        UdpServer = new UdpSocket();
        UdpServer.bind(IpHost,Port);  
        Logger.Log("Socket installed");  
    }
    public function Start():Void {  
        while(true) {
            HandlePackets();
            Sys.sleep(1);
        }
    }
    private function HandlePackets():Void {
        var buffersize:Int = 1500;
        ClientSender = new Address();
        var buffer:Bytes = Bytes.alloc(buffersize);
        try {
            numBytes = UdpServer.readFrom(buffer, 0, buffersize, ClientSender); // read
        } catch(e:Any) {
            trace(e);
        }
        var bytesinput:BytesInput = new BytesInput(buffer);
        var packetid:Int = bytesinput.readByte();
        PacketSender.ClientAddreas = ClientSender;
        switch(packetid) {
            case 0x01: {
                var offlinepacket = new OfflineMessage(buffer);    
                offlinepacket.decode();
            }
            case 0x05: {
                var openconnect = new OpenConnectRequest1(buffer);
                openconnect.decode();
            }
            case 0x07: {
                var openconnect2 = new OpenConnecetRequest2(buffer);
                openconnect2.decode();
            }
            case 0x00: {
                var connctedping = new ConnctedPing(buffer);
                connctedping.decode();
            }
        }      
    }
}