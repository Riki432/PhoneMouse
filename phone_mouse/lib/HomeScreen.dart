import 'package:flutter/material.dart';
import 'package:phone_mouse/MousePad.dart';
import 'package:web_socket_channel/io.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController ip = TextEditingController();
  final _ipKey = GlobalKey<FormFieldState>();
  Color connectionColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.blueAccent,
        leading: Icon(Icons.home),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Please enter your PC's IP address in the field. "),
            Divider(),
            Text("For Windows, Open CMD and Enter ipconfig to get the IP address"),
            Divider(),
            Text("For Linux/MAC, Open Terminal and Enter ifconfig to get the IP address"),
            Divider(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: TextFormField(
                key: _ipKey,
                controller: ip,
                autofocus: true,
                autocorrect: false,
                maxLength: 15,
                style: TextStyle(
                  fontSize: 28
                ),
                // textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "192.168.2.1",
                  labelText: "IP",
                  // labelStyle: TextStyle(a),
                ),
                validator: (val){
                  final pattern = RegExp(r"[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}");
                  if(pattern.hasMatch(val)) return null;
                  else return "Please enter a valid IP";
                },
              ),
            ),
            
            MaterialButton(
              child: Text(
                "Connect",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300
                ),),
              color: Colors.blue,
              elevation: 15.0,
              
              splashColor: Colors.green,
              onPressed: (){
                if(!_ipKey.currentState.validate()) return;
                // showDialog(
                //   context: context,
                //   barrierDismissible: false,
                //   builder: (context) => AlertDialog(
                //     content: Transform.rotate(
                //       angle: 1.0,
                //       child: Container(
                //         color: connectionColor,
                //       ),
                //     ),
                //   )
                // );

                final socket = IOWebSocketChannel.connect("ws://${ip.text}:4041");
                // setState(() {
                // //   connectionColor = Colors.green;
                // // });
                socket.sink.add("Connected to client!");
                socket.sink.add("PS:${MediaQuery.of(context).size.width},${MediaQuery.of(context).size.height}");
                // // Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => MousePad(socket: socket)
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}