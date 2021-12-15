import 'package:flutter/material.dart';
import 'package:flutter_chatbot_interview/models/answer.dart';
import 'package:flutter_chatbot_interview/models/chat_message.dart';
import 'package:flutter_chatbot_interview/models/question.dart';

import '../repositories/firebase_repository.dart';

class ChatController {
  TextEditingController answerController = TextEditingController();
  final repository = FirebaseRepository();
  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  List<ChatMessage> chatMessages = <ChatMessage>[];

  void addMessageToChat(ChatMessage message) {
    chatMessages.add(message);
  }

  List<Question> questions = <Question>[];

  void setQuestions(List<Question> value) => questions = value;
  Question? currentQuestion;
  List<String> recommendations = [];

  void loadQuestions() {
    repository.getQuestionsFromQuestionnaire('p1bvTT4jcrUsYjUCfkts').then(
      (questionsList) {
        setQuestions(questionsList);
        addMessageToChat(questionsList.first);
        currentQuestion = questionsList.first;
        listKey.currentState!.insertItem(
          chatMessages.length - 1,
          duration: const Duration(
            milliseconds: 500,
          ),
        );
      },
    );
  }

  void loadRecommendations() {
    repository.getEmailRecommendations().then((recommendationsList) {
      recommendations = recommendationsList;
    });
  }

  void addNextQuestionToChat(Question question) {
    if (questions.indexOf(question) == questions.length - 1) {
      currentQuestion = null;
      addMessageToChat(Question(
        id: '',
        text: 'Thanks for your answers:)!?!?!?',
        number: 500,
      ));
      listKey.currentState!.insertItem(
        chatMessages.length - 1,
        duration: const Duration(
          milliseconds: 500,
        ),
      );
      return;
    }
    final nextQuestion = questions[questions.indexOf(question) + 1];
    addMessageToChat(nextQuestion);
    currentQuestion = nextQuestion;
    listKey.currentState!.insertItem(
      chatMessages.length - 1,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
  }

  void addAnswerToChat(String answerText) {
    var answer = Answer(answerText);
    addMessageToChat(answer);
    listKey.currentState!.insertItem(
      chatMessages.length - 1,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    addNextQuestionToChat(currentQuestion!);
  }
}
