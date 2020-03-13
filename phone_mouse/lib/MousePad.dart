import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class MousePad extends StatefulWidget {
  final IOWebSocketChannel socket;
  const MousePad({Key key, @required this.socket}) : super(key: key);
  @override
  _MousePadState createState() => _MousePadState();
}

class _MousePadState extends State<MousePad> {
  DrawPoint point = DrawPoint(
              paint: Paint()
                ..strokeCap = StrokeCap.round
                ..isAntiAlias = true
                ..color = Colors.black
                ..strokeWidth = 8,
                points: Offset(0, 0)
            );

  @override
  Widget build(BuildContext context) {
    final socket = widget.socket;
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details){
          socket.sink.add("${details.globalPosition.dx},${details.globalPosition.dy}");
          setState(() {
            point = DrawPoint(
              paint: Paint()
                ..strokeCap = StrokeCap.round
                ..isAntiAlias = true
                ..color = Colors.black
                ..strokeWidth = 8,
                points: details.globalPosition
            );
          });
        },
        onTap: (){
          socket.sink.add("CLICK");
        },
        onDoubleTap: (){
          socket.sink.add("DBLCLICK");
        },
          child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 5)
          ),
          child: CustomPaint(
            size: Size.infinite,
            painter: MousePointer(point),
          )
        ),
      ),
    );
  }
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