import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../models/exam.dart';

class ExamResultScreen extends StatelessWidget {
  final ExamResult result;

  const ExamResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final minutesSpent = result.timeSpentSeconds ~/ 60;
    final secondsSpent = result.timeSpentSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deneme Sınavı Sonucu'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score Radial Indicator Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    result.examTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 12.0,
                    animation: true,
                    percent: (result.score / 100.0).clamp(0.0, 1.0),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          result.score.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryLight,
                          ),
                        ),
                        const Text(
                          '/ 100 Puan',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColors.primaryLight,
                    backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ).animate().scale(),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'YDS Seviyesi: ${result.letterGrade}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Statistics Grid (Doğru, Yanlış, Boş, Süre)
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    label: 'Doğru',
                    value: '${result.correctCount}',
                    color: AppColors.success,
                    icon: Icons.check_circle,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    label: 'Yanlış',
                    value: '${result.wrongCount}',
                    color: AppColors.error,
                    icon: Icons.cancel,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    label: 'Boş',
                    value: '${result.emptyCount}',
                    color: Colors.grey,
                    icon: Icons.hourglass_empty,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    label: 'Geçen Süre',
                    value: '${minutesSpent}dk ${secondsSpent}sn',
                    color: AppColors.info,
                    icon: Icons.timer,
                    isDark: isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Back to Main Screen Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Ana Sayfaya Dön',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
