import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Container'),
        ),
        body: const InteractiveContainer(),
      ),
    );
  }
}

class InteractiveContainer extends StatefulWidget {
  const InteractiveContainer({super.key});

  @override
  InteractiveContainerState createState() => InteractiveContainerState();
}

class InteractiveContainerState extends State<InteractiveContainer> {
  Offset position = Offset.zero;
  double containerWidth = 200;
  double containerHeight = 200;
  double scaleFactor = 0.01;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      position += details.delta;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      double newScale = 1 + (details.scale - 1) * scaleFactor;
      containerWidth *= newScale;
      containerHeight *= newScale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handleDragUpdate,
      child: RawGestureDetector(
        gestures: {
          ScaleGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<ScaleGestureRecognizer>(
            () => ScaleGestureRecognizer(),
            (ScaleGestureRecognizer instance) {
              instance.onUpdate = _handleScaleUpdate;
            },
          ),
        },
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
      ),
    );
  }
}
