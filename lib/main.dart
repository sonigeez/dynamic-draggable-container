import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Container'),
        ),
        body: InteractiveContainer(),
      ),
    );
  }
}

class InteractiveContainer extends StatefulWidget {
  @override
  _InteractiveContainerState createState() => _InteractiveContainerState();
}

class _InteractiveContainerState extends State<InteractiveContainer> {
  Offset position = Offset.zero;
  double containerWidth = 200;
  double containerHeight = 200;
  double scaleFactor = 0.01;
  Offset? _scaleFocalPoint;

  void _handleScaleStart(ScaleStartDetails details) {
    _scaleFocalPoint = details.localFocalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Handle scaling
      double newScale = 1 + (details.scale - 1) * scaleFactor;
      containerWidth *= newScale;
      containerHeight *= newScale;

      // Handle dragging
      position += details.localFocalPoint - _scaleFocalPoint!;
      _scaleFocalPoint = details.localFocalPoint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Container(
              width: containerWidth,
              height: containerHeight,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
