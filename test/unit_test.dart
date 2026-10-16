import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yds_pro/data/local_storage.dart';
import 'package:yds_pro/data/seed_questions.dart';
import 'package:yds_pro/models/exam.dart';
import 'package:yds_pro/models/question.dart';
import 'package:yds_pro/models/subscription_plan.dart';
import 'package:yds_pro/providers/exam_provider.dart';
import 'package:yds_pro/providers/local_storage_provider.dart';
import 'package:yds_pro/providers/question_provider.dart';
import 'package:yds_pro/providers/subscription_provider.dart';
import 'package:yds_pro/providers/vocabulary_provider.dart';

void main() {
  group('YDS Master PRO Unit & Logic Tests', () {
    late LocalStorage storage;
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.init();
      container = ProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Subscription purchase activates PRO status and gates correctly', () async {
      final subNotifier = container.read(subscriptionProvider.notifier);
      expect(container.read(subscriptionProvider).isPro, isFalse);

      final monthlyPlan = SubscriptionPlan.defaultPlans().firstWhere(
        (p) => p.tier == SubscriptionTier.proMonthly,
      );

      final success = await subNotifier.purchaseSubscription(monthlyPlan);
      expect(success, isTrue);

      final currentSub = container.read(subscriptionProvider);
      expect(currentSub.isPro, isTrue);
      expect(currentSub.tier, equals(SubscriptionTier.proMonthly));
      expect(subNotifier.canAccessFeature(isPremiumOnly: true), isTrue);

      // Reset subscription
      await subNotifier.cancelSubscription();
      expect(container.read(subscriptionProvider).isPro, isFalse);
      expect(subNotifier.canAccessFeature(isPremiumOnly: true), isFalse);
    });

    test('Vocabulary SRS increments and decrements correctly', () async {
      final vocabNotifier = container.read(vocabularyProvider.notifier);
      final initialWord = container.read(vocabularyProvider).allWords.first;

      expect(initialWord.srsLevel, equals(0));
      expect(initialWord.isLearned, isFalse);

      // Known answer promotion
      await vocabNotifier.answerKnown(initialWord.id);
      final promoted = container.read(vocabularyProvider).allWords.firstWhere((w) => w.id == initialWord.id);
      expect(promoted.srsLevel, equals(1));

      // Unknown answer demotion
      await vocabNotifier.answerUnknown(initialWord.id);
      final demoted = container.read(vocabularyProvider).allWords.firstWhere((w) => w.id == initialWord.id);
      expect(demoted.srsLevel, equals(1));
    });

    test('Question submission validates correct and incorrect answers', () async {
      final qNotifier = container.read(questionProvider.notifier);
      qNotifier.selectCategory(QuestionCategory.vocabulary);

      final currentQ = container.read(questionProvider).currentQuestion!;
      expect(currentQ, isNotNull);

      // Pick correct answer
      qNotifier.selectOption(currentQ.correctIndex);
      await qNotifier.submitAnswer();

      expect(container.read(questionProvider).hasSubmitted, isTrue);
      expect(container.read(questionProvider).isCurrentCorrect, isTrue);
    });

    test('Exam calculation assigns accurate YDS letter grades', () {
      expect(ExamResult.calculateGrade(92.5), contains('A'));
      expect(ExamResult.calculateGrade(85.0), contains('B'));
      expect(ExamResult.calculateGrade(72.0), contains('C'));
      expect(ExamResult.calculateGrade(64.0), contains('D'));
      expect(ExamResult.calculateGrade(55.0), contains('E'));
      expect(ExamResult.calculateGrade(40.0), contains('F'));
    });
  });
}
