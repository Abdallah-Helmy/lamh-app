import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:lamh/core/theme/app_fonts.dart';
import 'package:lamh/presentation/components/app_svg_icon.dart';
import 'package:lamh/presentation/components/liquid_glass.dart';

class NavTabItem {
  const NavTabItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });

  final String label;
  final String icon;
  final String? activeIcon;
}

/// Frosted tab bar with a refractive liquid-glass lens that morphs while swiping.
class LiquidGlassBottomNav extends StatelessWidget {
  const LiquidGlassBottomNav({
    super.key,
    required this.items,
    required this.page,
    required this.onChanged,
    this.onDragUpdate,
    this.onDragEnd,
  });

  final List<NavTabItem> items;
  final double page;
  final ValueChanged<int> onChanged;

  /// Called while dragging on the bar: (deltaDx, itemWidth).
  final void Function(double deltaDx, double itemWidth)? onDragUpdate;
  final GestureDragEndCallback? onDragEnd;

  static const double _barHeight = 76;
  static const double _pad = 6;

  @override
  Widget build(BuildContext context) {
    final drag = (page - page.roundToDouble()).abs();
    // Peaks at mid-swipe — drives liquid stretch + stronger refraction.
    final liquid = math.sin(drag * math.pi);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.38),
                blurRadius: 28,
                offset: const Offset(0, 14),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.04),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: LiquidGlass(
            variant: LiquidGlassVariant.regular,
            borderRadius: BorderRadius.circular(40),
            lightAlignment: Alignment(-0.35 + page * 0.08, -0.9),
            thickness: 1.12,
            enableSpecularMotion: false,
            child: SizedBox(
              height: _barHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth = constraints.maxWidth;
                  final itemWidth = barWidth / items.length;
                  final isRtl =
                      Directionality.of(context) == TextDirection.rtl;
                  final visualProgress =
                      isRtl ? (items.length - 1) - page : page;

                  final baseWidth = itemWidth - (_pad * 2);
                  final baseHeight = _barHeight - (_pad * 2);

                  // Liquid morph: elongates toward the next tab mid-swipe.
                  final stretch = 1.0 + liquid * 0.72;
                  final squash = 1.0 - liquid * 0.12;
                  final indicatorWidth =
                      (baseWidth * stretch).clamp(0.0, barWidth - _pad * 2);
                  final indicatorHeight = baseHeight * squash;

                  final centerX =
                      visualProgress * itemWidth + itemWidth / 2;
                  final left = (centerX - indicatorWidth / 2).clamp(
                    _pad,
                    barWidth - _pad - indicatorWidth,
                  );
                  final top = (_barHeight - indicatorHeight) / 2;

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragUpdate: onDragUpdate == null
                        ? null
                        : (details) {
                            onDragUpdate!(details.delta.dx, itemWidth);
                          },
                    onHorizontalDragEnd: onDragEnd,
                    child: Stack(
                      children: [
                        Positioned(
                          left: left,
                          top: top,
                          width: indicatorWidth,
                          height: indicatorHeight,
                          child: _LiquidGlassLens(intensity: liquid),
                        ),
                        Row(
                          children: [
                            for (var i = 0; i < items.length; i++)
                              Expanded(
                                child: _NavTabButton(
                                  item: items[i],
                                  emphasis: (1.0 - (page - i).abs())
                                      .clamp(0.0, 1.0),
                                  onTap: () => onChanged(i),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Refractive liquid lens: frost + chromatic rim, intensifies while dragging.
class _LiquidGlassLens extends StatelessWidget {
  const _LiquidGlassLens({required this.intensity});

  final double intensity;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);
    final frost = 0.12 + intensity * 0.10;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18 + intensity * 14,
          sigmaY: 18 + intensity * 14,
          tileMode: TileMode.clamp,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.22 + frost),
                    Colors.white.withValues(alpha: 0.10 + frost * 0.4),
                    Colors.white.withValues(alpha: 0.05 + frost * 0.2),
                  ],
                ),
              ),
            ),
            // Soft top caustic / specular.
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: const Alignment(0, 0.35),
                  colors: [
                    Colors.white.withValues(alpha: 0.28 + intensity * 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Inner lens shading (thick glass volume).
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: RadialGradient(
                  center: const Alignment(0, -0.15),
                  radius: 0.95,
                  colors: [
                    Colors.white.withValues(alpha: 0.06),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.12 + intensity * 0.08),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            CustomPaint(
              painter: _ChromaticRimPainter(intensity: intensity),
            ),
          ],
        ),
      ),
    );
  }
}

/// Iridescent edge like thick glass / soap-bubble refraction.
class _ChromaticRimPainter extends CustomPainter {
  _ChromaticRimPainter({required this.intensity});

  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.shortestSide / 2),
    ).deflate(0.6);

    final glow = 0.35 + intensity * 0.45;

    // Soft outer luminous halo.
    canvas.drawRRect(
      rrect.inflate(1.2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..color = Colors.white.withValues(alpha: 0.08 + intensity * 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Chromatic aberration ring (warm → cool around the rim).
    final shader = SweepGradient(
      startAngle: -math.pi / 2,
      colors: [
        Color.fromRGBO(255, 120, 90, glow * 0.55),
        Color.fromRGBO(255, 220, 120, glow * 0.7),
        Color.fromRGBO(120, 255, 210, glow * 0.55),
        Color.fromRGBO(140, 170, 255, glow * 0.65),
        Color.fromRGBO(210, 140, 255, glow * 0.5),
        Color.fromRGBO(255, 120, 90, glow * 0.55),
      ],
    ).createShader(Offset.zero & size);

    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6 + intensity * 0.8
        ..shader = shader,
    );

    // Bright glass lip.
    canvas.drawRRect(
      rrect.deflate(1.1),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9
        ..color = Colors.white.withValues(alpha: 0.35 + intensity * 0.25),
    );
  }

  @override
  bool shouldRepaint(covariant _ChromaticRimPainter oldDelegate) =>
      oldDelegate.intensity != intensity;
}

class _NavTabButton extends StatelessWidget {
  const _NavTabButton({
    required this.item,
    required this.emphasis,
    required this.onTap,
  });

  final NavTabItem item;
  final double emphasis;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Curves.easeOut.transform(emphasis);
    final color = Color.lerp(
      const Color(0x66E8EAED),
      const Color(0xFFF5F6F8),
      t,
    )!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              // Slight "lens magnification" on the active tab.
              scale: 1.0 + (0.1 * t),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 1.0 - t,
                      child: AppSvgIcon(item.icon, size: 23, color: color),
                    ),
                    Opacity(
                      opacity: t,
                      child: AppSvgIcon(
                        item.activeIcon ?? item.icon,
                        size: 23,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: color,
                fontSize: 11,
                letterSpacing: 0.1,
                fontWeight: FontWeight.lerp(
                  FontWeight.w500,
                  FontWeight.w700,
                  t,
                ),
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
