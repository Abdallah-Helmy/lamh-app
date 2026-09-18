import 'package:flutter/material.dart';
import 'package:lamh/core/assets/app_icons.dart';
import 'package:lamh/core/theme/app_colors.dart';
import 'package:lamh/core/theme/app_tokens.dart';
import 'package:lamh/presentation/components/app_svg_icon.dart';

/// Outlined field used on login and similar forms.
class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.isPasswordField = false,
    this.required = false,
    this.isEnabled = true,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.validator,
  });

  final String labelText;
  final TextEditingController controller;
  final String? hintText;
  final String? prefixIcon;
  final bool isPasswordField;
  final bool required;
  final bool isEnabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  static const _focusColor = Color(0xFF12141A);
  static const _iconSize = 20.0;
  static const _eyeIconSize = 22.0;
  static const _minHeight = 48.0;
  static const _edgeInset = AppSpacing.spacingXL;
  static const _iconGap = AppSpacing.spacingSM;
  static const _eyeEdgeInset = AppSpacing.spacingMD;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const focusColor = CustomTextFormField._focusColor;

    final labelStyle = TextStyle(
      color: colors.onGlass,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.43,
      decoration: TextDecoration.none,
    );

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.glassStroke, width: 1),
    );

    final focusedBorder = border.copyWith(
      borderSide: const BorderSide(color: focusColor, width: 1.2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: widget.required
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: widget.labelText, style: labelStyle),
                      TextSpan(
                        text: ' *',
                        style: labelStyle.copyWith(color: colors.primary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                )
              : Text(
                  widget.labelText,
                  textAlign: TextAlign.right,
                  style: labelStyle,
                ),
        ),
        const SizedBox(height: AppSpacing.spacingMD),
        TextFormField(
          controller: widget.controller,
          enabled: widget.isEnabled,
          obscureText: widget.isPasswordField && _obscurePassword,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          cursorColor: focusColor,
          style: TextStyle(
            color: colors.onGlass,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
            decoration: TextDecoration.none,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: colors.onGlassFaint,
              decoration: TextDecoration.none,
            ),
            errorStyle: TextStyle(
              color: colors.error,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: widget.prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: CustomTextFormField._edgeInset,
                      end: CustomTextFormField._iconGap,
                    ),
                    child: AppSvgIcon(
                      widget.prefixIcon!,
                      size: CustomTextFormField._iconSize,
                      color: colors.onGlassMuted,
                    ),
                  ),
            suffixIcon: widget.isPasswordField
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: CustomTextFormField._eyeEdgeInset,
                      start: CustomTextFormField._iconGap,
                    ),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 40,
                        height: CustomTextFormField._minHeight,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: AppSvgIcon(
                            _obscurePassword
                                ? AppIcons.eye
                                : AppIcons.eyeOff,
                            size: CustomTextFormField._eyeIconSize,
                            color: colors.onGlassMuted,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minHeight: CustomTextFormField._minHeight,
            ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: CustomTextFormField._minHeight,
            ),
            isDense: true,
            filled: true,
            fillColor: colors.surface,
            contentPadding: EdgeInsetsDirectional.fromSTEB(
              0,
              12,
              widget.isPasswordField ? 0 : CustomTextFormField._edgeInset,
              12,
            ),
            enabledBorder: border,
            focusedBorder: focusedBorder,
            errorBorder: border,
            focusedErrorBorder: focusedBorder,
            border: border,
          ),
        ),
      ],
    );
  }
}
