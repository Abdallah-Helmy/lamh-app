import 'package:flutter/material.dart';
import 'package:lamh/core/theme/app_colors.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// iOS-style track green when the switch is on.
const kIosSwitchActiveGreen = Color.fromARGB(255, 0, 0, 0);

/// Glass switch with an iOS-like green active track. Optional [label] renders
/// an RTL-friendly row (switch then label), matching the login remember-me row.
class AppGlassSwitch extends StatelessWidget {
  const AppGlassSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor = kIosSwitchActiveGreen,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final switchWidget = GlassSwitch(
      value: value,
      useOwnLayer: true,
      settings: colors.controlGlass,
      activeColor: activeColor,
      onChanged: onChanged ?? (_) {},
    );

    if (label == null) {
      return switchWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Text(
          label!,
          style: textTheme.bodyMedium?.copyWith(
            color: colors.onGlassMuted,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(width: 9),
         switchWidget,
      ],
    );
  }
}
