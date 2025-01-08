import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashedRect extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double gap;

  const DashedRect({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(strokeWidth / 2),
      child: CustomPaint(
        painter: DashRectPainter(
          color: color,
          strokeWidth: strokeWidth,
          gap: gap,
        ),
      ),
    );
  }
}

class DashRectPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double gap;

  DashRectPainter({
    this.strokeWidth = 5.0,
    this.color = Colors.red,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double width = size.width;
    final double height = size.height;

    // Draw dashed paths for all sides
    final Path topPath = getDashedPath(
      start: math.Point(0, 0),
      end: math.Point(width, 0),
      gap: gap,
    );

    final Path rightPath = getDashedPath(
      start: math.Point(width, 0),
      end: math.Point(width, height),
      gap: gap,
    );

    final Path bottomPath = getDashedPath(
      start: math.Point(width, height),
      end: math.Point(0, height),
      gap: gap,
    );

    final Path leftPath = getDashedPath(
      start: math.Point(0, height),
      end: math.Point(0, 0),
      gap: gap,
    );

    canvas.drawPath(topPath, dashedPaint);
    canvas.drawPath(rightPath, dashedPaint);
    canvas.drawPath(bottomPath, dashedPaint);
    canvas.drawPath(leftPath, dashedPaint);
  }

  Path getDashedPath({
    required math.Point<double> start,
    required math.Point<double> end,
    required double gap,
  }) {
    final Path path = Path();
    path.moveTo(start.x, start.y);

    final double totalDistance = math.sqrt(
      math.pow(end.x - start.x, 2) + math.pow(end.y - start.y, 2),
    );

    final double dx = (end.x - start.x) / totalDistance * gap;
    final double dy = (end.y - start.y) / totalDistance * gap;

    bool draw = true;
    double currentDistance = 0.0;

    while (currentDistance < totalDistance) {
      final double nextX = start.x + dx * currentDistance / gap;
      final double nextY = start.y + dy * currentDistance / gap;

      if (draw) {
        path.lineTo(nextX, nextY);
      } else {
        path.moveTo(nextX, nextY);
      }

      draw = !draw;
      currentDistance += gap;
    }

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
