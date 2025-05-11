import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      onboardingNotifierProvider.select((state) => state.currentIndex),
      (prevIndex, newIndex) {
        if (_pageController.hasClients &&
            _pageController.page?.round() != newIndex) {
          _pageController.animateToPage(
            newIndex,
            duration: Durations.medium1,
            curve: Curves.easeInOutCubic,
          );
        }
      },
    );

    return Scaffold(
      appBar: _OnboardingAppBar(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: OnboardingState.pages,
      ),
    );
  }
}

class _OnboardingAppBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingNotifierProvider);
    final onboardingProgress =
        OnboardingState.pages.isNotEmpty
            ? (onboardingState.currentIndex + 1) / OnboardingState.pages.length
            : 0.0;
    return AppBar(
      title: TweenAnimationBuilder<double>(
        duration: Durations.medium1,
        curve: Curves.easeInOutCubic,
        tween: Tween<double>(end: onboardingProgress),
        builder:
            (context, value, child) => LinearProgressIndicator(
              value: value,
              borderRadius: BorderRadius.circular(16),
              stopIndicatorRadius: 0,
              minHeight: 12,
            ),
      ),
      centerTitle: true,
      actions: const [SizedBox(width: kToolbarHeight)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
