import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lamh/core/theme/theme_controller.dart';
import 'package:lamh/main.dart';
import 'package:lamh/presentation/pages/home.dart';
import 'package:lamh/presentation/pages/login.dart';
import 'package:lamh/presentation/pages/onboarding_page.dart';
import 'package:lamh/presentation/pages/splash_screen.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await LiquidGlassWidgets.initialize();
  });

  testWidgets('Splash → onboarding → login → Home', (tester) async {
    await tester.pumpWidget(
      ThemeScope(
        controller: appThemeController,
        child: ListenableBuilder(
          listenable: appThemeController,
          builder: (context, _) => const Lamh(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('لَمح'), findsWidgets);

    // Advance past splash delay without pumpAndSettle (Lottie loops forever).
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.text('تخطّي'), findsOneWidget);

    await tester.tap(find.text('تخطّي'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);

    await tester.enterText(
      find.byType(EditableText).first,
      'user@lamh.app',
    );
    await tester.enterText(
      find.byType(EditableText).last,
      'password123',
    );
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(GlassTabBar), findsOneWidget);
  });
}
