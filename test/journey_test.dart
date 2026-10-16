import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yds_pro/data/local_storage.dart';
import 'package:yds_pro/data/seed_questions.dart';
import 'package:yds_pro/data/seed_readings.dart';
import 'package:yds_pro/providers/local_storage_provider.dart';
import 'package:yds_pro/providers/question_provider.dart';
import 'package:yds_pro/views/home/home_screen.dart';
import 'package:yds_pro/views/reading/reading_detail_screen.dart';
import 'package:yds_pro/views/grammar/grammar_study_screen.dart';
import 'package:yds_pro/views/collocations/collocation_quiz_screen.dart';
import 'package:yds_pro/views/notes/question_notes_screen.dart';
import 'package:yds_pro/views/stats/detailed_stats_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('📱 Mobile End-to-End User Journeys (YDS Master PRO)', () {
    late LocalStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.init();
    });

    testWidgets('Journey 1: Daily routine with Streak and Word of the Day interaction',
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

      // 1. Verify App Header & Daily Streak
      expect(find.text('YDS Master PRO'), findsOneWidget);
      expect(find.textContaining('Gün'), findsWidgets);

      // 2. Verify Word of the Day Card is present
      expect(find.text('Günün YDS Kelimesi'), findsOneWidget);

      // 3. Mark Word as Learned
      final markLearnedFinder = find.text('Öğrendim');
      if (markLearnedFinder.evaluate().isNotEmpty) {
        await tester.tap(markLearnedFinder);
        await tester.pumpAndSettle();
        expect(find.text('Öğrenildi'), findsOneWidget);
      }
    });

    testWidgets('Journey 2: Academic Reading, Speed Reading WPM and Vocab Sync',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final article = defaultReadingArticles.first;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageProvider.overrideWithValue(storage),
          ],
          child: MaterialApp(
            home: ReadingDetailScreen(article: article),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Check title & WPM Speed Reading Card
      expect(find.text(article.title), findsWidgets);
      expect(find.text('YDS Okuma Hızı & WPM Kronometresi'), findsOneWidget);

      // 2. Start Speed Reading Stopwatch
      await tester.tap(find.text('Okumayı Başlat (Süre Ölç)'));
      await tester.pump(const Duration(seconds: 3));

      // 3. Finish Reading & Calculate WPM
      await tester.tap(find.text('Metni Bitirdim • Hızımı Hesapla'));
      await tester.pumpAndSettle();

      expect(find.textContaining('sn sürdü'), findsOneWidget);
      expect(find.text('Yeniden Ölç'), findsOneWidget);

      // 4. Switch to Vocabulary Highlights Tab
      await tester.tap(find.text('Kritik Kelimeler'));
      await tester.pumpAndSettle();

      expect(find.text(article.vocabulary.first.english), findsOneWidget);
      expect(find.text(article.vocabulary.first.turkish), findsOneWidget);

      // 5. Switch to Comprehension Questions Tab
      await tester.tap(find.text('Sorular'));
      await tester.pumpAndSettle();

      expect(find.textContaining(article.questions.first.questionText), findsOneWidget);
      // Tap an option
      await tester.tap(find.text(article.questions.first.options.first));
      await tester.pumpAndSettle();

      // Submit Question
      await tester.tap(find.text('Cevabı Kontrol Et').first);
      await tester.pumpAndSettle();

      expect(find.text(article.questions.first.explanation), findsOneWidget);
    });

    testWidgets('Journey 3: YDS Grammar Study Library and Exam Traps Inspection',
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

      // Expand topic: Bağlaçlar & Geçiş İfadeleri
      await tester.tap(find.text('Bağlaçlar & Geçiş İfadeleri'));
      await tester.pumpAndSettle();

      expect(find.text('Altın Kurallar'), findsOneWidget);
      expect(find.text('Kritik Sınav Formülleri'), findsOneWidget);
      expect(find.text('ÖSYM Çeldirici Tuzakları'), findsOneWidget);
      expect(find.textContaining('Soru Çöz'), findsOneWidget);
    });

    testWidgets('Journey 4: Preposition & Collocation Lab with Interactive Practice',
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

      // 1. Library tab inspection
      expect(find.text('YDS Edat & Kolokasyon Laboratuvarı'), findsOneWidget);
      expect(find.text('rely'), findsWidgets);

      // 2. Filter by preposition "on"
      await tester.tap(find.widgetWithText(FilterChip, 'on'));
      await tester.pumpAndSettle();
      expect(find.text('rely'), findsWidgets);

      // 3. Switch to Edat Quizi Tab
      await tester.tap(find.text('Edat Quizi'));
      await tester.pumpAndSettle();

      expect(find.text('Cümledeki boşluğa hangi edat (preposition) gelmelidir?'), findsOneWidget);

      // 4. Answer question
      final inkWells = find.byType(InkWell);
      expect(inkWells, findsWidgets);
      await tester.tap(inkWells.first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Doğru Kalıp:'), findsOneWidget);
      expect(find.text('Sonraki Soruya Geç'), findsOneWidget);
    });

    testWidgets('Journey 5: Personal Question Notes and Review integration',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );

      final seedQ = defaultSeedQuestions.first;
      await container.read(questionProvider.notifier).saveQuestionNote(
            seedQ.id,
            'Sınavda bu kalıbı unutma: by the time + past tense!',
          );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: QuestionNotesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kişisel Soru Notlarım'), findsOneWidget);
      expect(find.textContaining('by the time + past tense!'), findsOneWidget);
      expect(find.text('Soruyu İncele & Çöz'), findsOneWidget);
    });

    testWidgets('Journey 6: Performance Radar, Estimated Score, and Weak Link diagnostic',
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
      expect(find.text('Zayıf Halka Tespit Edildi!'), findsOneWidget);
      expect(find.text('Kategori Bazlı Başarı Analizi'), findsOneWidget);
    });
  });
}
