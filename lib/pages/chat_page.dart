import 'package:flutter/material.dart';

import '../config/theme/colors.dart';
import '../controllers/chat_controller.dart';
import '../models/question.dart';
import 'widgets/answer_card.dart';
import 'widgets/answer_text_field.dart';
import 'widgets/question_card.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = ChatController();
  final sessionId = DateTime.now().microsecondsSinceEpoch;

  @override
  void initState() {
    controller.loadQuestions();
    controller.loadRecommendations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: kAnswerBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: AnimatedList(
                key: controller.listKey,
                initialItemCount: controller.chatMessages.length,
                itemBuilder: (
                  BuildContext context,
                  int index,
                  Animation<double> animation,
                ) {
                  final message = controller.chatMessages[index];
                  if (message is Question) {
                    return QuestionCard(
                      animation: animation,
                      question: message,
                      controller: controller,
                      sessionId: sessionId,
                    );
                  }
                  return AnswerCard(
                    animation: animation,
                    answerText: message.text,
                  );
                },
              ),
            ),
            AnswerTextField(
              controller: controller,
              sessionId: sessionId,
            ),
          ],
        ),
      ),
    );
  }
}
