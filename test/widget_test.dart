import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yds_pro/data/local_storage.dart';
import 'package:yds_pro/main.dart';
import 'package:yds_pro/providers/local_storage_provider.dart';

void main() {
  testWidgets('YDS Master PRO app loads properly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorage.init();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
        child: const YdsApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the title is rendered
    expect(find.text('YDS Master PRO'), findsOneWidget);
    expect(find.text('Ana Sayfa'), findsOneWidget);
  });
}
