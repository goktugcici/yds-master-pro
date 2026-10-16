import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yds_pro/data/local_storage.dart';
import 'package:yds_pro/data/seed_questions.dart';
import 'package:yds_pro/data/seed_words.dart';
import 'package:yds_pro/models/exam.dart';
import 'package:yds_pro/models/question.dart';
import 'package:yds_pro/models/subscription_plan.dart';
import 'package:yds_pro/providers/exam_provider.dart';
import 'package:yds_pro/providers/local_storage_provider.dart';
import 'package:yds_pro/providers/question_provider.dart';
import 'package:yds_pro/providers/stats_provider.dart';
import 'package:yds_pro/providers/subscription_provider.dart';
import 'package:yds_pro/providers/vocabulary_provider.dart';
import 'package:yds_pro/views/home/home_screen.dart';
import 'package:yds_pro/views/mistakes/mistake_notebook_screen.dart';
import 'package:yds_pro/data/seed_readings.dart';
import 'package:yds_pro/views/exam/exam_list_screen.dart';
import 'package:yds_pro/views/paywall/paywall_screen.dart';
import 'package:yds_pro/views/profile/profile_screen.dart';
import 'package:yds_pro/views/stats/detailed_stats_screen.dart';
import 'package:yds_pro/views/strategies/strategy_guide_screen.dart';
import 'package:yds_pro/views/vocabulary/vocabulary_screen.dart';
import 'package:yds_pro/data/seed_grammar_topics.dart';
import 'package:yds_pro/views/grammar/grammar_study_screen.dart';
import 'package:yds_pro/views/notes/question_notes_screen.dart';
import 'package:yds_pro/data/seed_collocations.dart';
import 'package:yds_pro/views/collocations/collocation_quiz_screen.dart';
import 'package:yds_pro/views/reading/reading_detail_screen.dart';
import 'package:yds_pro/data/seed_phrasal_verbs.dart';
import 'package:yds_pro/views/phrasal_verbs/phrasal_verbs_screen.dart';
import 'package:yds_pro/views/exam/exam_result_screen.dart';
import 'package:yds_pro/views/exam/exam_active_screen.dart';
import 'package:yds_pro/data/seed_cohesion_drills.dart';
import 'package:yds_pro/views/cohesion/cohesion_lab_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('1. LocalStorage & Persistence Tests', () {
    late LocalStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.init();
    });

    test('Learned and Favorite words can be persisted and retrieved', () async {
      expect(storage.getLearnedWordIds(), isEmpty);
      expect(storage.getFavoriteWordIds(), isEmpty);

      await storage.setWordLearned('w_1', true);
      await storage.setWordLearned('w_2', true);
      await storage.toggleWordFavorite('w_1');

      expect(storage.getLearnedWordIds(), containsAll(['w_1', 'w_2']));
      expect(storage.getFavoriteWordIds(), contains('w_1'));

      await storage.setWordLearned('w_2', false);
      expect(storage.getLearnedWordIds(), isNot(contains('w_2')));
    });

    test('Streak update increments or restarts based on consecutive days', () async {
      await storage.checkAndUpdateStreak();
      expect(storage.getStreak(), equals(1));

      // Same day call should not increase streak
      await storage.checkAndUpdateStreak();
      expect(storage.getStreak(), equals(1));
    });

    test('Theme mode persistence works correctly', () async {
      expect(storage.isDarkMode(), isFalse);
      await storage.setDarkMode(true);
      expect(storage.isDarkMode(), isTrue);
    });

    test('Exam result history saving and retrieval', () async {
      expect(storage.getExamResults(), isEmpty);

      final mockResult = ExamResult(
        id: 'res_test_1',
        examId: 'exam_mini_1',
        examTitle: 'Mini Deneme',
        totalQuestions: 20,
        correctCount: 16,
        wrongCount: 4,
        emptyCount: 0,
        score: 80.0,
        letterGrade: 'B (80-89)',
        userAnswers: {'q_voc_1': 1},
        completedAt: DateTime.now(),
        timeSpentSeconds: 1200,
      );

      await storage.saveExamResult(mockResult);
      final list = storage.getExamResults();
      expect(list.length, equals(1));
      expect(list.first.score, equals(80.0));
      expect(list.first.letterGrade, contains('B'));
    });
  });

  group('2. Vocabulary & SRS (Spaced Repetition) Logic Tests', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorage.init();
      container = ProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('Initial vocabulary state loads all default seed words', () {
      final state = container.read(vocabularyProvider);
      expect(state.allWords.length, equals(defaultSeedWords.length));
      expect(state.selectedCategory, equals('all'));
      expect(state.selectedFilter, equals('all'));
    });

    test('Category filtering narrows words correctly', () {
      final notifier = container.read(vocabularyProvider.notifier);
      notifier.setCategory('verb');

      final state = container.read(vocabularyProvider);
      expect(state.filteredWords.every((w) => w.partOfSpeech == 'verb'), isTrue);
    });

    test('Search query matches English or Turkish translations', () {
      final notifier = container.read(vocabularyProvider.notifier);
      notifier.setSearchQuery('mitigate');

      final state = container.read(vocabularyProvider);
      expect(state.filteredWords.length, equals(1));
      expect(state.filteredWords.first.english, equals('mitigate'));

      notifier.setSearchQuery('kötüleşmek');
      final stateTr = container.read(vocabularyProvider);
      expect(stateTr.filteredWords.length, equals(1));
      expect(stateTr.filteredWords.first.english, equals('deteriorate'));
    });

    test('SRS answerKnown promotes word and eventually marks learned', () async {
      final notifier = container.read(vocabularyProvider.notifier);
      final word = container.read(vocabularyProvider).allWords.first;

      // 4 consecutive known answers should mark it as learned
      for (int i = 0; i < 4; i++) {
        await notifier.answerKnown(word.id);
      }

      final updated = container
          .read(vocabularyProvider)
          .allWords
          .firstWhere((w) => w.id == word.id);
      expect(updated.srsLevel, greaterThanOrEqualTo(4));
      expect(updated.isLearned, isTrue);
    });

    test('SRS answerUnknown demotes word to review state', () async {
      final notifier = container.read(vocabularyProvider.notifier);
      final word = container.read(vocabularyProvider).allWords.first;

      await notifier.answerKnown(word.id);
      await notifier.answerUnknown(word.id);

      final updated = container
          .read(vocabularyProvider)
          .allWords
          .firstWhere((w) => w.id == word.id);
      expect(updated.srsLevel, equals(1));
      expect(updated.isLearned, isFalse);
    });
  });

  group('3. Question Bank & Practice Logic Tests', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorage.init();
      container = ProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('Category selection sets active questions pool', () {
      final notifier = container.read(questionProvider.notifier);
      notifier.selectCategory(QuestionCategory.grammar);

      final state = container.read(questionProvider);
      expect(state.selectedCategory, equals(QuestionCategory.grammar));
      expect(
        state.activeQuestions.every((q) => q.category == QuestionCategory.grammar),
        isTrue,
      );
    });

    test('Incorrect option submission is detected and explanation is shown', () async {
      final notifier = container.read(questionProvider.notifier);
      notifier.selectCategory(QuestionCategory.vocabulary);

      final currentQ = container.read(questionProvider).currentQuestion!;
      // Pick deliberately wrong index
      final wrongIndex = (currentQ.correctIndex + 1) % currentQ.options.length;

      notifier.selectOption(wrongIndex);
      await notifier.submitAnswer();

      final state = container.read(questionProvider);
      expect(state.hasSubmitted, isTrue);
      expect(state.isCurrentCorrect, isFalse);
      expect(state.showExplanation, isTrue);
    });

    test('Bookmark toggle adds and removes question ID', () {
      final notifier = container.read(questionProvider.notifier);
      const testId = 'q_voc_1';

      notifier.toggleBookmark(testId);
      expect(container.read(questionProvider).bookmarkedQuestionIds, contains(testId));

      notifier.toggleBookmark(testId);
      expect(container.read(questionProvider).bookmarkedQuestionIds, isNot(contains(testId)));
    });
  });

  group('4. Subscription & Paywall Logic Tests', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorage.init();
      container = ProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('Free user cannot access PRO-only features', () {
      final sub = container.read(subscriptionProvider);
      final notifier = container.read(subscriptionProvider.notifier);

      expect(sub.isPro, isFalse);
      expect(notifier.canAccessFeature(isPremiumOnly: true), isFalse);
      expect(notifier.canAccessFeature(isPremiumOnly: false), isTrue);
    });

    test('Yearly plan purchase sets 365-day expiry and enables PRO access', () async {
      final notifier = container.read(subscriptionProvider.notifier);
      final yearlyPlan = SubscriptionPlan.defaultPlans().firstWhere(
        (p) => p.tier == SubscriptionTier.proYearly,
      );

      final result = await notifier.purchaseSubscription(yearlyPlan);
      expect(result, isTrue);

      final sub = container.read(subscriptionProvider);
      expect(sub.isPro, isTrue);
      expect(sub.tier, equals(SubscriptionTier.proYearly));
      expect(sub.expiresAt, isNotNull);
      expect(sub.expiresAt!.difference(DateTime.now()).inDays, greaterThanOrEqualTo(364));
      expect(notifier.canAccessFeature(isPremiumOnly: true), isTrue);
    });

    test('Restore purchases recovers active subscription', () async {
      final notifier = container.read(subscriptionProvider.notifier);
      final monthlyPlan = SubscriptionPlan.defaultPlans().firstWhere(
        (p) => p.tier == SubscriptionTier.proMonthly,
      );

      await notifier.purchaseSubscription(monthlyPlan);
      final restored = await notifier.restorePurchases();
      expect(restored, isTrue);
      expect(container.read(subscriptionProvider).isPro, isTrue);
    });
  });

  group('5. Exam Engine & Scoring Logic Tests', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorage.init();
      container = ProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('Exam start initializes timer and question index', () {
      final exam = ExamNotifier.getAvailableExams().first;
      final notifier = container.read(examStateProvider.notifier);

      notifier.startExam(exam);
      final state = container.read(examStateProvider);

      expect(state, isNotNull);
      expect(state!.currentQuestionIndex, equals(0));
      expect(state.remainingSeconds, equals(exam.durationMinutes * 60));
      expect(state.isCompleted, isFalse);
    });

    test('Exam finishes and computes exact score and YDS letter grade', () async {
      final exam = ExamNotifier.getAvailableExams().first;
      final notifier = container.read(examStateProvider.notifier);

      notifier.startExam(exam);

      // Answer all questions correctly
      for (final q in exam.questions) {
        notifier.selectAnswer(q.id, q.correctIndex);
      }

      final result = await notifier.finishExam();
      expect(result, isNotNull);
      expect(result!.correctCount, equals(exam.questions.length));
      expect(result.wrongCount, equals(0));
      expect(result.score, equals(100.0));
      expect(result.letterGrade, contains('A'));
    });
  });

  group('6. UI Widget & Navigation Tests', () {
    testWidgets('PaywallScreen renders pricing plans and allows selection',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorage.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: PaywallScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check key Paywall texts
      expect(find.textContaining('YDS PRO'), findsWidgets);
      expect(find.text('PRO Yıllık Avantaj'), findsOneWidget);
      expect(find.text('PRO Aylık Paket'), findsOneWidget);
      expect(find.textContaining('7 Gün Ücretsiz Başla'), findsOneWidget);

      await tester.tap(find.text('PRO Aylık Paket'));
      await tester.pumpAndSettle();
    });

    testWidgets('VocabularyScreen tabs switch between Flashcards and List',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorage.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: VocabularyScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify tabs exist
      expect(find.text('Flashcard / Kartlar'), findsOneWidget);
      expect(find.text('Kelime Listesi'), findsOneWidget);

      // Tap on Kelime Listesi tab
      await tester.tap(find.text('Kelime Listesi'));
      await tester.pumpAndSettle();

      // Verify search field is rendered
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('ProfileScreen toggles theme mode',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorage.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Karanlık Mod (Dark Theme)'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);

      // Tap switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
    });
  });

  group('7. Mistake Notebook, Retest, Strategy & Target Score Tests', () {
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

    test('Wrong answer in question practice records question to mistake notebook', () async {
      final notifier = container.read(questionProvider.notifier);
      final qState = container.read(questionProvider);
      final firstQ = qState.activeQuestions.first;

      // Select wrong option
      final wrongOption = (firstQ.correctIndex + 1) % firstQ.options.length;
      notifier.selectOption(wrongOption);
      await notifier.submitAnswer();

      // Check mistake pool in state and storage
      final stateAfter = container.read(questionProvider);
      expect(stateAfter.mistakeQuestionIds, contains(firstQ.id));
      expect(storage.getMistakeQuestionIds(), contains(firstQ.id));

      // Now start retest - active pool should now be only mistake questions
      notifier.startMistakeRetest();
      final retestState = container.read(questionProvider);
      expect(retestState.activeQuestions.length, equals(1));
      expect(retestState.activeQuestions.first.id, equals(firstQ.id));

      // Solve correctly now
      notifier.selectOption(firstQ.correctIndex);
      await notifier.submitAnswer();

      // Check that it got removed from mistakes
      final clearedState = container.read(questionProvider);
      expect(clearedState.mistakeQuestionIds, isNot(contains(firstQ.id)));
      expect(storage.getMistakeQuestionIds(), isNot(contains(firstQ.id)));
    });

    test('Manual removeMistake removes question from notebook', () async {
      await storage.recordQuestionAttempt('q_manual_test', false);
      expect(storage.getMistakeQuestionIds(), contains('q_manual_test'));

      final notifier = container.read(questionProvider.notifier);
      await notifier.removeMistake('q_manual_test');

      expect(storage.getMistakeQuestionIds(), isNot(contains('q_manual_test')));
    });

    test('TargetScoreNotifier persists and updates target score', () async {
      expect(container.read(targetScoreProvider), equals(70));

      await container.read(targetScoreProvider.notifier).setScore(85);
      expect(container.read(targetScoreProvider), equals(85));
      expect(storage.getTargetScore(), equals(85));
    });

    test('TargetExamDateNotifier persists and updates exam date', () async {
      final testDate = DateTime(2026, 11, 15);
      await container.read(targetExamDateProvider.notifier).setExamDate(testDate);

      expect(container.read(targetExamDateProvider).year, equals(2026));
      expect(container.read(targetExamDateProvider).month, equals(11));
      expect(storage.getTargetExamDate().year, equals(2026));
    });

    testWidgets('StrategyGuideScreen renders tabs and rules correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StrategyGuideScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('YDS Taktik & Strateji Kartları'), findsOneWidget);
      expect(find.text('Edat & Prepositions'), findsOneWidget);
      expect(find.text('Tense & Zaman Uyumu'), findsOneWidget);
      expect(find.text('Devrik Yapılar (Inversion)'), findsOneWidget);

      // Verify search field exists
      expect(find.byType(TextField), findsOneWidget);

      // Verify some rules are displayed
      expect(find.text('insist on'), findsOneWidget);
    });

    testWidgets('MistakeNotebookScreen renders empty state when no mistakes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: MistakeNotebookScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Akıllı Hata Defteri'), findsOneWidget);
      expect(find.text('Harika! Hata Defteriniz Boş'), findsOneWidget);
      expect(find.text('Soru Bankasına Dön'), findsOneWidget);
    });

    testWidgets('PaywallScreen applies coupon code and recalculates price',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: PaywallScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find coupon textfield and apply button
      expect(find.text('İndirim / Referans Kuponu'), findsOneWidget);

      // Enter coupon YDS2026
      await tester.enterText(find.widgetWithText(TextField, 'Kupon kodu girin (örn: YDS2026)'), 'YDS2026');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Uygula'));
      await tester.pumpAndSettle();

      // Check that 25% discount badge and success text appear
      expect(find.text('%25 İNDİRİM'), findsOneWidget);
      expect(find.textContaining('%25 İndirimle Başla'), findsOneWidget);
    });
  });

  group('7. Branch Exams, Custom Exam Wizard & Detailed Stats Tests', () {
    late LocalStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.init();
    });

    test('getAvailableExams returns both full simulations and branch exams', () {
      final exams = ExamNotifier.getAvailableExams();
      expect(exams.length, greaterThanOrEqualTo(6));

      final branchExams = exams.where((e) => e.id.contains('branch')).toList();
      expect(branchExams.length, greaterThanOrEqualTo(3));

      final vocabGrammar = exams.firstWhere((e) => e.id == 'exam_branch_vocab_grammar');
      expect(vocabGrammar.title, contains('Kelime & Gramer'));
      expect(vocabGrammar.durationMinutes, equals(40));
      expect(vocabGrammar.isPremiumOnly, isFalse);

      final readingBranch = exams.firstWhere((e) => e.id == 'exam_branch_reading');
      expect(readingBranch.title, contains('Okuma & Paragraf'));
      expect(readingBranch.durationMinutes, equals(45));
    });

    test('createCustomExam samples questions from provided pool by category', () {
      final custom = ExamNotifier.createCustomExam(
        title: 'Özel Test Denemesi',
        questionCount: 10,
        durationMinutes: 20,
        categories: [QuestionCategory.vocabulary, QuestionCategory.grammar],
        pool: defaultSeedQuestions,
        difficulty: 'Tümü',
      );

      expect(custom.title, equals('Özel Test Denemesi'));
      expect(custom.durationMinutes, equals(20));
      expect(custom.questions.isNotEmpty, isTrue);
      expect(custom.questions.length, lessThanOrEqualTo(10));
      for (final q in custom.questions) {
        expect(
          [QuestionCategory.vocabulary, QuestionCategory.grammar],
          contains(q.category),
        );
      }
    });

    test('OverallStats computes estimatedScore, letterGrade, and identifies weakestCategory', () {
      final container = ProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );

      final stats = container.read(statsProvider);
      expect(stats.streakDays, greaterThanOrEqualTo(0));
      expect(stats.totalSolved, equals(0));
      expect(stats.letterGrade, equals('Henüz Veri Yok'));
      expect(stats.weakestCategory, isNotNull);
    });

    test('Reading articles pool has 5 comprehensive academic passages', () {
      expect(defaultReadingArticles.length, equals(5));
      final topics = defaultReadingArticles.map((a) => a.topic).toList();
      expect(topics, contains('Tıp & Biyoloji'));
      expect(topics, contains('Ekonomi & Çevre'));
      expect(topics, contains('Tarih & Arkeoloji'));
      expect(topics, contains('Psikoloji & Karar Kuramı'));
      expect(topics, contains('Deniz Biyolojisi & Jeoloji'));

      for (final article in defaultReadingArticles) {
        expect(article.contentEn.isNotEmpty, isTrue);
        expect(article.contentTr.isNotEmpty, isTrue);
        expect(article.vocabulary.isNotEmpty, isTrue);
        expect(article.questions.length, greaterThanOrEqualTo(2));
      }
    });

    testWidgets('DetailedStatsScreen displays performance cards, golden rule and mastery bars',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: DetailedStatsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Performans & Zayıf Halka Analizi'), findsOneWidget);
      expect(find.text('Tahmini YDS Puanı'), findsOneWidget);
      expect(find.textContaining('ÖSYM Bilgisi: YDS\'de yanlışlar doğruyu götürmez'), findsOneWidget);
      expect(find.text('Kategori Bazlı Başarı Analizi'), findsOneWidget);
      expect(find.text('Kelime Bilgisi'), findsOneWidget);
      expect(find.text('Gramer & Dilbilgisi'), findsOneWidget);
    });

    testWidgets('ExamListScreen shows custom exam wizard FAB and branch tab filters',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: ExamListScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('YDS Deneme Sınavları'), findsOneWidget);
      expect(find.text('Özel Sınav Oluştur'), findsOneWidget);
      expect(find.text('Kendi Denemeni Oluştur (Sihirbaz)'), findsOneWidget);
      expect(find.text('Branş Denemeleri'), findsOneWidget);
    });
  });

  group('10. Grammar Study & Personal Question Notes Tests', () {
    late LocalStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.init();
    });

    test('defaultGrammarTopics contains core YDS grammar subjects and content', () {
      expect(defaultGrammarTopics.length, greaterThanOrEqualTo(5));
      final titles = defaultGrammarTopics.map((t) => t.title).toList();
      expect(titles, contains('Tense Uyumu & Zaman Bağlaçları'));
      expect(titles, contains('Bağlaçlar & Geçiş İfadeleri'));
      expect(titles, contains('Modals & Perfect Modals'));
      expect(titles, contains('Koşul Cümleleri & Devrik Şartlar'));
      expect(titles, contains('Kısaltmalar (Participle Reductions)'));

      for (final topic in defaultGrammarTopics) {
        expect(topic.goldenRules.isNotEmpty, isTrue);
        expect(topic.examTraps.isNotEmpty, isTrue);
        expect(topic.keyFormulas.isNotEmpty, isTrue);
        expect(topic.examples.isNotEmpty, isTrue);
        expect(topic.category, isNotNull);
      }
    });

    test('QuestionNotifier handles question note creation, update, and deletion', () async {
      final container = ProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );

      final notifier = container.read(questionProvider.notifier);
      expect(container.read(questionProvider).questionNotes, isEmpty);

      // Save a note
      await notifier.saveQuestionNote('q_test_1', 'By the time + V2 kuralına dikkat et!');
      expect(container.read(questionProvider).questionNotes['q_test_1'], equals('By the time + V2 kuralına dikkat et!'));
      expect(storage.getQuestionNote('q_test_1'), equals('By the time + V2 kuralına dikkat et!'));

      // Update the note
      await notifier.saveQuestionNote('q_test_1', 'Güncellenmiş kural notu.');
      expect(container.read(questionProvider).questionNotes['q_test_1'], equals('Güncellenmiş kural notu.'));

      // Delete the note
      await notifier.deleteQuestionNote('q_test_1');
      expect(container.read(questionProvider).questionNotes.containsKey('q_test_1'), isFalse);
      expect(storage.getQuestionNote('q_test_1'), isNull);
    });

    testWidgets('GrammarStudyScreen renders topics, rules, and search bar',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: GrammarStudyScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('YDS Gramer Rehberi & Notlar'), findsOneWidget);
      expect(find.text('YDS Altın Gramer Kuralları'), findsOneWidget);
      expect(find.text('Tense Uyumu & Zaman Bağlaçları'), findsOneWidget);
      expect(find.text('Bağlaçlar & Geçiş İfadeleri'), findsOneWidget);

      // Tap on a topic card to expand
      await tester.tap(find.text('Tense Uyumu & Zaman Bağlaçları'));
      await tester.pumpAndSettle();

      expect(find.text('Altın Kurallar'), findsOneWidget);
      expect(find.text('Kritik Sınav Formülleri'), findsOneWidget);
      expect(find.text('ÖSYM Çeldirici Tuzakları'), findsOneWidget);
    });

    testWidgets('QuestionNotesScreen renders empty state and populated state',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // 1. Empty state
      await tester.pumpWidget(
        ProviderScope(
          key: const ValueKey('notes_empty_scope'),
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: QuestionNotesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kişisel Soru Notlarım'), findsOneWidget);
      expect(find.text('Henüz Bir Soruya Not Eklemediniz'), findsOneWidget);

      // 2. Add note to a real seed question
      final seedQ = defaultSeedQuestions.first;
      await storage.saveQuestionNote(seedQ.id, 'Önemli kelime: crucial');

      await tester.pumpWidget(
        ProviderScope(
          key: const ValueKey('notes_populated_scope'),
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: QuestionNotesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Önemli kelime: crucial'), findsOneWidget);
      expect(find.text('Soruyu İncele & Çöz'), findsOneWidget);
    });

    testWidgets('HomeScreen displays Word of the Day and new Study Module cards',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: MaterialApp(
            home: HomeScreen(onTabChange: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Günün YDS Kelimesi'), findsOneWidget);
      expect(find.text('YDS Gramer Rehberi'), findsOneWidget);
      expect(find.text('Kişisel Soru Notlarım'), findsOneWidget);
      expect(find.text('Edat & Kolokasyon Lab'), findsOneWidget);
    });
  });

  group('11. Speed Reading WPM & Collocation Lab Tests', () {
    late LocalStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.init();
    });

    test('defaultCollocations contains essential YDS prepositions and valid data', () {
      expect(defaultCollocations.length, greaterThanOrEqualTo(25));
      final preps = defaultCollocations.map((c) => c.preposition).toSet();
      expect(preps, containsAll(['on', 'to', 'from', 'of', 'with', 'in', 'for', 'about']));

      for (final col in defaultCollocations) {
        expect(col.word.isNotEmpty, isTrue);
        expect(col.preposition.isNotEmpty, isTrue);
        expect(col.meaningTr.isNotEmpty, isTrue);
        expect(col.exampleSentence.isNotEmpty, isTrue);
        expect(col.tip.isNotEmpty, isTrue);
        expect(col.fullPhrase, equals('${col.word} ${col.preposition}'));
      }
    });

    testWidgets('ReadingDetailScreen renders speed reading card and measures WPM',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: MaterialApp(
            home: ReadingDetailScreen(article: defaultReadingArticles.first),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('YDS Okuma Hızı & WPM Kronometresi'), findsOneWidget);
      expect(find.text('Okumayı Başlat (Süre Ölç)'), findsOneWidget);

      // Start timing
      await tester.tap(find.text('Okumayı Başlat (Süre Ölç)'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Metni Bitirdim • Hızımı Hesapla'), findsOneWidget);

      // Finish timing
      await tester.tap(find.text('Metni Bitirdim • Hızımı Hesapla'));
      await tester.pumpAndSettle();

      expect(find.textContaining('sn sürdü'), findsOneWidget);
      expect(find.text('Yeniden Ölç'), findsOneWidget);
    });

    testWidgets('CollocationQuizScreen renders Library tab, filters and answers quiz question',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: CollocationQuizScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('YDS Edat & Kolokasyon Laboratuvarı'), findsOneWidget);
      expect(find.text('Kütüphane'), findsOneWidget);
      expect(find.text('Edat Quizi'), findsOneWidget);
      expect(find.text('rely'), findsWidgets);

      // Switch to Quiz Tab
      await tester.tap(find.text('Edat Quizi'));
      await tester.pumpAndSettle();

      expect(find.text('Cümledeki boşluğa hangi edat (preposition) gelmelidir?'), findsOneWidget);

      // Tap any option (inkwell)
      final optionFinder = find.byType(InkWell);
      expect(optionFinder, findsWidgets);
      await tester.tap(optionFinder.first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Doğru Kalıp:'), findsOneWidget);
      expect(find.text('Sonraki Soruya Geç'), findsOneWidget);
    });
  });

  group('12. Phrasal Verbs & Exam Pacing Tests', () {
    late LocalStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.init();
    });

    test('defaultPhrasalVerbs contains essential high-frequency YDS phrasal verbs', () {
      expect(defaultPhrasalVerbs.length, greaterThanOrEqualTo(25));
      for (final pv in defaultPhrasalVerbs) {
        expect(pv.id.isNotEmpty, isTrue);
        expect(pv.verb.isNotEmpty, isTrue);
        expect(pv.particles.isNotEmpty, isTrue);
        expect(pv.turkish.isNotEmpty, isTrue);
        expect(pv.exampleSentence.isNotEmpty, isTrue);
        expect(pv.exampleTranslation.isNotEmpty, isTrue);
        expect(pv.osymTrapWarning.isNotEmpty, isTrue);
      }
    });

    testWidgets('PhrasalVerbsScreen renders library, filter chips, and interactive quiz',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: PhrasalVerbsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('YDS Phrasal Verbs Atölyesi'), findsOneWidget);
      expect(find.text('Deyimsel Fiiller'), findsOneWidget);
      expect(find.text('Phrasal Verb Quizi'), findsOneWidget);
      expect(find.text('carry out'), findsWidgets);

      // Filter by chip "out"
      await tester.tap(find.widgetWithText(FilterChip, 'out'));
      await tester.pumpAndSettle();
      expect(find.text('carry out'), findsWidgets);

      // Switch to Quiz tab
      await tester.tap(find.text('Phrasal Verb Quizi'));
      await tester.pumpAndSettle();

      expect(find.text('Cümledeki boşluğa hangi deyimsel fiil (phrasal verb) gelmelidir?'), findsOneWidget);

      // Answer question by tapping an option
      final inkWells = find.byType(InkWell);
      expect(inkWells, findsWidgets);
      await tester.tap(inkWells.first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Doğru Kalıp:'), findsOneWidget);
      expect(find.text('Sonraki Soruya Geç'), findsOneWidget);
    });

    testWidgets('ExamResultScreen renders score, percentile analysis and mistake review button',
        (WidgetTester tester) async {
      final mockResult = ExamResult(
        id: 'res_1',
        examId: 'exam_mock',
        examTitle: 'Örnek YDS Denemesi',
        totalQuestions: 80,
        correctCount: 72,
        wrongCount: 8,
        emptyCount: 0,
        score: 90.0,
        letterGrade: 'A',
        userAnswers: const {'q1': 0},
        timeSpentSeconds: 9600,
        completedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ExamResultScreen(result: mockResult),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ÖSYM Sınav Sonuç Belgesi'), findsOneWidget);
      expect(find.text('90.0'), findsOneWidget);
      expect(find.textContaining('YDS Seviyesi: A'), findsOneWidget);
      expect(find.text('ÖSYM Tahmini Başarı Sıralaması'), findsOneWidget);
      expect(find.textContaining('İlk %2\'lik Dilim'), findsOneWidget);
      expect(find.text('8 Yanlışı Hata Defterinde İncele'), findsOneWidget);
    });

    testWidgets('ExamActiveScreen renders pacing meter when exam is active',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );
      addTearDown(container.dispose);

      final exam = Exam(
        id: 'test_exam',
        title: 'Deneme Testi',
        description: 'Test',
        durationMinutes: 10,
        questions: defaultSeedQuestions.take(5).toList(),
      );

      container.read(examStateProvider.notifier).startExam(exam);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ExamActiveScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Soru Süresi: 00:00'), findsOneWidget);
      expect(find.text('ÖSYM Hedefi: ~2:15 dk/soru'), findsOneWidget);
      expect(find.text('Soru 1 / 5'), findsOneWidget);

      container.read(examStateProvider.notifier).cancelExam();
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });
  });

  group('13. Paragraph Cohesion Lab & Interactive OMR Tests', () {
    late LocalStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.init();
    });

    test('defaultCohesionDrills contains authentic YDS cohesion exercises with tactics', () {
      expect(defaultCohesionDrills.length, greaterThanOrEqualTo(5));
      for (final drill in defaultCohesionDrills) {
        expect(drill.id.isNotEmpty, isTrue);
        expect(drill.title.isNotEmpty, isTrue);
        expect(drill.passage.isNotEmpty, isTrue);
        expect(drill.options.length, equals(5));
        expect(drill.correctIndex, inInclusiveRange(0, 4));
        expect(drill.keyClues.isNotEmpty, isTrue);
        expect(drill.tacticExplanation.isNotEmpty, isTrue);
        expect(drill.translation.isNotEmpty, isTrue);
      }
    });

    testWidgets('CohesionLabScreen renders tactics, toggles clues, and answers drill',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: CohesionLabScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Metin Bütünlüğü & Akış Laboratuvarı'), findsOneWidget);
      expect(find.text('ÖSYM Taktik Sırları'), findsOneWidget);
      expect(find.text('İnteraktif Soru Çözücü'), findsOneWidget);
      expect(find.textContaining('Zamir & Gönderim İfadeleri'), findsOneWidget);

      // Switch to Practice Tab
      await tester.tap(find.text('İnteraktif Soru Çözücü'));
      await tester.pumpAndSettle();

      expect(find.text('Kentsel Isı Adaları ve Yeşil Çatılar'), findsOneWidget);
      expect(find.text('İpuçlarını Göster'), findsOneWidget);

      // Toggle clue highlighting
      await tester.tap(find.text('İpuçlarını Göster'));
      await tester.pumpAndSettle();
      expect(find.text('İpuçlarını Gizle'), findsOneWidget);

      // Select an option
      await tester.tap(find.text('D) IV'));
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text('Cevabı Onayla & Taktik Analizi Gör'));
      await tester.pumpAndSettle();

      expect(find.text('Harika! Doğru Seçim'), findsOneWidget);
      expect(find.textContaining('Zamir & Konu Bütünlüğü Takibi'), findsOneWidget);
      expect(find.text('Sonraki Soru'), findsOneWidget);
    });

    testWidgets('ExamActiveScreen renders and interacts with ÖSYM Optik Form',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );

      final exam = Exam(
        id: 'optik_exam',
        title: 'Optik Deneme Sınavı',
        description: 'Test',
        durationMinutes: 10,
        questions: defaultSeedQuestions.take(5).toList(),
      );

      container.read(examStateProvider.notifier).startExam(exam);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ExamActiveScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open Question Sheet / Optik Form
      await tester.tap(find.text('Soru Haritası'));
      await tester.pumpAndSettle();

      expect(find.text('ÖSYM Optik Form'), findsOneWidget);

      // Switch to Optik Form tab
      await tester.tap(find.text('ÖSYM Optik Form'));
      await tester.pumpAndSettle();

      expect(find.text('1.'), findsOneWidget);
      expect(find.text('A'), findsWidgets);
      expect(find.text('B'), findsWidgets);

      // Mark bubble 'B' for question 1
      await tester.tap(find.text('B').first);
      await tester.pumpAndSettle();

      expect(container.read(examStateProvider)?.userAnswers[exam.questions.first.id], equals(1));

      // Close modal
      tester.state<NavigatorState>(find.byType(Navigator).last).pop();
      await tester.pumpAndSettle();

      container.read(examStateProvider.notifier).cancelExam();
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });
  });
}



