import 'dart:ui';

import 'package:flutter/material.dart';

class LiquidGlassNavigationItem {
  const LiquidGlassNavigationItem({
    required this.icon,
    this.activeIcon,
    this.label,
  });

  final IconData icon;
  final IconData? activeIcon;
  final String? label;
}

class LiquidGlassNavigation extends StatefulWidget {
  const LiquidGlassNavigation({
    super.key,
    required this.items,
    required this.pageController,
    required this.onTap,
    this.height = 68,
    this.horizontalPadding = 8,
    this.borderRadius = 28,
    this.blur = 22,
    this.backgroundOpacity = 0.16,
  });

  final List<LiquidGlassNavigationItem> items;

  /// The same controller used by the PageView.
  final PageController pageController;

  /// Called when a tab is tapped.
  final ValueChanged<int> onTap;

  final double height;
  final double horizontalPadding;
  final double borderRadius;
  final double blur;
  final double backgroundOpacity;

  @override
  State<LiquidGlassNavigation> createState() => _LiquidGlassNavigationState();
}

class _LiquidGlassNavigationState extends State<LiquidGlassNavigation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;

  int? _pressedIndex;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  double _currentPage() {
    if (!widget.pageController.hasClients) {
      return widget.pageController.initialPage.toDouble();
    }

    return widget.pageController.page ??
        widget.pageController.initialPage.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: SizedBox(
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.blur,
                sigmaY: widget.blur,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: isDark
                      ? Colors.white.withValues(
                          alpha: widget.backgroundOpacity * 0.55,
                        )
                      : Colors.white.withValues(
                          alpha: widget.backgroundOpacity,
                        ),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.14)
                        : Colors.white.withValues(alpha: 0.55),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.18 : 0.08,
                      ),
                      blurRadius: 30,
                      spreadRadius: -8,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth =
                        constraints.maxWidth / widget.items.length;

                    return AnimatedBuilder(
                      animation: widget.pageController,
                      builder: (context, child) {
                        final page = _currentPage();

                        final clampedPage = page.clamp(
                          0.0,
                          (widget.items.length - 1).toDouble(),
                        );

                        // Mirror indicator travel for RTL tab order.
                        final visualPage = isRtl
                            ? (widget.items.length - 1) - clampedPage
                            : clampedPage;

                        return Stack(
                          children: [
                            // Moving Liquid Glass (single shared indicator)
                            Positioned(
                              left: visualPage * itemWidth + 4,
                              top: 4,
                              bottom: 4,
                              width: itemWidth - 8,
                              child: _LiquidGlassIndicator(
                                isDark: isDark,
                                radius: widget.borderRadius - 6,
                              ),
                            ),

                            // Tabs
                            Row(
                              children: List.generate(widget.items.length, (
                                index,
                              ) {
                                return Expanded(
                                  child: _NavigationItem(
                                    item: widget.items[index],
                                    index: index,
                                    page: clampedPage,
                                    isPressed: _pressedIndex == index,
                                    onTapDown: () {
                                      setState(() {
                                        _pressedIndex = index;
                                      });

                                      _pressController.forward();
                                    },
                                    onTapUp: () {
                                      setState(() {
                                        _pressedIndex = null;
                                      });

                                      _pressController.reverse();
                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        _pressedIndex = null;
                                      });

                                      _pressController.reverse();
                                    },
                                    onTap: () => widget.onTap(index),
                                  ),
                                );
                              }),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidGlassIndicator extends StatelessWidget {
  const _LiquidGlassIndicator({required this.isDark, required this.radius});

  final bool isDark;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main glass
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Colors.white.withValues(alpha: 0.20),
                          Colors.white.withValues(alpha: 0.08),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.72),
                          Colors.white.withValues(alpha: 0.30),
                        ],
                ),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.24)
                      : Colors.white.withValues(alpha: 0.72),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.06),
                    blurRadius: 14,
                    spreadRadius: -4,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),

            // Top reflection
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withValues(alpha: isDark ? 0.30 : 0.65),
                ),
              ),
            ),

            // Soft reflection
            Positioned(
              top: -25,
              left: -20,
              right: -20,
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.16),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.item,
    required this.index,
    required this.page,
    required this.isPressed,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.onTap,
  });

  final LiquidGlassNavigationItem item;
  final int index;
  final double page;
  final bool isPressed;

  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final distance = (page - index).abs().clamp(0.0, 1.0);

    // 1 = selected
    // 0 = completely inactive
    final activeValue = 1 - distance;

    final iconColor = Color.lerp(
      isDark
          ? Colors.white.withValues(alpha: 0.52)
          : Colors.black.withValues(alpha: 0.45),
      theme.colorScheme.primary,
      activeValue,
    )!;

    final icon = activeValue > 0.5 && item.activeIcon != null
        ? item.activeIcon!
        : item.icon;

    final scale = isPressed ? 0.94 : 0.96 + (activeValue * 0.04);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) {
        onTapUp();
        onTap();
      },
      onTapCancel: onTapCancel,
      child: Center(
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 23, color: iconColor),
              if (item.label != null) ...[
                const SizedBox(height: 3),
                Opacity(
                  opacity: 0.55 + (activeValue * 0.45),
                  child: Text(
                    item.label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: activeValue > 0.5
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: iconColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
