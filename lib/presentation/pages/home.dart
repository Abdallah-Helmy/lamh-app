import 'package:flutter/material.dart';
import 'package:lamh/core/theme/app_tokens.dart';
import 'package:lamh/core/assets/app_icons.dart';
import 'package:lamh/core/theme/app_colors.dart';
import 'package:lamh/presentation/components/app_svg_icon.dart';
import 'package:lamh/presentation/components/tab_placeholder_page.dart';
import 'package:lamh/presentation/pages/settings_page.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const _tabTransitionDuration = Duration(milliseconds: 220);
  static const _tabs = <GlassTab>[
    GlassTab(
      icon: AppSvgIcon(AppIcons.home),
      label: 'الرئيسية',
    ),
    GlassTab(
      icon: AppSvgIcon(AppIcons.settings),
      label: 'الإعدادات',
    ),
    GlassTab(
      icon: AppSvgIcon(AppIcons.search),
      label: 'بحث',
    ),
  ];

  late final PageController _pageController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_syncTabFromPageScroll);
  }

  void _syncTabFromPageScroll() {
    if (!_pageController.hasClients) return;
    final page = _pageController.page;
    if (page == null) return;

    final nextIndex = page.round().clamp(0, _pages.length - 1);
    if (nextIndex == _selectedTab) return;
    setState(() => _selectedTab = nextIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (index == _selectedTab) return;
    setState(() => _selectedTab = index);
    _pageController.animateToPage(
      index,
      duration: _tabTransitionDuration,
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
    if (index == _selectedTab) return;
    setState(() => _selectedTab = index);
  }

  List<Widget> get _pages => const [
        TabPlaceholderPage(
          title: 'الرئيسية',
          iconAsset: AppIcons.home,
        ),
        TabPlaceholderPage(
          title: 'القراء',
          iconAsset: AppIcons.microphone,
        ),
        TabPlaceholderPage(
          title: 'قوائم التشغيل',
          iconAsset: AppIcons.grid,
        ),
        SettingsPage(),
        TabPlaceholderPage(
          title: 'بحث',
          iconAsset: AppIcons.search,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GlassScaffold(
      statusBarStyle: colors.glassStatusBarStyle,
      contentAwareBrightness: true,
      background: ColoredBox(color: colors.background),
      appBar: GlassAppBar(
        title: Text(
          _tabs[_selectedTab].label ?? 'لَمح',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.onGlass,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
              ),
        ),
      ),
      bottomBar: GlassTabBar.bottom(
        selectedIndex: _selectedTab,
        onTabSelected: _onTabSelected,
        quality: GlassQuality.premium,
        backgroundQuality: GlassQuality.premium,
        verticalPadding: AppSpacing.spacingLG,
        barHeight: 72,
        tabPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingXS,
          vertical: AppSpacing.spacingSM,
        ),
        magnification: 1.28,
        indicatorPinchStrength: 0.58,
        indicatorExpansion: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2XL,
          vertical: AppSpacing.spacingMD,
        ),
        maskingQuality: MaskingQuality.high,
        innerBlur: 10,
        settings: LiquidGlassSettings(
          blur: colors.isDark ? 20 : 22,
          thickness: colors.isDark ? 16 : 22,
          glassColor: colors.glassBarColor,
          visibility: 1.0,
          lightIntensity: colors.isDark ? 0.55 : 0.95,
          ambientStrength: colors.isDark ? 0.04 : 0.2,
          refractiveIndex: colors.isDark ? 1.22 : 1.24,
          saturation: colors.isDark ? 1.15 : 1.2,
          chromaticAberration: colors.isDark ? 0.012 : 0.028,
          fresnelStrength: colors.isDark ? 1.0 : 1.2,
          bodyMode: GlassBodyMode.clear,
        ),
        indicatorSettings: AnimatedGlassIndicator.baseIndicatorSettings.copyWith(
          thickness: colors.isDark ? 28 : 30,
          refractiveIndex: 1.24,
          chromaticAberration: colors.isDark ? 0.04 : 0.035,
          lightIntensity: colors.isDark ? 0.85 : 1.0,
          saturation: colors.isDark ? 1.4 : 1.2,
          fresnelStrength: colors.isDark ? 1.15 : 1.3,
          ambientRim: colors.isDark ? 0.12 : 0.2,
          ambientStrength: colors.isDark ? 0.05 : 0.18,
          specularSharpness: GlassSpecularSharpness.sharp,
          bodyMode: GlassBodyMode.clear,
        ),
        tabs: _tabs,
        glowDuration: _tabTransitionDuration,
        iconSize: 28,
        labelFontSize: 13,
        iconLabelSpacing: AppSpacing.spacingSM,
        selectedLabelStyle: const TextStyle(
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(
          parent: PageScrollPhysics(),
        ),
        itemBuilder: (context, index) => _pages[index],
      ),
    );
  }
}
