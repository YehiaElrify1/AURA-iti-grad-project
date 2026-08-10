// lib/app/features/chatbot/logic/chatbot_state.dart
import '../data/chat_message.dart';

class ChatbotState {
  final List<ChatMessage> messages;
  final bool isGenerating;

  const ChatbotState({
    this.messages = const [],
    this.isGenerating = false,
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isGenerating,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }
}
