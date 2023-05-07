import 'package:flutter/material.dart';

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
              child: Align(
                alignment: Alignment.bottomRight,
                child: Transform.translate(
                  offset: const Offset(12, 12),
                  child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2))
                          ]),
                      padding: const EdgeInsets.all(2),
                      child: GestureDetector(
                          onPanUpdate: _handleResizeUpdate,
                          child: const Icon(Icons.drag_handle, size: 24))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleResizeUpdate(DragUpdateDetails details) {
    setState(() {
      containerWidth += details.delta.dx;
      containerHeight += details.delta.dy;
    });
  }
}
