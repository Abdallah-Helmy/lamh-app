import 'package:go_router/go_router.dart';
import 'package:lamh/core/router/app_routes.dart';
import 'package:lamh/core/router/cupertino_page.dart';
import 'package:lamh/presentation/pages/home.dart';
import 'package:lamh/presentation/pages/login.dart';
import 'package:lamh/presentation/pages/onboarding_page.dart';
import 'package:lamh/presentation/pages/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) =>
          buildCupertinoPage(state, const SplashScreen()),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) =>
          buildCupertinoPage(state, const OnboardingPage()),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) =>
          buildCupertinoPage(state, const LoginPage()),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) =>
          buildCupertinoPage(state, const Home()),
    ),
  ],
);
