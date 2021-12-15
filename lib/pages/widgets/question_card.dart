import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';

import '../../controllers/chat_controller.dart';
import '../../models/question.dart';

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    Key? key,
    required this.animation,
    required this.question,
    required this.controller,
    required this.sessionId,
  }) : super(key: key);
  final Animation<double> animation;
  final Question question;
  final ChatController controller;
  final int sessionId;
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: kQuestionBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kQuestionTextColor,
              ),
            ),
            if (hasSuggestions()) ...drawSuggestionsList(widget.question)
          ],
        ),
      ),
    );
  }

  bool hasSuggestions() {
    return widget.question.suggestions?.isNotEmpty ?? false;
  }

  bool isCurrentQuestion(Question question) {
    return widget.controller.currentQuestion?.id == question.id;
  }

  bool hasChosenAtLeastOneSuggestion() {
    return widget.question.suggestions!.any((suggestion) => suggestion.value);
  }

  List<dynamic> drawSuggestionsList(Question question) {
    if (question.multiSelect ?? false) {
      List<Widget> options = [];
      for (var i = 0; i < question.suggestions!.length; i++) {
        var suggestion = question.suggestions![i];
        Widget checkbox = Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              suggestion.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Checkbox(
              value: suggestion.value,
              onChanged: isCurrentQuestion(question)
                  ? (bool? value) {
                      setState(() {
                        suggestion.value = value!;
                      });
                    }
                  : null,
              fillColor: MaterialStateProperty.all(kAnswerBackgroundColor),
            ),
          ],
        );
        options.add(checkbox);
      }
      if (isCurrentQuestion(question)) {
        options.add(GestureDetector(
          onTap: widget.controller.currentQuestion != null &&
                  hasChosenAtLeastOneSuggestion()
              ? () {
                  final answerText = question.suggestions!
                      .where((suggestion) => suggestion.value)
                      .map((suggestion) => suggestion.text)
                      .toList();
                  widget.controller.repository
                      .saveAnswerForQuestion(
                    answerText,
                    question.id,
                    widget.sessionId,
                  )
                      .then((wasQuestionStored) {
                    if (wasQuestionStored) {
                      setState(() {
                        widget.controller
                            .addAnswerToChat(answerText.join(', '));
                      });
                    } else {}
                  });
                }
              : null,
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: hasChosenAtLeastOneSuggestion()
                  ? kAnswerBackgroundColor
                  : kAnswerBackgroundColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Send answer',
              style: TextStyle(
                color: kAnswerTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ));
      }
      return options;
    }
    return question.suggestions!.map((suggestion) {
      return GestureDetector(
        onTap: widget.controller.currentQuestion != null &&
                (isCurrentQuestion(question))
            ? () {
                widget.controller.repository.saveAnswerForQuestion(
                  [suggestion.text],
                  widget.controller.currentQuestion!.id,
                  widget.sessionId,
                ).then((wasQuestionStored) {
                  if (wasQuestionStored) {
                    setState(() {
                      widget.controller.addAnswerToChat(suggestion.text);
                    });
                  }
                });
              }
            : null,
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kAnswerBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            suggestion.text,
            style: const TextStyle(
              color: kAnswerTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }).toList();
  }
}
