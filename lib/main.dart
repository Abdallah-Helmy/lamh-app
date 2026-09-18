import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lamh/core/router/app_router.dart';
import 'package:lamh/core/theme/app_theme.dart';
import 'package:lamh/core/theme/theme_controller.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  appThemeController.applySystemChrome();

  runApp(
    LiquidGlassWidgets.wrap(
      // Keep premium refraction on the tab indicator — adaptive downgrade
      // turns the lens into a flat frosted circle after a few tab switches.
      adaptiveQuality: false,
      respectSystemAccessibility: true,
      brightnessResolver: Theme.maybeBrightnessOf,
      theme: GlassThemeData(
        light: GlassThemeVariant(
          settings: const GlassThemeSettings(
            thickness: 22,
            blur: 16,
            glassColor: Color.fromRGBO(210, 220, 240, 0.42),
            lightIntensity: 0.95,
            ambientStrength: 0.22,
            refractiveIndex: 1.24,
            saturation: 1.2,
            chromaticAberration: 0.03,
            fresnelStrength: 1.25,
          ),
          quality: GlassQuality.standard,
        ),
        dark: GlassThemeVariant(
          settings: const GlassThemeSettings(
            thickness: 14,
            blur: 12,
            glassColor: Color.fromRGBO(255, 255, 255, 0.07),
            lightIntensity: 0.55,
            ambientStrength: 0.05,
            refractiveIndex: 1.2,
            saturation: 1.15,
            chromaticAberration: 0.012,
          ),
          quality: GlassQuality.standard,
        ),
      ),
      child: ThemeScope(
        controller: appThemeController,
        child: ListenableBuilder(
          listenable: appThemeController,
          builder: (context, _) => const Lamh(),
        ),
      ),
    ),
  );
}

class Lamh extends StatelessWidget {
  const Lamh({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'لَمح',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: appThemeController.mode,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: appRouter,
    );
  }
}
