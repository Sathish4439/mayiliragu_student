import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ReadinessGauge extends StatelessWidget {
  final double score;
  final double size;

  const ReadinessGauge({
    super.key,
    required this.score,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    final cleanScore = score.clamp(0, 100).toDouble();
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: cleanScore / 100,
              strokeWidth: 12,
              backgroundColor: Colors.grey.shade100,
              color: AppColors.brandPurple,
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${cleanScore.toInt()}%',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Readiness',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
