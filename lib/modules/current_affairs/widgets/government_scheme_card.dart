import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/current_affairs_models.dart';

class GovernmentSchemeCard extends StatelessWidget {
  final GovernmentScheme scheme;

  const GovernmentSchemeCard({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: scheme.type == 'Central' ? Colors.indigo.shade50 : Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${scheme.type} Govt",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: scheme.type == 'Central' ? Colors.indigo : Colors.teal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            scheme.titleEn,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
          if (scheme.titleTa != null && scheme.titleTa!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              scheme.titleTa!,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            scheme.descriptionEn,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.45),
          ),
          if (scheme.descriptionTa != null && scheme.descriptionTa!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              scheme.descriptionTa!,
              style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}
