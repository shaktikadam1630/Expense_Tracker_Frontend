import 'dart:math';
import 'package:flutter/material.dart';

class SimplePieChart extends StatelessWidget {
  final Map<String, double> data;

  const SimplePieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    final colors = [
      Colors.indigo,
      Colors.pinkAccent,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.blueGrey,
      Colors.cyan,
      Colors.deepOrangeAccent,
      Colors.amber,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ✅ Pie chart
        SizedBox(
          height: 200,
          width: 200,
          child: CustomPaint(
            painter: _PieChartPainter(data, colors),
          ),
        ),
        const SizedBox(height: 12),

        // ✅ Legend
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 6,
          children: data.keys.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final color = colors[index % colors.length];

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  category,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors;

  _PieChartPainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final total = data.values.fold(0.0, (a, b) => a + b);
    double startAngle = -pi / 2;
    final radius = min(size.width / 2, size.height / 2);

    int index = 0;
    data.forEach((_, value) {
      final sweep = (value / total) * 2 * pi;
      paint.color = colors[index % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweep,
        true,
        paint,
      );
      startAngle += sweep;
      index++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
