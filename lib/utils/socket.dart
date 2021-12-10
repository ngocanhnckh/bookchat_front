import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class eventSocket {
  final Function() notifyParent;
  eventSocket({this.notifyParent});
  void Listen(){
    print("Start listening");
    
    IO.Socket socket;
    // Configure socket transports must be sepecified
      socket = io('https://api.bookchat.vn/_ws', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
     
      // Connect to websocket
    socket.connect();

    socket.on('Connected', (_) => print('connected'));
    socket.on('NEW_MESSAGE', (data) => {
      print(data.toString())
    });
  }
}






