import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'time_field.dart';

class Time extends StatelessWidget {
  final TextEditingController _hoursController = TextEditingController(),
      _minutesController = TextEditingController(),
      _secondsController = TextEditingController();
  final ValueChanged<String> onHoursChanged, onMinutesChanged, onSecondsChanged;
  final bool configureSeconds;

  final TextInputAction textInputAction;

  Time({
    Key key,
    int hours,
    int minutes,
    int seconds,
    this.onHoursChanged,
    this.onMinutesChanged,
    this.onSecondsChanged,
    this.configureSeconds = false,
    this.textInputAction,
  }) : super(key: key) {
    _hoursController.text = _getTimeText(hours, 0);
    _minutesController.text = _getTimeText(minutes, 10);
    _secondsController.text = _getTimeText(seconds, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        TimeField(
          controller: _hoursController,
          onChanged: onHoursChanged,
        ),
        Text(
          ':',
          style: TextStyle(fontSize: 40.0),
        ),
        TimeField(
          controller: _minutesController,
          onChanged: onMinutesChanged,
          textInputAction: configureSeconds ? TextInputAction.next : this.textInputAction,
        ),
        if (configureSeconds)
          Text(
            ':',
            style: TextStyle(fontSize: 40.0),
          ),
        if (configureSeconds)
          TimeField(
            controller: _secondsController,
            onChanged: onSecondsChanged,
            textInputAction: this.textInputAction,
          ),
      ],
    );
  }

  String _getTimeText(int value, int defaultValue) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }
}
