import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamh/core/theme/app_colors.dart';

final appThemeController = ThemeController();

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  AppColorScheme get colors =>
      _mode == ThemeMode.light ? AppColors.light : AppColors.dark;

  void setDarkMode(bool enabled) {
    setMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  void setMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    applySystemChrome();
    notifyListeners();
  }

  void toggle() {
    setMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  void applySystemChrome() {
    SystemChrome.setSystemUIOverlayStyle(colors.systemOverlayStyle);
  }
}

class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    required ThemeController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope not found in widget tree');
    return scope!.notifier!;
  }
}
