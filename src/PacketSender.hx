package src;
import haxe.macro.Expr.Catch;
import sys.net.UdpSocket;
import sys.net.Address;
import haxe.io.*;
using src.Server;
using utils.Binary;
using utils.Logger;
class PacketSender {
	public static var ClientAddress(default, null):{port:() -> Int, ip:() -> {toString:() -> String}};

    var ServerSocket:UdpSocket;
    public static var ClientAddreas:Address;
    public function new() {
        this.ServerSocket = Server.UdpServer;    }
    public function SendPacket(buf:Bytes,pos:Int,len:Int):Bool {
        Logger.Debug(ClientAddreas.getHost());
        try {
            ServerSocket.sendTo(buf,pos,len,ClientAddreas);
        }catch(e:Any) {
            trace(e);
        }
        return true;
    }
}