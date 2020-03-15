import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class MousePad extends StatefulWidget {
  final IOWebSocketChannel socket;
  MousePad({@required this.socket});
  @override
  _MousePadState createState() => _MousePadState();
}

class _MousePadState extends State<MousePad> {
  bool updateScreenSize  = false;
  DrawPoint point = DrawPoint(
              paint: Paint()
                ..strokeCap = StrokeCap.round
                ..isAntiAlias = true
                ..color = Colors.black
                ..strokeWidth = 8,
                points: Offset(0, 0)
            );

  double scrollValue = 0;


  Future<bool> _alertDialog(){
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure you want to exit?"),
      actions: <Widget>[
          FlatButton(
            child: Text("Yes"),
            onPressed: () => Navigator.of(context).pop(true)
          ),
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      )  
    ); 
    
  }


  @override
  Widget build(BuildContext context) {
    final socket = widget.socket;
    if(!updateScreenSize){
      widget.socket.sink.add("PS:${MediaQuery.of(context).size.width},${MediaQuery.of(context).size.height}");
      print("PS:${MediaQuery.of(context).size.width},${MediaQuery.of(context).size.height}");
      updateScreenSize = true;
    }
    return 
    WillPopScope(
          onWillPop: _alertDialog,
          child: Scaffold(
        body: GestureDetector(
          onPanUpdate: (details){
            // print("${details.globalPosition.dy},${details.globalPosition.dx}");
            socket.sink.add("UPDATE:${details.globalPosition.dy}:${details.globalPosition.dx}");
            setState(() {
              point = DrawPoint(
                paint: Paint()
                  ..strokeCap = StrokeCap.round
                  ..isAntiAlias = true
                  ..color = Colors.black
                  ..strokeWidth = 4,
                  points: details.globalPosition
              );
            });
          },
          onLongPressStart: (details){
            print("Long Press Started at: ${details.globalPosition.dx}:${details.globalPosition.dy}");
            socket.sink.add("LONG_PRESS_START");
          },
          onLongPressEnd: (details){
            print("Long Press Ended at: ${details.globalPosition.dx},${details.globalPosition.dy}");
            socket.sink.add("LONG_PRESS_END");
          },
          onLongPressMoveUpdate: (details){
            print("Long Press Moving at: ${details.globalPosition.dx}:${details.globalPosition.dy}");
            socket.sink.add("LONG_PRESS_UPDATE:${details.globalPosition.dx}:${details.globalPosition.dy}");
          },
            child: Stack(
              children: <Widget>[
                Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 5),
                  // color: Colors.amberAccent
                ),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: MousePointer(point),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                            onTap: (){
                              print("LEFT TAP DETECTED");
                              socket.sink.add("LEFTCLICK");
                            },
                            onDoubleTap: (){
                              print("LEFT DOUBLE TAP DETECTED");
                              socket.sink.add("DBL_LEFTCLICK");
                            },
                            child: Container(
                            color: Colors.red.withOpacity(0.4),
                            height: MediaQuery.of(context).size.height/2,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        GestureDetector(
                            onTap: (){
                              print("RIGHT TAP DETECTED");
                              socket.sink.add("RIGHTCLICK");
                            },
                            onDoubleTap: (){
                              print("RIGHT DOUBLE TAP DETECTED");
                              socket.sink.add("DBL_RIGHTCLICK");
                            },
                            child: Container(
                            color: Colors.blue.withOpacity(0.4),
                            height: MediaQuery.of(context).size.height/2,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
          ),
          
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Transform.rotate(
                      angle: 2* 3.14,
                      child: Slider(
                      activeColor: Colors.blueGrey,
                      inactiveColor: Colors.blueGrey,
                      onChangeStart: (double val){
                        socket.sink.add("SCL_START:$val");
                        print("Changing : $val");
                      },
                      // onChangeEnd: (double val){
                      //   socket.sink.add("SCL_END: $val");
                      //   print("Changed : $val");
                      // },
                      onChanged: (double value) { 
                        // socket.sink.add("SCROLL:$scrollValue");
                        print(scrollValue);
                          setState(() {
                            scrollValue = value;
                          });
                          }, 
                        min: -20,
                        max: 20, 
                        value: scrollValue,
                        divisions: 4,
                        label: getScrollLabel(scrollValue),
                    ),
                  ),
              ],
            ),
          
            
              ],
            ),
        ),
      )
    );
  }

  String getScrollLabel(num value)
  {
    if(value <= -20) return "<<";
    if(value <= -10) return "<";
    if(value <= 0) return " ";
    if(value <= 10) return ">";
    if(value <= 20) return ">>";
    return " ";
  }

}

class ScollSpeed{
  static final fastUp = -2;
  static final slowUp = -1;
  static final noScroll = 0;
  static final slowDown = 1;
  static final fastDown = 2;    
}

class DrawPoint{
  final Paint paint;
  final Offset points;
  DrawPoint({this.paint, this.points});
}


class MousePointer extends CustomPainter {
  final DrawPoint point;

  MousePointer(this.point);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(point.points, 8.0, point.paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
  
}