// lib/app/features/chatbot/logic/chatbot_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_grad_proj/app/core/services/gemini_service.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import 'package:uuid/uuid.dart';
import '../data/chat_message.dart';
import 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final GeminiService gemini;
  final _uuid = const Uuid();

  ChatbotCubit({required this.gemini})
      : super(const ChatbotState()) {
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcome = ChatMessage(
      id: _uuid.v4(),
      text: AppStrings.chatbotWelcome,
      isUser: false,
      time: _now(),
    );
    emit(state.copyWith(messages: [welcome]));
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isGenerating) return;

    final userMsg = ChatMessage(
      id: _uuid.v4(),
      text: trimmed,
      isUser: true,
      time: _now(),
    );

    // Loading placeholder from the AI side
    final loadingId = _uuid.v4();
    final loadingMsg = ChatMessage(
      id: loadingId,
      text: '',
      isUser: false,
      isLoading: true,
      time: _now(),
    );

    emit(state.copyWith(
      messages: [loadingMsg, userMsg, ...state.messages],
      isGenerating: true,
    ));

    final result = await gemini.sendMessage(trimmed);

    final msgs = List<ChatMessage>.from(state.messages);
    final idx = msgs.indexWhere((m) => m.id == loadingId);

    switch (result) {
      case GeminiSuccess(:final text):
        if (idx != -1) {
          msgs[idx] = msgs[idx].copyWith(text: text, isLoading: false);
        }
      case GeminiError(:final message):
        if (idx != -1) {
          msgs[idx] =
              msgs[idx].copyWith(text: message, isLoading: false, isError: true);
        }
    }

    emit(state.copyWith(messages: msgs, isGenerating: false));
  }

  String _now() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
