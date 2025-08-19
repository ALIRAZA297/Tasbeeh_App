import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/quiz_controller.dart';
import '../../../Utils/app_colors.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Islamic Quiz',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? white : black,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primary));
        }
        if (controller.selectedQuestions.isEmpty) {
          return Center(
            child: Text(
              'No questions available. Please try again.',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? white : grey800,
              ),
            ),
          );
        }
        if (controller.currentQuestionIndex.value <
            controller.selectedQuestions.length) {
          final question = controller
              .selectedQuestions[controller.currentQuestionIndex.value];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Card
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${controller.currentQuestionIndex.value + 1}',
                            style: const TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question['question'] ?? 'Question not available',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              question['questionUrdu'] ?? '',
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.notoNastaliqUrdu(
                                fontSize: 18,
                                color: white70,
                                height: 2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Answer Options
                ...List.generate(question['options'].length, (i) {
                  final option = question['options'][i];
                  final optionUrdu = question['optionsUrdu']?[i] ?? "";

                  return GestureDetector(
                    onTap: controller.showFeedback.value
                        ? null
                        : () => controller.checkAnswer(option),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: controller.showFeedback.value &&
                                option == question['correctAnswer']
                            ? green700
                            : controller.showFeedback.value &&
                                    option != question['correctAnswer']
                                ? red.withOpacity(0.6)
                                : secondary,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: isDarkMode ? white12 : grey300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: controller.showFeedback.value
                                  ? white
                                  : grey800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            optionUrdu,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.notoNastaliqUrdu(
                              fontSize: 16,
                              color: controller.showFeedback.value
                                  ? white70
                                  : grey700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // Feedback + Next button
                if (controller.showFeedback.value) ...[
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.feedbackMessage.value,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? white70 : grey800,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Next Question',
                        style: TextStyle(
                          fontSize: 16,
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Quiz Complete! 🎉',
                    style: TextStyle(
                      fontSize: 24,
                      color: isDarkMode ? white : grey800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Score: ${controller.score.value}/10',
                    style: TextStyle(
                        fontSize: 20, color: isDarkMode ? white70 : grey800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'High Score: ${controller.highScore.value}/10',
                    style: TextStyle(
                        fontSize: 20, color: isDarkMode ? white70 : grey800),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: controller.resetQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                    ),
                    child: const Text(
                      'Play Again',
                      style: TextStyle(
                        fontSize: 16,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
