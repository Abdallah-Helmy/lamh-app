import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:lamh/core/theme/app_colors.dart';

enum LiquidGlassVariant {
  /// Toolbar / tab bar material — stronger frost, adaptive tint.
  regular,

  /// Floating controls / selection — clearer, more refractive look.
  clear,
}

/// Multi-layer Liquid Glass surface approximating Apple iOS 26 material:
/// backdrop blur + vibrancy tint + specular highlight + rim lighting + depth.
class LiquidGlass extends StatefulWidget {
  const LiquidGlass({
    super.key,
    required this.child,
    this.variant = LiquidGlassVariant.regular,
    this.borderRadius = const BorderRadius.all(Radius.circular(34)),
    this.padding,
    this.lightAlignment = const Alignment(-0.55, -0.85),
    this.enableSpecularMotion = true,
    this.thickness = 1.0,
  });

  final Widget child;
  final LiquidGlassVariant variant;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;

  /// Directional light for the specular lobe (updates while dragging).
  final Alignment lightAlignment;
  final bool enableSpecularMotion;

  /// 0.8–1.2 scales blur/tint intensity.
  final double thickness;

  @override
  State<LiquidGlass> createState() => _LiquidGlassState();
}

class _LiquidGlassState extends State<LiquidGlass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
    if (widget.enableSpecularMotion) {
      _shimmer.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant LiquidGlass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enableSpecularMotion && !_shimmer.isAnimating) {
      _shimmer.repeat(reverse: true);
    } else if (!widget.enableSpecularMotion && _shimmer.isAnimating) {
      _shimmer.stop();
    }
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isClear = widget.variant == LiquidGlassVariant.clear;
    final blur = (isClear ? 34.0 : 52.0) * widget.thickness;
    final tint = isClear ? colors.glassClearTint : colors.glassTint;
    final fill = isClear
        ? colors.glassFillClear
        : colors.glassTintDark.withValues(alpha: 0.38);

    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, child) {
        final idle = widget.enableSpecularMotion
            ? Alignment.lerp(
                const Alignment(-0.75, -0.95),
                const Alignment(0.7, -0.55),
                Curves.easeInOut.transform(_shimmer.value),
              )!
            : widget.lightAlignment;

        final light = Alignment.lerp(idle, widget.lightAlignment, 0.65)!;

        return CustomPaint(
          painter: _GlassShadowPainter(borderRadius: widget.borderRadius),
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blur,
                sigmaY: blur,
                tileMode: TileMode.clamp,
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: widget.borderRadius,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            tint,
                            fill,
                            fill.withValues(alpha: isClear ? 0.18 : 0.5),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: widget.borderRadius,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white
                                .withValues(alpha: isClear ? 0.2 : 0.14),
                            Colors.transparent,
                            Colors.black
                                .withValues(alpha: isClear ? 0.14 : 0.24),
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: widget.borderRadius,
                        gradient: RadialGradient(
                          center: light,
                          radius: 1.2,
                          colors: [
                            colors.glassSpecular
                                .withValues(alpha: isClear ? 0.48 : 0.3),
                            colors.glassSpecular.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.3, 0.72],
                        ),
                      ),
                    ),
                  ),
                  ?child,
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _GlassRimPainter(
                          borderRadius: widget.borderRadius,
                          light: light,
                          clear: isClear,
                          colors: colors,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: widget.padding == null
          ? widget.child
          : Padding(padding: widget.padding!, child: widget.child),
    );
  }
}

class _GlassShadowPainter extends CustomPainter {
  _GlassShadowPainter({required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = borderRadius.toRRect(Offset.zero & size);

    final ambient = Paint()
      ..color = Colors.black.withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
    canvas.drawRRect(rrect.shift(const Offset(0, 12)), ambient);

    final contact = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawRRect(rrect.shift(const Offset(0, 4)), contact);

    final halo = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawRRect(rrect.inflate(0.8), halo);
  }

  @override
  bool shouldRepaint(covariant _GlassShadowPainter oldDelegate) =>
      oldDelegate.borderRadius != borderRadius;
}

class _GlassRimPainter extends CustomPainter {
  _GlassRimPainter({
    required this.borderRadius,
    required this.light,
    required this.clear,
    required this.colors,
  });

  final BorderRadius borderRadius;
  final Alignment light;
  final bool clear;
  final AppColorScheme colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = borderRadius.toRRect(Offset.zero & size).deflate(0.5);

    final rimShader = LinearGradient(
      begin: Alignment(light.x, light.y),
      end: Alignment(-light.x, -light.y * 0.35),
      colors: [
        colors.glassRimLight.withValues(alpha: clear ? 0.75 : 0.58),
        colors.glassStroke,
        colors.glassRimShadow.withValues(alpha: clear ? 0.28 : 0.42),
      ],
      stops: const [0.0, 0.48, 1.0],
    ).createShader(Offset.zero & size);

    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = clear ? 1.15 : 1.05
        ..shader = rimShader,
    );

    canvas.drawRRect(
      rrect.deflate(1.15),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.7
        ..color = Colors.white.withValues(alpha: clear ? 0.24 : 0.14),
    );
  }

  @override
  bool shouldRepaint(covariant _GlassRimPainter oldDelegate) =>
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.light != light ||
      oldDelegate.clear != clear ||
      oldDelegate.colors != colors;
}
