import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Lamh Design System — flat Light / Dark tokens.
///
/// Rules:
/// - Page backgrounds are solid colors (no gradients / glow orbs).
/// - Glass is reserved for chrome and controls, not full-screen fills.
/// - [primary] is the brand accent in both modes.
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.brightness,
    // Canvas
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.splashBackground,
    // Brand
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
    // Content
    required this.onGlass,
    required this.onGlassMuted,
    required this.onGlassFaint,
    // Borders
    required this.glassStroke,
    required this.glassStrokeSoft,
    // Glass material
    required this.glassTint,
    required this.glassTintDark,
    required this.glassClearTint,
    required this.glassFillClear,
    required this.glassBarColor,
    required this.glassRimLight,
    required this.glassRimShadow,
    required this.glassSpecular,
    // Semantic
    required this.success,
    required this.warning,
    required this.error,
    // System chrome
    required this.systemOverlayStyle,
    required this.glassStatusBarStyle,
  });

  final Brightness brightness;

  /// Solid page / scaffold canvas.
  final Color background;

  /// Cards, sheets, elevated panels.
  final Color surface;

  /// Nested surfaces on top of [surface].
  final Color surfaceElevated;

  /// Splash-only canvas (logo plate).
  final Color splashBackground;

  /// Brand accent (buttons, links, active indicators).
  final Color primary;

  /// Text / icons on [primary].
  final Color onPrimary;

  /// Soft brand wash for subtle fills.
  final Color primarySoft;

  /// Primary text / icons on glass & canvas.
  final Color onGlass;

  /// Secondary text.
  final Color onGlassMuted;

  /// Tertiary / placeholder text.
  final Color onGlassFaint;

  /// Strong hairline / field border.
  final Color glassStroke;

  /// Soft separator.
  final Color glassStrokeSoft;

  final Color glassTint;
  final Color glassTintDark;
  final Color glassClearTint;
  final Color glassFillClear;
  final Color glassBarColor;
  final Color glassRimLight;
  final Color glassRimShadow;
  final Color glassSpecular;

  final Color success;
  final Color warning;
  final Color error;

  final SystemUiOverlayStyle systemOverlayStyle;
  final GlassStatusBarStyle glassStatusBarStyle;

  bool get isDark => brightness == Brightness.dark;

  /// Alias kept for Material [ColorScheme.fromSeed] callers.
  Color get seedColor => primary;

  /// Visible liquid-glass settings for buttons / chips / switches.
  LiquidGlassSettings get controlGlass => LiquidGlassSettings(
        blur: isDark ? 16 : 20,
        thickness: isDark ? 14 : 22,
        glassColor: glassBarColor,
        lightIntensity: isDark ? 0.55 : 0.95,
        ambientStrength: isDark ? 0.05 : 0.22,
        refractiveIndex: isDark ? 1.2 : 1.24,
        saturation: isDark ? 1.15 : 1.2,
        chromaticAberration: isDark ? 0.012 : 0.03,
        fresnelStrength: isDark ? 1.0 : 1.25,
        bodyMode: GlassBodyMode.clear,
      );

  /// Grouped input fields (email / password stacks).
  LiquidGlassSettings get fieldGlass => LiquidGlassSettings(
        blur: isDark ? 16 : 18,
        thickness: isDark ? 16 : 20,
        glassColor: glassBarColor,
        lightIntensity: isDark ? 0.55 : 0.9,
        ambientStrength: isDark ? 0.04 : 0.18,
        refractiveIndex: 1.22,
        saturation: isDark ? 1.1 : 1.15,
        chromaticAberration: isDark ? 0.01 : 0.025,
        bodyMode: GlassBodyMode.clear,
      );

  // ── Light ────────────────────────────────────────────────────────────────

  static const light = AppColorScheme(
    brightness: Brightness.light,
    background: Color(0xFFF5F6F8),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFEEF0F4),
    splashBackground: Color(0xFFFFFFFF),
    primary: Color(0xFF7C3AED),
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0x1A7C3AED),
    onGlass: Color(0xFF12141A),
    onGlassMuted: Color(0x9912141A),
    onGlassFaint: Color(0x6612141A),
    glassStroke: Color(0x3D12141A),
    glassStrokeSoft: Color(0x2412141A),
    glassTint: Color(0x99FFFFFF),
    glassTintDark: Color(0x1A12141A),
    glassClearTint: Color(0x55FFFFFF),
    glassFillClear: Color(0x26FFFFFF),
    // Cool translucent tint — opaque white kills refraction on light canvases.
    glassBarColor: Color.fromRGBO(210, 220, 240, 0.42),
    glassRimLight: Color(0xCCFFFFFF),
    glassRimShadow: Color(0x2612141A),
    glassSpecular: Color(0xB3FFFFFF),
    success: Color(0xFF16A34A),
    warning: Color(0xFFD97706),
    error: Color(0xFFDC2626),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFF5F6F8),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    glassStatusBarStyle: GlassStatusBarStyle.dark,
  );

  // ── Dark ─────────────────────────────────────────────────────────────────

  static const dark = AppColorScheme(
    brightness: Brightness.dark,
    background: Color(0xFF0C0E12),
    surface: Color(0xFF161A22),
    surfaceElevated: Color(0xFF1E2430),
    splashBackground: Color(0xFFFFFFFF),
    primary: Color(0xFF8B5CF6),
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0x338B5CF6),
    onGlass: Color(0xFFF4F5F7),
    onGlassMuted: Color(0x99F4F5F7),
    onGlassFaint: Color(0x66F4F5F7),
    glassStroke: Color(0x33FFFFFF),
    glassStrokeSoft: Color(0x1AFFFFFF),
    glassTint: Color(0x2EFFFFFF),
    glassTintDark: Color(0x33101822),
    glassClearTint: Color(0x18FFFFFF),
    glassFillClear: Color(0x14FFFFFF),
    glassBarColor: Color.fromRGBO(255, 255, 255, 0.07),
    glassRimLight: Color(0x66FFFFFF),
    glassRimShadow: Color(0x33000000),
    glassSpecular: Color(0x59FFFFFF),
    success: Color(0xFF22C55E),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0C0E12),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
    glassStatusBarStyle: GlassStatusBarStyle.light,
  );

  @override
  AppColorScheme copyWith({
    Brightness? brightness,
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? splashBackground,
    Color? primary,
    Color? onPrimary,
    Color? primarySoft,
    Color? onGlass,
    Color? onGlassMuted,
    Color? onGlassFaint,
    Color? glassStroke,
    Color? glassStrokeSoft,
    Color? glassTint,
    Color? glassTintDark,
    Color? glassClearTint,
    Color? glassFillClear,
    Color? glassBarColor,
    Color? glassRimLight,
    Color? glassRimShadow,
    Color? glassSpecular,
    Color? success,
    Color? warning,
    Color? error,
    SystemUiOverlayStyle? systemOverlayStyle,
    GlassStatusBarStyle? glassStatusBarStyle,
  }) {
    return AppColorScheme(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      splashBackground: splashBackground ?? this.splashBackground,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primarySoft: primarySoft ?? this.primarySoft,
      onGlass: onGlass ?? this.onGlass,
      onGlassMuted: onGlassMuted ?? this.onGlassMuted,
      onGlassFaint: onGlassFaint ?? this.onGlassFaint,
      glassStroke: glassStroke ?? this.glassStroke,
      glassStrokeSoft: glassStrokeSoft ?? this.glassStrokeSoft,
      glassTint: glassTint ?? this.glassTint,
      glassTintDark: glassTintDark ?? this.glassTintDark,
      glassClearTint: glassClearTint ?? this.glassClearTint,
      glassFillClear: glassFillClear ?? this.glassFillClear,
      glassBarColor: glassBarColor ?? this.glassBarColor,
      glassRimLight: glassRimLight ?? this.glassRimLight,
      glassRimShadow: glassRimShadow ?? this.glassRimShadow,
      glassSpecular: glassSpecular ?? this.glassSpecular,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      systemOverlayStyle: systemOverlayStyle ?? this.systemOverlayStyle,
      glassStatusBarStyle: glassStatusBarStyle ?? this.glassStatusBarStyle,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      brightness: t < 0.5 ? brightness : other.brightness,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      splashBackground:
          Color.lerp(splashBackground, other.splashBackground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      onGlass: Color.lerp(onGlass, other.onGlass, t)!,
      onGlassMuted: Color.lerp(onGlassMuted, other.onGlassMuted, t)!,
      onGlassFaint: Color.lerp(onGlassFaint, other.onGlassFaint, t)!,
      glassStroke: Color.lerp(glassStroke, other.glassStroke, t)!,
      glassStrokeSoft: Color.lerp(glassStrokeSoft, other.glassStrokeSoft, t)!,
      glassTint: Color.lerp(glassTint, other.glassTint, t)!,
      glassTintDark: Color.lerp(glassTintDark, other.glassTintDark, t)!,
      glassClearTint: Color.lerp(glassClearTint, other.glassClearTint, t)!,
      glassFillClear: Color.lerp(glassFillClear, other.glassFillClear, t)!,
      glassBarColor: Color.lerp(glassBarColor, other.glassBarColor, t)!,
      glassRimLight: Color.lerp(glassRimLight, other.glassRimLight, t)!,
      glassRimShadow: Color.lerp(glassRimShadow, other.glassRimShadow, t)!,
      glassSpecular: Color.lerp(glassSpecular, other.glassSpecular, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      systemOverlayStyle:
          t < 0.5 ? systemOverlayStyle : other.systemOverlayStyle,
      glassStatusBarStyle:
          t < 0.5 ? glassStatusBarStyle : other.glassStatusBarStyle,
    );
  }
}

/// Named palette presets — switch via [ThemeMode].
abstract final class AppColors {
  static const light = AppColorScheme.light;
  static const dark = AppColorScheme.dark;
  static const splashBackground = Color(0xFFFFFFFF);
}

extension AppColorSchemeContext on BuildContext {
  AppColorScheme get appColors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.light;
}
