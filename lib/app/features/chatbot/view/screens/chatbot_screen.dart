// lib/app/features/chatbot/view/screens/chatbot_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/core/constants/app_spacing.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import 'package:iti_grad_proj/app/features/chatbot/logic/chatbot_cubit.dart';
import 'package:iti_grad_proj/app/features/chatbot/logic/chatbot_state.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, theme),
      body: Column(
          children: [
          Expanded(
            child: BlocBuilder<ChatbotCubit, ChatbotState>(
              builder: (context, state) {
                if (state.messages.isEmpty) {
                  return const SizedBox.shrink();
                }
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.h16,
                    vertical: AppSpacing.v16,
                  ),
                  itemCount: state.messages.length,
                  itemBuilder: (_, i) =>
                      ChatBubble(message: state.messages[i]),
                );
              },
            ),
          ),
          const ChatInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      titleSpacing: AppSpacing.h16,
      automaticallyImplyLeading: false, // It's a tab now, no back button
      title: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome_rounded,
                color: AppColors.lightPrimary, size: 20.sp),
          ),
          SizedBox(width: AppSpacing.h12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.chatbotTitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    AppStrings.chatbotSubtitle,
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
