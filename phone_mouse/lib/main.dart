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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  Animation<double> anim; 
  Animation<double> scaleAnim;
  AnimationController animController;
  @override
  void initState() {
    animController = AnimationController(vsync:  this, duration: Duration(seconds: 2))
      ..addStatusListener((status){
        switch(status){
          case AnimationStatus.completed:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
            break;
          default:
        }
      })
      ..addListener((){
        setState(() {
          
        });
      });
    anim = Tween(
      begin: -3.14,
      end: 3.14,
    ).animate(animController);

    scaleAnim = Tween(
      begin: 0.5,
      end: 2.0
    ).animate(animController);

    animController.forward();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: Transform.rotate(
          angle: anim.value,
          child: Transform.scale(
            scale: scaleAnim.value,
            child: Image.asset("assets/icon.png", 
            height: 300, 
            width: 300)
          ),
        ),
      ),
    );

  }

}
