import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TimeField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;

  TimeField({
    this.controller,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
  });

  @override
  _TimeFieldState createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      final newText = widget.controller.text.toLowerCase();
      widget.controller.value = widget.controller.value.copyWith(
        text: newText,
        selection: TextSelection(baseOffset: newText.length, extentOffset: newText.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        controller: this.widget.controller,
        textInputAction: this.widget.textInputAction,
        style: TextStyle(fontSize: 40.0, height: 2.0, color: Colors.black),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onSubmitted: (_) => FocusScope.of(context).nextFocus(), // move focus to next
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ], // Only numbers can be entered
      ),
    );
  }
}
