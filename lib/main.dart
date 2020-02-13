import 'dart:async';

import 'package:chess_clock/utils.dart';
import 'package:flutter/material.dart';

void main() => runApp(ChessClock());

class ChessClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChessClockHomePage(),
    );
  }
}

class ChessClockHomePage extends StatefulWidget {
  ChessClockHomePage({
    Key key,
    this.interval = const Duration(seconds: 1),
  }) : super(key: key);

  final Duration interval;

  @override
  _ChessClockHomePageState createState() => _ChessClockHomePageState();
}

class _ChessClockHomePageState extends State<ChessClockHomePage> {
  Timer _timerPlayer1;
  Timer _timerPlayer2;
  Duration _durationPlayer1 = Duration(minutes: 1);
  Duration _durationPlayer2 = Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: RotatedBox(
                quarterTurns: 2,
                child: FlatButton(
                  color: Colors.grey.shade300,
                  onPressed: () => startTimerPlayer2(),
                  child: Text(
                    _format(_durationPlayer1),
                    style: TextStyle(fontSize: 70.0),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text('Reset', style: TextStyle(fontSize: 30.0)),
                  onPressed: () => print(''),
                ),
                if ((_timerPlayer1 != null && _timerPlayer1.isActive) || (_timerPlayer2 != null && _timerPlayer2.isActive))
                  FlatButton(
                    child: Text('Pause', style: TextStyle(fontSize: 30.0)),
                    onPressed: () {
                      if (_timerPlayer1 != null && _timerPlayer1.isActive) {
                        _timerPlayer1.cancel();
                      }
                      if (_timerPlayer2 != null && _timerPlayer2.isActive) {
                        _timerPlayer2.cancel();
                      }
                    },
                  ),
                FlatButton(
                  child: Text('Config', style: TextStyle(fontSize: 30.0)),
                  onPressed: () => print(''),
                ),
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: FlatButton(
                color: Colors.grey.shade300,
                onPressed: () => startTimerPlayer1(),
                child: Text(
                  _format(_durationPlayer2),
                  style: TextStyle(fontSize: 70.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startTimerPlayer2() {
    startTimer(_timerPlayer2, _durationPlayer2, _timerPlayer1, (Timer timer) => _timerPlayer2 = timer,
        (Duration duration) => _durationPlayer2 = duration);
  }

  void startTimerPlayer1() {
    startTimer(_timerPlayer1, _durationPlayer1, _timerPlayer2, (Timer timer) => _timerPlayer1 = timer,
        (Duration duration) => _durationPlayer1 = duration);
  }

  void startTimer(Timer timerPlayer, Duration timerDuration, Timer otherTimerPlayer, void Function(Timer timer) updateTimer,
      void Function(Duration duration) updateDuration) {
    if (otherTimerPlayer != null && otherTimerPlayer.isActive) {
      otherTimerPlayer.cancel();
    }
    if (timerPlayer == null || !timerPlayer.isActive) {
      updateTimer(Timer.periodic(widget.interval, (Timer timer) {
        timerCallback(timer, timerDuration, (Duration duration) {
          timerDuration = duration;
          updateDuration(duration);
        }, () {
          print('Player finished');
        });
      }));
    }
  }

  void timerCallback(Timer timer, Duration duration, void Function(Duration duration) func, var onFinish) {
    setState(() {
      if (duration.inSeconds == 0) {
        timer.cancel();
        if (onFinish != null) onFinish();
      } else {
        func(Duration(seconds: duration.inSeconds - 1));
      }
    });
  }

  String _format(Duration duration) {
    if (duration.inHours >= 1) return formatByHours(duration);
    if (duration.inMinutes >= 1) return formatByMinutes(duration);

    return formatBySeconds(duration);
  }
}
