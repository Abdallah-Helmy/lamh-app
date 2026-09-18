import 'package:flutter/material.dart';
import 'package:lamh/core/theme/app_colors.dart';
import 'package:lamh/presentation/components/app_svg_icon.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class TabPlaceholderPage extends StatelessWidget {
  const TabPlaceholderPage({
    super.key,
    required this.title,
    required this.iconAsset,
  });

  final String title;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: GlassCard(
        quality: GlassQuality.standard,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvgIcon(iconAsset, size: 56, color: colors.onGlass),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colors.onGlass,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
