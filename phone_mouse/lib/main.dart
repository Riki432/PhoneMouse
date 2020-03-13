import 'package:flutter/material.dart';
import 'package:phone_mouse/HomeScreen.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  IOWebSocketChannel socket;
  TextEditingController ipController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    socket.sink.close();
    super.dispose();
  }
  void _incrementCounter() {
    final ip = ipController.text;
    // socket = IOWebSocketChannel.connect("ws://${ip}:4041");
    // socket.sink.add("Connected to client!");
    // socket.sink.add("PS:${MediaQuery.of(context).size.width},${MediaQuery.of(context).size.height}");
    // socket.sink.add("$_counter");
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    _counter++;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails deets){
          final y = deets.globalPosition.dy;
          final x = deets.globalPosition.dx;
          socket.sink.add("$x, $y");
        },
        onHorizontalDragUpdate: (DragUpdateDetails deets){
          final y = deets.globalPosition.dy;
          final x = deets.globalPosition.dx;
          socket.sink.add("$x, $y");
        },
        child: Container(
          color: Colors.red,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 300,
                  child: TextField(
                    controller : ipController
                  ), 
                ),

                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ), 
        ) 
        
      ), 
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
