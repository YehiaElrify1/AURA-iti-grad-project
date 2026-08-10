// lib/app/features/onboarding/view/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/core/constants/app_spacing.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import 'package:iti_grad_proj/app/core/routing/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingData(
      icon: Icons.star_rounded,
      title: 'Discover Stars',
      subtitle:
          'Browse the world\'s most popular personalities from film, TV, music, and more.',
    ),
    _OnboardingData(
      icon: Icons.auto_awesome_rounded,
      title: 'AI Assistant',
      subtitle:
          'Meet AURA AI — your smart companion powered by Google Gemini. Ask it anything.',
    ),
    _OnboardingData(
      icon: Icons.collections_bookmark_rounded,
      title: 'Galleries & Favorites',
      subtitle:
          'View stunning high-res galleries and save your favourite personalities for later.',
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStrings.prefIsFirstTime, false);
    if (mounted) context.go(AppRouter.home);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.darkSecondaryText,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _OnboardingPage(data: _pages[i]),
              ),
            ),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: _currentPage == i ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? AppColors.darkPrimary
                        : AppColors.darkPrimary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppRadius.circle),
                  ),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.v32),

            // Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.h24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                  ),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.v32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon in glowing circle
          Container(
            width: 120.r,
            height: 120.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkPrimary.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkPrimary.withValues(alpha: 0.3),
                  blurRadius: 60,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              data.icon,
              size: 56.sp,
              color: AppColors.darkPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.v48),
          Text(
            data.title,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.v16),
          Text(
            data.subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.darkSecondaryText,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
