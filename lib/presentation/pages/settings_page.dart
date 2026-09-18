import 'package:flutter/material.dart';
import 'package:lamh/core/theme/app_tokens.dart';
import 'package:lamh/core/assets/app_icons.dart';
import 'package:lamh/core/theme/app_colors.dart';
import 'package:lamh/core/theme/theme_controller.dart';
import 'package:lamh/presentation/components/app_svg_icon.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeScope.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing3XL,
        AppSpacing.spacingLG,
        AppSpacing.spacing3XL,
        AppSpacing.spacing3XL,
      ),
      child: GlassCard(
        quality: GlassQuality.standard,
        child: _SettingsTile(
          iconAsset: AppIcons.moonStar,
          title: 'الوضع الداكن',
          subtitle: themeController.isDark
              ? 'مفعّل — مظهر داكن مريح للعين'
              : 'معطّل — مظهر فاتح وواضح',
          trailing: Switch(
            value: themeController.isDark,
            onChanged: themeController.setDarkMode,
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String iconAsset;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingMD,
        vertical: AppSpacing.spacingLG,
      ),
      child: Row(
        children: [
          trailing,
          const SizedBox(width: AppSpacing.spacingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onGlass,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: AppSpacing.spacingXXS),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onGlassMuted,
                        decoration: TextDecoration.none,
                      ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.spacingLG),
          AppSvgIcon(iconAsset, size: 24, color: colors.onGlass),
        ],
      ),
    );
  }
}
