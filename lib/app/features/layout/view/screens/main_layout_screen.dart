// lib/app/features/layout/view/screens/main_layout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/features/chatbot/view/screens/chatbot_screen.dart';
import 'package:iti_grad_proj/app/features/persons/view/screens/persons_screen.dart';
import 'package:iti_grad_proj/app/features/settings/view/screens/settings_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _index = 1; // Start on Home

  static const _screens = [
    SettingsScreen(),
    PersonsScreen(),
    ChatbotScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final barBg =
        isDark ? AppColors.darkSurface : AppColors.lightBackground;
    final activeColor = AppColors.darkPrimary;
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.35)
        : Colors.black.withValues(alpha: 0.35);

    return Scaffold(
      // IndexedStack keeps all three screens alive — no rebuild on tab switch
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),

      // ── Standard Modern Navigation Bar ─────────────────────────────────
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        backgroundColor: barBg,
        indicatorColor: activeColor.withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 8,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: inactiveColor),
            selectedIcon: Icon(Icons.settings_rounded, color: activeColor),
            label: 'Settings',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: inactiveColor),
            selectedIcon: Icon(Icons.home_rounded, color: activeColor),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined, color: inactiveColor),
            selectedIcon: Icon(Icons.auto_awesome_rounded, color: activeColor),
            label: 'AURA AI',
          ),
        ],
      ),
    );
  }
}
