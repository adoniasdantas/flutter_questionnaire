import 'package:flutter/material.dart';

import '../../config/theme/colors.dart';

class AnswerCard extends StatelessWidget {
  const AnswerCard({
    Key? key,
    required this.animation,
    required this.answerText,
  }) : super(key: key);
  final Animation<double> animation;
  final String answerText;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: kAnswerBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              answerText,
              style: const TextStyle(
                color: kAnswerTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
