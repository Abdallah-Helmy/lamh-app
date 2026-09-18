import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Themed SVG icon from [assets/images/icons].
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
    this.assetPath, {
    super.key,
    this.size,
    this.color,
  });

  final String assetPath;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final resolvedSize = size ?? theme.size ?? 24;
    final resolvedColor = color ?? theme.color ?? Colors.white;

    return SvgPicture.asset(
      assetPath,
      width: resolvedSize,
      height: resolvedSize,
      colorFilter: ColorFilter.mode(resolvedColor, BlendMode.srcIn),
    );
  }
}
