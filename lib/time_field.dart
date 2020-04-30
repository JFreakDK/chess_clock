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
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.controller.selection = TextSelection(baseOffset: 0, extentOffset: widget.controller.text.length);
      }
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
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ], // Only numbers can be entered
      ),
    );
    ;
  }
}
