import 'dart:convert';

import 'package:flutter/material.dart';

class ImageMarkerScreen extends StatefulWidget {
  const ImageMarkerScreen({super.key});

  @override
  State<ImageMarkerScreen> createState() => _ImageMarkerScreenState();
}

class _ImageMarkerScreenState extends State<ImageMarkerScreen> {
  List<Map<String, dynamic>> points = [];
  Rect? imageRect;
  final double originalWidth = 1920;
  final double originalHeight = 1200;

  void clearPoints() {
    setState(() {
      points.clear();
    });
  }

  void savePoints() {
    // Convert points to JSON format (only save original coordinates)
    List<Map<String, dynamic>> pointsToSave = points.map((point) {
      return {'x': point['originalPosition']['x'], 'y': point['originalPosition']['y']};
    }).toList();

    // Example: Convert to JSON string
    String jsonPoints = jsonEncode(pointsToSave);
    print('Saved points: $jsonPoints');
  }

  void loadPoints() {
    // Example JSON string (this would come from storage/server)
    String jsonPoints = '[{"x":663,"y":291},{"x":825,"y":291},{"x":663,"y":467},{"x":825,"y":467}]'; //co-ordinates considering image size 1920x1200

    List<dynamic> loadedPoints = jsonDecode(jsonPoints);

    setState(() {
      points.clear();
      for (var point in loadedPoints) {
        // Convert original coordinates back to screen coordinates
        double relativeX = point['x'] / originalWidth;
        double relativeY = point['y'] / originalHeight;

        if (imageRect != null) {
          Offset screenPosition = Offset(
            imageRect!.left + (relativeX * imageRect!.width),
            imageRect!.top + (relativeY * imageRect!.height),
          );

          points.add({
            'screenPosition': screenPosition,
            'originalPosition': {'x': point['x'], 'y': point['y']},
          });
        }
      }
    });
  }

  void addPoint(Offset screenPosition) {
    if (imageRect == null) return;

    double relativeX = (screenPosition.dx - imageRect!.left) / imageRect!.width;
    double relativeY = (screenPosition.dy - imageRect!.top) / imageRect!.height;

    int actualX = (relativeX * originalWidth).round();
    int actualY = (relativeY * originalHeight).round();

    setState(() {
      points.add({
        'screenPosition': screenPosition,
        'originalPosition': {'x': actualX, 'y': actualY},
      });
    });

    print('Screen position: $screenPosition');
    print('Original image coordinates: x=$actualX, y=$actualY');

    savePoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw Circles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadPoints,
            tooltip: 'Load Points',
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: clearPoints,
            tooltip: 'Clear Points',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double imageAspectRatio = originalWidth / originalHeight;
                double screenAspectRatio = constraints.maxWidth / constraints.maxHeight;

                late double imageWidth;
                late double imageHeight;
                late double offsetX;
                late double offsetY;

                if (screenAspectRatio > imageAspectRatio) {
                  imageHeight = constraints.maxHeight;
                  imageWidth = imageHeight * imageAspectRatio;
                  offsetX = (constraints.maxWidth - imageWidth) / 2;
                  offsetY = 0;
                } else {
                  imageWidth = constraints.maxWidth;
                  imageHeight = imageWidth / imageAspectRatio;
                  offsetX = 0;
                  offsetY = (constraints.maxHeight - imageHeight) / 2;
                }

                imageRect = Rect.fromLTWH(offsetX, offsetY, imageWidth, imageHeight);

                return Stack(
                  children: [
                    Positioned(
                      left: offsetX,
                      top: offsetY,
                      width: imageWidth,
                      height: imageHeight,
                      child: Image.asset('assets/images/mountain.jpg', fit: BoxFit.fill),
                    ),
                    GestureDetector(
                      onTapDown: (details) {
                        if (imageRect!.contains(details.localPosition)) {
                          addPoint(details.localPosition);
                        }
                      },
                      child: CustomPaint(
                        painter: RectanglePainter(points), // Remove the .map() transformation
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: points.length,
                itemBuilder: (context, index) {
                  final point = points[index];
                  final originalPos = point['originalPosition'];
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.withOpacity(0.7),
                      radius: 12,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      'Point ${index + 1}: X=${originalPos['x']}, Y=${originalPos['y']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final List<Map<String, dynamic>> points;

  CirclePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point['screenPosition'] as Offset, 5, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class RectanglePainter extends CustomPainter {
  final List<Map<String, dynamic>> pointCollection;
  RectanglePainter(this.pointCollection);

  @override
  void paint(Canvas canvas, Size size) {

    final points = pointCollection
        .where((p) => p['screenPosition'] is Offset)
        .map((p) => p['screenPosition'] as Offset)
        .toList();

    if (points.length < 4) return;

    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[3].dx, points[3].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

