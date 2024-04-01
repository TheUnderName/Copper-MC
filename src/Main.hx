using src.Server;
using utils.Logger;
class Main {
  static public function main() {
    Logger.DEBUG_STATS = true;
    Logger.LOG_STATS = true;
    var myServer:Server = new Server("Copper MC", "127.0.0.1", 19132);
    myServer.Start();
  }
}
