import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MemoryReframingScreen extends StatefulWidget {
  @override
  _MemoryReframingScreenState createState() => _MemoryReframingScreenState();
}

class _MemoryReframingScreenState extends State<MemoryReframingScreen> {
  List<Offset> _points = [];
  bool _isErasing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Reframing 🎨'),
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              setState(() {
                if (_points.isNotEmpty) {
                  _points.removeLast();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(_isErasing ? Icons.brush : Icons.delete),
            onPressed: () {
              setState(() {
                _isErasing = !_isErasing;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _points.clear();
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/memory_image.jpg', // Replace with actual image path
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                RenderBox? object = context.findRenderObject() as RenderBox?;
                Offset localPosition =
                object!.globalToLocal(details.globalPosition);
                _points.add(localPosition);
              });
            },
            onPanEnd: (details) => _points.add(Offset.infinite),
            child: CustomPaint(
              painter: MemoryPainter(_points, _isErasing),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class MemoryPainter extends CustomPainter {
  final List<Offset> points;
  final bool isErasing;

  MemoryPainter(this.points, this.isErasing);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isErasing ? Colors.transparent : Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0
      ..blendMode = isErasing ? BlendMode.clear : BlendMode.srcOver;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(MemoryPainter oldDelegate) => true;
}
