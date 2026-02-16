import 'package:daily_os/core/config/app_config.dart';
import 'package:daily_os/features/ai_chat/domain/entities/chat_message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

class AiChatViewModel {
  final Signal<List<ChatMessage>> _messages = signal([]);
  final Signal<bool> _isTyping = signal(false);

  late final GenerativeModel _model;

  ReadonlySignal<List<ChatMessage>> get messages => _messages;
  ReadonlySignal<bool> get isTyping => _isTyping;

  AiChatViewModel() {
    _model = GenerativeModel(
      model: AppConfig.geminiModel,
      apiKey: AppConfig.geminiApiKey,
    );

    // Initial welcome message
    _messages.value = [
      ChatMessage(
        id: const Uuid().v4(),
        text:
            "Bonjour ! Je suis ton assistant DailyOS. Je peux créer, modifier ou déplacer tes tâches.",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.value = [..._messages.value, userMsg];

    // AI response
    _isTyping.value = true;

    try {
      if (AppConfig.geminiApiKey == 'VOTRE_CLE_API_ICI') {
        throw Exception("Clé API non configurée");
      }

      final content = [Content.text(text)];
      final response = await _model.generateContent(content);

      final aiMsg = ChatMessage(
        id: const Uuid().v4(),
        text: response.text ?? "Désolé, je n'ai pas pu générer de réponse.",
        isUser: false,
        timestamp: DateTime.now(),
      );

      _messages.value = [..._messages.value, aiMsg];
    } catch (e) {
      final errorMsg = ChatMessage(
        id: const Uuid().v4(),
        text:
            "Erreur : $e\n\nVeuillez vérifier votre clé API dans lib/core/config/app_config.dart",
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.value = [..._messages.value, errorMsg];
    } finally {
      _isTyping.value = false;
    }
  }
}
