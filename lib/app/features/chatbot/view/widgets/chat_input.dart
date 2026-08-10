// lib/app/features/chatbot/view/widgets/chat_input.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/core/constants/app_spacing.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import 'package:iti_grad_proj/app/features/chatbot/logic/chatbot_cubit.dart';
import 'package:iti_grad_proj/app/features/chatbot/logic/chatbot_state.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<ChatbotCubit>().sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ChatbotCubit, ChatbotState>(
      buildWhen: (prev, curr) => prev.isGenerating != curr.isGenerating,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(
              AppSpacing.h16, AppSpacing.v8, AppSpacing.h8, AppSpacing.v16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outlineVariant,
                width: 0.8,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !state.isGenerating,
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: AppStrings.chatbotHint,
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurface
                        : const Color(0xFFF5FAF9),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 10.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide(
                        color: AppColors.lightPrimary.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: const BorderSide(
                        color: AppColors.lightPrimary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onSubmitted: state.isGenerating
                      ? null
                      : (_) => _send(context),
                ),
              ),
              SizedBox(width: AppSpacing.h8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: state.isGenerating
                    ? Padding(
                        padding: EdgeInsets.all(12.r),
                        child: SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.lightPrimary,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () => _send(context),
                        icon: const Icon(Icons.send_rounded),
                        color: AppColors.lightPrimary,
                        iconSize: 26.sp,
                        tooltip: AppStrings.chatbotSend,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
