import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatbot_interview/models/question.dart';

class FirebaseRepository {
  FirebaseFirestore? firestore;

  FirebaseRepository() {
    firestore = FirebaseFirestore.instance;
  }

  Future<List<Question>> getQuestionsFromQuestionnaire(
    String questionnaireId,
  ) async {
    List<Question>? questions = [];
    questions = await firestore
        ?.collection('questionnaire')
        .doc(questionnaireId)
        .collection('questions')
        .orderBy('number')
        .get()
        .then((snapshot) {
      List<Question>? questionsList = [];
      for (var question in snapshot.docs) {
        Map<String, dynamic> q = question.data();
        q['id'] = question.id;
        questionsList.add(Question.fromJson(q));
      }
      return questionsList;
    }).catchError((onError) => <Question>[]);
    return questions!;
  }

  Future<bool> saveAnswerForQuestion(
    List<String> answer,
    String questionId,
    int sessionId,
  ) async {
    final wasQuestionStored = await addToCollection(
      'answers',
      {
        'questionnaire': '/questionnaires/p1bvTT4jcrUsYjUCfkts',
        'question':
            '/questionnaires/p1bvTT4jcrUsYjUCfkts/questions/$questionId',
        'answer': answer,
        'session': sessionId,
      },
    ).then((value) => true).catchError((error) => false);
    return wasQuestionStored;
  }

  Future<DocumentReference<Map<String, dynamic>>?> addToCollection(
    String collection,
    Map<String, dynamic> data,
  ) async {
    return firestore?.collection(collection).add(data);
  }

  Future<List<String>> getEmailRecommendations() async {
    List<String>? recommendations = [];
    recommendations = await firestore
        ?.collection('recommendations')
        .orderBy('email')
        .get()
        .then((snapshot) {
      List<String> recommendationsList = [];
      for (var recommendation in snapshot.docs) {
        recommendationsList.add(recommendation.data()['email']);
      }
      return recommendationsList;
    }).catchError((onError) => <String>[]);
    return recommendations!;
  }
}
