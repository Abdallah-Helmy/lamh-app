import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lamh/core/router/app_routes.dart';
import 'package:lamh/core/theme/app_colors.dart';
import 'package:lamh/core/theme/theme_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const _logoAsset = 'assets/images/logo1.png';
  static const _displayDuration = Duration(seconds: 4);
  static const _titleRevealDelay = Duration(milliseconds: 900);

  static const _splashSystemUi = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.splashBackground,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _titleController;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SplashScreen._splashSystemUi);

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _titleFade = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutCubic,
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
    );

    Future<void>.delayed(SplashScreen._titleRevealDelay, () {
      if (!mounted) return;
      _titleController.forward();
    });
    Future<void>.delayed(SplashScreen._displayDuration, _goToOnboarding);
  }

  void _goToOnboarding() {
    if (!mounted) return;
    appThemeController.applySystemChrome();
    context.go(AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SplashScreen._splashSystemUi,
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                SplashScreen._logoAsset,
                width: 160,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
