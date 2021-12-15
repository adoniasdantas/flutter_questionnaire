import 'package:flutter/material.dart';

import '../../config/theme/colors.dart';
import '../../controllers/chat_controller.dart';

class AnswerTextField extends StatefulWidget {
  const AnswerTextField({
    Key? key,
    required this.controller,
    required this.sessionId,
  }) : super(key: key);

  final ChatController controller;
  final int sessionId;
  @override
  State<AnswerTextField> createState() => _AnswerTextFieldState();
}

class _AnswerTextFieldState extends State<AnswerTextField> {
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        clearOverlayEntry();
      }
    });
  }

  void clearOverlayEntry() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    const suggestionBoxHeight = 200;

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy -
            size.height -
            MediaQuery.of(context).viewInsets.bottom +
            suggestionBoxHeight -
            50,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: SizedBox(
            height: suggestionBoxHeight.toDouble(),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: widget.controller.recommendations.map(
                (recommendation) {
                  return GestureDetector(
                    onTap: () {
                      insertEmailOnTextFormField(recommendation);
                    },
                    child: ListTile(
                      title: Text(recommendation),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void insertEmailOnTextFormField(String selectedEmail) {
    final answerText = widget.controller.answerController.text;
    final answerTextFirstSection = answerText.substring(
      0,
      answerText.lastIndexOf('@'),
    );
    final newAnswerText = answerTextFirstSection + selectedEmail;
    widget.controller.answerController.value = TextEditingValue(
      text: newAnswerText,
      selection: TextSelection.collapsed(offset: newAnswerText.length),
    );
  }

  bool isTextQuestion() {
    return widget.controller.currentQuestion?.suggestions == null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controller.answerController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: kAnswerBackgroundColor,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
            ),
            enabled: isTextQuestion(),
            onChanged: (value) {
              if (widget.controller.answerController.text.contains('@')) {
                if (_overlayEntry == null) {
                  _overlayEntry = _createOverlayEntry();
                  Overlay.of(context)?.insert(_overlayEntry!);
                } else {
                  return;
                }
              } else {
                clearOverlayEntry();
              }
              setState(() {});
            },
          ),
        ),
        IconButton(
          disabledColor: Colors.grey,
          color: kAnswerBackgroundColor,
          onPressed: widget.controller.currentQuestion != null &&
                  widget.controller.answerController.text.isNotEmpty &&
                  isTextQuestion()
              ? () {
                  if (widget.controller.currentQuestion?.id != null) {
                    widget.controller.repository.saveAnswerForQuestion(
                      [widget.controller.answerController.text],
                      widget.controller.currentQuestion!.id,
                      widget.sessionId,
                    ).then((wasQuestionStored) {
                      if (wasQuestionStored) {
                        setState(() {
                          widget.controller.addAnswerToChat(
                            widget.controller.answerController.text,
                          );
                          widget.controller.answerController.clear();
                        });
                      }
                    });
                  }
                }
              : null,
          icon: const Icon(
            Icons.send,
          ),
        ),
      ],
    );
  }
}
