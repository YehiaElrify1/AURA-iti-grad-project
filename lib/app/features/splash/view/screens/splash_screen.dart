// lib/app/features/splash/view/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import 'package:iti_grad_proj/app/core/routing/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    );

    _scale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    // Navigate after 2.5s total
    Future.delayed(const Duration(milliseconds: 2500), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool(AppStrings.prefIsFirstTime) ?? true;
    if (!mounted) return;
    if (isFirstTime) {
      context.go(AppRouter.onboarding);
    } else {
      context.go(AppRouter.home);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App name
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 52.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 10,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  AppStrings.appTagline,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.darkPrimary.withValues(alpha: 0.85),
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
