// lib/app/features/settings/view/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/core/constants/app_spacing.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import 'package:iti_grad_proj/app/core/theme/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppStrings.settingsTitle,
          style: theme.appBarTheme.titleTextStyle,
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h16,
          vertical: AppSpacing.v16,
        ),
        children: [
          // ── Section header ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.h4,
              bottom: AppSpacing.v8,
            ),
            child: Text(
              AppStrings.appearance,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                letterSpacing: 0.8,
              ),
            ),
          ),

          // ── Theme toggle card ───────────────────────────────────────────
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark;
              return Container(
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.h16,
                    vertical: AppSpacing.v4,
                  ),
                  secondary: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: theme.colorScheme.primary,
                      size: 20.sp,
                    ),
                  ),
                  title: Text(
                    isDark ? AppStrings.darkMode : AppStrings.lightMode,
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    isDark
                        ? 'Switch to Light Mode'
                        : 'Switch to Dark Mode',
                    style: theme.textTheme.bodySmall,
                  ),
                  value: isDark,
                  activeColor: AppColors.darkPrimary,
                  onChanged: (_) => context.read<ThemeCubit>().toggle(),
                ),
              );
            },
          ),

          SizedBox(height: AppSpacing.v32),

          // ── About section ───────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.h4,
              bottom: AppSpacing.v8,
            ),
            child: Text(
              'About',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppSpacing.h16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: theme.colorScheme.primary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: AppSpacing.h12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      'Version 1.0.0',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
