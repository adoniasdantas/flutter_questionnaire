import 'package:flutter_chatbot_interview/models/chat_message.dart';

class Question extends ChatMessage {
  String id;
  int number;
  bool? multiSelect;
  List<Suggestion>? suggestions;
  Question({
    required this.id,
    required this.number,
    this.multiSelect,
    this.suggestions,
    required String text,
  }) : super(text: text);

  factory Question.fromJson(Map<String, dynamic> data) {
    bool? multiSelect;
    List<Suggestion>? suggestions = [];
    if (data.containsKey('multi_select')) {
      multiSelect = data['multi_select'];
    }
    if (data.containsKey('suggestions')) {
      for (var suggestion in data['suggestions']) {
        suggestions.add(
          Suggestion(text: suggestion, value: false),
        );
      }
    } else {
      suggestions = null;
    }
    return Question(
      id: data['id'],
      number: data['number'],
      text: data['text'],
      multiSelect: multiSelect,
      suggestions: suggestions,
    );
  }
}

class Suggestion {
  String text;
  bool value;
  Suggestion({
    required this.text,
    required this.value,
  });
}
