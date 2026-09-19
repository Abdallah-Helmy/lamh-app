import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lamh/core/theme/app_tokens.dart';
import 'package:lamh/core/router/app_routes.dart';
import 'package:lamh/core/theme/app_colors.dart';
import 'package:lamh/presentation/components/glass_login_button.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingStep {
  const _OnboardingStep({
    this.lottieAsset,
    this.imageAsset,
    required this.title,
    required this.description,
  }) : assert(
          lottieAsset != null || imageAsset != null,
          'Provide lottieAsset or imageAsset',
        );

  final String? lottieAsset;
  final String? imageAsset;
  final String title;
  final String description;
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _steps = <_OnboardingStep>[
    _OnboardingStep(
      lottieAsset: 'assets/images/onBoarding1.json',
      title: 'مرحبًا بك في لَمح',
      description:
          'منصة عربية للتعلّم بالصوت والقراءة بمحتوى منظم يرافقك خطوة بخطوة نحو المعرفة.',
    ),
    _OnboardingStep(
      imageAsset: 'assets/images/onBoarding2.jpg',
      title: 'ركّز على أهدافك',
      description:
          'تابع الدروس والقراء واستمع لمحتوى يناسب وقتك مع تقدّم واضح بلا تشتيت.',
    ),
    _OnboardingStep(
      imageAsset: 'assets/images/onBoarding3.jpg',
      title: 'ابدأ مع لَمح',
      description:
          'كل ما تحتاجه في مكان واحد: تعلّم، استماع، ومتابعة. ابدأ رحلتك الآن.',
    ),
  ];

  final _pageController = PageController();
  int _currentIndex = 0;

  bool get _isLastPage => _currentIndex == _steps.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    context.go(AppRoutes.login);
  }

  void _onContinue() {
    if (_isLastPage) {
      _goToLogin();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return GlassScaffold(
      statusBarStyle: GlassStatusBarStyle.dark,
      contentAwareBrightness: true,
      background: const ColoredBox(color: Colors.white),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spacing3XL,
            AppSpacing.spacingMD,
            AppSpacing.spacing3XL,
            AppSpacing.spacing3XL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _goToLogin,
                    borderRadius: BorderRadius.circular(999),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: colors.glassStrokeSoft,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingLG,
                        vertical: AppSpacing.spacingMD,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 14,
                            color: colors.onGlass,
                          ),
                          const SizedBox(width: AppSpacing.spacingSM),
                          Text(
                            'تخطّي',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onGlass,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _steps.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _steps[index];
                    return Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: page.imageAsset != null
                                ? Image.asset(
                                    page.imageAsset!,
                                    fit: BoxFit.contain,
                                  )
                                : Lottie.asset(
                                    page.lottieAsset!,
                                    fit: BoxFit.contain,
                                    repeat: true,
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spacingLG),
                        Text(
                          page.title,
                          style: textTheme.headlineMedium?.copyWith(
                            color: colors.onGlass,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                            letterSpacing: -0.3,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spacingMD),
                        Text(
                          page.description,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colors.onGlassMuted,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.65,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.spacing2XL),
              _PageDots(
                count: _steps.length,
                index: _currentIndex,
                activeColor: const Color(0xFF12141A),
                inactiveColor: colors.glassStrokeSoft,
              ),
              const SizedBox(height: AppSpacing.spacing2XL),
              GlassLoginButton(
                onTap: _onContinue,
                label: _isLastPage ? 'ابدأ مع لَمح' : 'متابعة',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingXS),
          width: isActive ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
