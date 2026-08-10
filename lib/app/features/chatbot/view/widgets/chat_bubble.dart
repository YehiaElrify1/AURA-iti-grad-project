// lib/app/features/chatbot/view/widgets/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/features/chatbot/data/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (message.isUser) {
      return _UserBubble(message: message, isDark: isDark, theme: theme);
    }
    return _AiBubble(message: message, isDark: isDark, theme: theme);
  }
}

class _UserBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;
  final ThemeData theme;

  const _UserBubble(
      {required this.message, required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        margin: EdgeInsets.only(bottom: 12.h, left: 48.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.lightPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(4.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              message.time,
              style:
                  TextStyle(color: Colors.white70, fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;
  final ThemeData theme;

  const _AiBubble(
      {required this.message, required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.darkSurface : const Color(0xFFF0FAF8);

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI Avatar
          Container(
            width: 32.r,
            height: 32.r,
            margin: EdgeInsets.only(right: 8.w, bottom: 12.h),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome_rounded,
                color: AppColors.lightPrimary, size: 16.sp),
          ),

          // Bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 0.75.sw),
              margin: EdgeInsets.only(bottom: 12.h, right: 48.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                border: Border.all(
                  color: AppColors.lightPrimary.withValues(alpha: 0.15),
                ),
              ),
              child: message.isLoading
                  ? _LoadingDots()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            color: message.isError
                                ? AppColors.error
                                : theme.colorScheme.onSurface,
                            fontSize: 14.sp,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          message.time,
                          style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                              fontSize: 10.sp),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (_, _) {
              final phase = (_controller.value + i * 0.2) % 1.0;
              final scale = 0.6 + 0.4 * (1 - (phase * 2 - 1).abs());
              return Container(
                width: 7.r,
                height: 7.r,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: scale),
                  shape: BoxShape.circle,
                ),
                transform: Matrix4.translationValues(0.0, -3.0 * scale + 1.5, 0.0),
              );
            },
          );
        }),
      ),
    );
  }
}
