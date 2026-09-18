import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lamh/core/theme/app_tokens.dart';
import 'package:lamh/core/assets/app_icons.dart';
import 'package:lamh/core/router/app_routes.dart';
import 'package:lamh/core/theme/app_colors.dart';
import 'package:lamh/presentation/components/app_glass_switch.dart';
import 'package:lamh/presentation/components/custom_text_form_field.dart';
import 'package:lamh/presentation/components/glass_login_button.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const _logoAsset = 'assets/images/logo1.png';
  static const _heroAsset = 'assets/images/login_bg.png';
  static const _heroHeight = 250.0;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      GlassToast.show(
        context,
        message: 'أدخل بريدك وكلمة المرور أولًا',
        type: GlassToastType.warning,
        position: GlassToastPosition.top,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    await Future<void>.delayed(
      const Duration(milliseconds: 600),
    );

    if (!mounted) return;

    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final media = MediaQuery.of(context);
    final keyboardVisible = media.viewInsets.bottom > 0;
    final bottomSafe = media.padding.bottom;
    final topSafe = media.padding.top;

    final sheetOverlap =
        keyboardVisible ? 0.0 : AppSpacing.spacing4XL;
    final topRadius = keyboardVisible ? 0.0 : 32.0;
    final logoSize = keyboardVisible ? 48.0 : 62.0;
    final sheetTopPad = keyboardVisible
        ? topSafe + AppSpacing.spacingMD
        : AppSpacing.spacing3XL;
    final afterLogoGap =
        keyboardVisible ? AppSpacing.spacingMD : AppSpacing.spacingXL;
    final afterSubtitleGap =
        keyboardVisible ? AppSpacing.spacingXL : AppSpacing.spacing3XL;
    final betweenFieldsGap =
        keyboardVisible ? AppSpacing.spacingLG : AppSpacing.spacing2XL;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GlassScaffold(
        statusBarStyle: colors.glassStatusBarStyle,
        contentAwareBrightness: true,
        resizeToAvoidBottomInset: true,
        background: ColoredBox(
          color: colors.background,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                height: keyboardVisible ? 0 : LoginPage._heroHeight,
                width: double.infinity,
                child: keyboardVisible
                    ? const SizedBox.shrink()
                    : Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              LoginPage._heroAsset,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 60,
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      colors.background
                                          .withValues(alpha: 0.75),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final sheetHeight =
                        constraints.maxHeight + sheetOverlap;

                    return Transform.translate(
                      offset: Offset(0, -sheetOverlap),
                      child: SizedBox(
                        height: sheetHeight,
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(topRadius),
                            ),
                            boxShadow: keyboardVisible
                                ? null
                                : [
                                    BoxShadow(
                                      color: colors.glassRimShadow
                                          .withValues(alpha: 0.16),
                                      blurRadius: 30,
                                      spreadRadius: -8,
                                      offset: const Offset(0, -8),
                                    ),
                                  ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(topRadius),
                            ),
                            child: Material(
                              color: colors.surface,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  AppSpacing.spacing3XL,
                                  sheetTopPad,
                                  AppSpacing.spacing3XL,
                                  AppSpacing.spacingNone,
                                ),
                                child: LayoutBuilder(
                                  builder: (context, sheetConstraints) {
                                    return SingleChildScrollView(
                                      physics:
                                          const BouncingScrollPhysics(),
                                      keyboardDismissBehavior:
                                          ScrollViewKeyboardDismissBehavior
                                              .onDrag,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight:
                                              sheetConstraints.maxHeight,
                                        ),
                                        child: IntrinsicHeight(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Center(
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 180,
                                                  ),
                                                  width: logoSize,
                                                  height: logoSize,
                                                  decoration:
                                                      BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(20),
                                                    color:
                                                        colors.background,
                                                  ),
                                                  padding:
                                                      const EdgeInsets
                                                          .all(
                                                    AppSpacing.spacingMD,
                                                  ),
                                                  child: Image.asset(
                                                    LoginPage._logoAsset,
                                                    fit: BoxFit.contain,
                                                    filterQuality:
                                                        FilterQuality
                                                            .high,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: afterLogoGap,
                                              ),
                                              Text(
                                                'أهلاً بك في لَمح',
                                                textAlign:
                                                    TextAlign.center,
                                                style: textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                  color: colors.onGlass,
                                                  fontWeight:
                                                      FontWeight.w800,
                                                  height: 1.2,
                                                  fontSize:
                                                      keyboardVisible
                                                          ? 20
                                                          : null,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              if (!keyboardVisible) ...[
                                                const SizedBox(
                                                  height: AppSpacing
                                                      .spacingMD,
                                                ),
                                                Text(
                                                  'عدسة ذكية تفتح لك رحلتك التعليمية',
                                                  textAlign:
                                                      TextAlign.center,
                                                  style: textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                    color: colors
                                                        .onGlassMuted,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    height: 1.5,
                                                    decoration:
                                                        TextDecoration
                                                            .none,
                                                  ),
                                                ),
                                              ],
                                              SizedBox(
                                                height: afterSubtitleGap,
                                              ),
                                              CustomTextFormField(
                                                labelText:
                                                    'البريد الإلكتروني',
                                                required: true,
                                                hintText:
                                                    'example@domain.com',
                                                prefixIcon: AppIcons.mail,
                                                controller:
                                                    _emailController,
                                                keyboardType:
                                                    TextInputType
                                                        .emailAddress,
                                                textInputAction:
                                                    TextInputAction.next,
                                              ),
                                              SizedBox(
                                                height: betweenFieldsGap,
                                              ),
                                              CustomTextFormField(
                                                labelText: 'كلمة المرور',
                                                required: true,
                                                prefixIcon: AppIcons.lock,
                                                controller:
                                                    _passwordController,
                                                isPasswordField: true,
                                                textInputAction:
                                                    TextInputAction.done,
                                                onSubmitted: (_) =>
                                                    _submit(),
                                              ),
                                              SizedBox(
                                                height: keyboardVisible
                                                    ? AppSpacing.spacingMD
                                                    : AppSpacing
                                                        .spacingXL,
                                              ),
                                              AppGlassSwitch(
                                                value: _rememberMe,
                                                label: 'تذكّرني',
                                                onChanged: (value) {
                                                  setState(
                                                    () => _rememberMe =
                                                        value,
                                                  );
                                                },
                                              ),
                                              const Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: AppSpacing
                                                      .spacingXL,
                                                  bottom: bottomSafe +
                                                      AppSpacing
                                                          .spacingXL,
                                                ),
                                                child: GlassLoginButton(
                                                  onTap: _submit,
                                                  isLoading:
                                                      _isSubmitting,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
