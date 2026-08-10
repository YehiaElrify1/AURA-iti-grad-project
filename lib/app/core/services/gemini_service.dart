// lib/app/core/services/gemini_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../errors/app_exception.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _model = GenerativeModel(
      model: 'gemini-3.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        'You are AURA AI, a smart assistant built inside the AURA application. '
        'AURA is a Flutter application that allows users to explore popular people (actors, directors, etc.) '
        'using the TMDB API, view their details and images, and save them to favorites. '
        'Keep your answers helpful, friendly, and concise.',
      ),
      generationConfig: GenerationConfig(
        temperature: 0.8,
        maxOutputTokens: 1024,
      ),
    );
  }

  /// Sends a single prompt and returns the response text.
  /// Returns a [GeminiResult] (success or error) — callers pattern-match on it.
  Future<GeminiResult> sendMessage(String prompt) async {
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      if (text.isEmpty) {
        return const GeminiError(
          'Received an empty response. Please try again.',
        );
      }
      return GeminiSuccess(text.trim());
    } on GenerativeAIException catch (e) {
      return GeminiError(e.message);
    } catch (e) {
      final ex = AppExceptionHandler.from(e);
      return GeminiError(ex.message);
    }
  }
}

// ── Result sealed-style classes ───────────────────────────────────────────────

sealed class GeminiResult {
  const GeminiResult();
}

class GeminiSuccess extends GeminiResult {
  final String text;
  const GeminiSuccess(this.text);
}

class GeminiError extends GeminiResult {
  final String message;
  const GeminiError(this.message);
}
