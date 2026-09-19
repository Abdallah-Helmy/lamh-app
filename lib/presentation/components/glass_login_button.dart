import 'package:flutter/material.dart';
import 'package:lamh/core/theme/app_colors.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Prominent dark glass CTA used on auth screens (login, etc.).
class GlassLoginButton extends StatelessWidget {
  const GlassLoginButton({
    super.key,
    required this.onTap,
    this.label = 'تسجيل الدخول',
    this.isLoading = false,
    this.enabled = true,
  });

  static const _blackButtonGlass = Color(0xE612141A);

  final VoidCallback onTap;
  final String label;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final canTap = enabled && !isLoading;

    return GlassButton.custom(
      onTap: onTap,
      enabled: canTap,
      width: double.infinity,
      height: 56,
      useOwnLayer: true,
      style: GlassButtonStyle.prominent,
      settings: colors.controlGlass.copyWith(
        glassColor: _blackButtonGlass,
        thickness: 28,
        blur: 14,
        lightIntensity: 0.7,
        ambientStrength: 0.1,
      ),
      shape: const LiquidRoundedRectangle(
        borderRadius: 28,
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
      
                Text(
                  label,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 9),
                    const Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ],
            ),
    );
  }
}
