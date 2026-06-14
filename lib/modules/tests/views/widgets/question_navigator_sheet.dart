import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/test_runner_controller.dart';
import '../../models/question_model.dart';
import '../../models/student_answer_model.dart';

class QuestionNavigatorSheet extends StatelessWidget {
  final TestRunnerController controller;

  const QuestionNavigatorSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Question Navigator',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // States Legend Scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildLegendItem('Not Visited', const Color(0xFFF3F4F6), Colors.black54, null),
                const SizedBox(width: 10),
                _buildLegendItem('Answered', const Color(0xFF1E60FF), Colors.white, null),
                const SizedBox(width: 10),
                _buildLegendItem('Flagged', const Color(0xFFF97316), Colors.white, null),
                const SizedBox(width: 10),
                _buildLegendItem('Ans + Flag', const Color(0xFF7C3AED), Colors.white, null),
                const SizedBox(width: 10),
                _buildLegendItem('Skipped', Colors.white, const Color(0xFFEF4444), Border.all(color: const Color(0xFFEF4444), width: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Questions Grid
          Flexible(
            child: Obx(() {
              final qList = controller.questions;
              return GridView.builder(
                shrinkWrap: true,
                itemCount: qList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final q = qList[index];
                  final ans = controller.userAnswers[q.id];
                  return _buildCircle(index, q, ans);
                },
              );
            }),
          ),
          const SizedBox(height: 24),

          // Statistics Text Summary
          Obx(() {
            final answered = controller.countAnswered;
            final remaining = controller.countRemaining;
            final flagged = controller.countFlagged;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Answered: $answered | Flagged: $flagged | Remaining: $remaining unanswered.',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),

          // Submission Action
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Get.back(); // close bottom sheet
                controller.submitTest();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626), // red
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Obx(() {
                return Text(
                  'Submit Test — ${controller.countAnswered}/${controller.questions.length} Answered',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color bg, Color text, Border? border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: border,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: text),
      ),
    );
  }

  Widget _buildCircle(int index, QuestionModel q, StudentAnswer? ans) {
    Color bgColor = const Color(0xFFF3F4F6); // Default Grey (Not Visited)
    Color textColor = const Color(0xFF4B5563);
    Border? border;

    if (ans != null && ans.isVisited) {
      if (ans.isFlagged) {
        if (ans.hasAnswer) {
          bgColor = const Color(0xFF7C3AED); // Purple
          textColor = Colors.white;
        } else {
          bgColor = const Color(0xFFF97316); // Orange
          textColor = Colors.white;
        }
      } else {
        if (ans.hasAnswer) {
          bgColor = const Color(0xFF1E60FF); // Blue
          textColor = Colors.white;
        } else {
          // Visited but no answer and not flagged -> Skipped -> Red Outline
          bgColor = Colors.white;
          textColor = const Color(0xFFEF4444);
          border = Border.all(color: const Color(0xFFEF4444), width: 1.5);
        }
      }
    }

    final isCurrent = index == controller.currentIndex.value;
    if (isCurrent) {
      // Bold dark blue outline around current question circle
      border = Border.all(
        color: const Color(0xFF0F3CC9),
        width: 3.0,
      );
    }

    return GestureDetector(
      onTap: () {
        controller.jumpToQuestion(index);
        Get.back(); // close bottom sheet
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: border,
        ),
        alignment: Alignment.center,
        child: Text(
          '${index + 1}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
