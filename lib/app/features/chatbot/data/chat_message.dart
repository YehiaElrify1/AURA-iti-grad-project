// lib/app/features/chatbot/data/chat_message.dart

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final String time;
  final bool isLoading;
  final bool isError;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.time,
    this.isLoading = false,
    this.isError = false,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    String? time,
    bool? isLoading,
    bool? isError,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      time: time ?? this.time,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }
}
