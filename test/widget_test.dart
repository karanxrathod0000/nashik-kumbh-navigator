import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nashik_kumbh_navigator/main.dart';
import 'package:nashik_kumbh_navigator/core/constants/app_constants.dart';

void main() {
  testWidgets('Nashik Kumbh Navigator smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: NashikKumbhApp()));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that the splash screen title loads
    expect(find.text(AppConstants.appName), findsOneWidget);

    // Pump past the 2.8s splash screen timer to avoid pending timers
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}

