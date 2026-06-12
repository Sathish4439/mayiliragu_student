import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/analytics_models.dart';

class TrendChart extends StatelessWidget {
  final List<PerformanceTrendModel> trends;

  const TrendChart({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) {
      return const Center(
        child: Text(
          'No trend data available yet',
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: CustomPaint(
        size: Size.infinite,
        painter: _LineChartPainter(trends),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<PerformanceTrendModel> trends;

  _LineChartPainter(this.trends);

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Paints
    final gridPaint = Paint()
      ..color = Colors.grey.shade100
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = AppColors.brandPurple
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = AppColors.brandPurple
      ..style = PaintingStyle.fill;

    // Draw horizontal grid lines
    const int gridCount = 4;
    for (int i = 0; i <= gridCount; i++) {
      final y = (height / gridCount) * i;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Map points
    final double xSpacing = width / (trends.length - 1 == 0 ? 1 : trends.length - 1);
    final List<Offset> points = [];

    // Find max score/value to scale
    double maxValue = 100; // default cap
    for (var t in trends) {
      if (t.score > maxValue) maxValue = t.score;
    }

    for (int i = 0; i < trends.length; i++) {
      final x = i * xSpacing;
      // Invert Y axis since 0 is at top
      final y = height - ((trends[i].score / maxValue) * height);
      points.add(Offset(x, y));
    }

    // Draw lines connecting points
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw points circles
    for (var pt in points) {
      canvas.drawCircle(pt, 5, pointPaint);
      canvas.drawCircle(pt, 2.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
