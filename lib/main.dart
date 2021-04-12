import 'dart:async';

import 'package:chess_clock/settings.dart';
import 'package:chess_clock/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(ChessClock());

class ChessClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => ChessClockHomePage(),
        '/settings': (context) => Settings(),
      },
      title: 'Chess clock',
      theme: ThemeData(),
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
  Timer _timer;
  Stopwatch player1 = Stopwatch();
  Stopwatch player2 = Stopwatch();
  Duration _durationPlayer1;
  Duration _durationPlayer2;
  Duration _player1TimeLeft;
  Duration _player2TimeLeft;

  @override
  void initState() {
    loadPreferences();
    super.initState();
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) {
      setState(() {
        _durationPlayer1 = Duration(
          hours: sharedPreferences.getInt('player1Hour') ?? 0,
          minutes: sharedPreferences.getInt('player1Minutes') ?? 10,
          seconds: sharedPreferences.getInt('player1Seconds') ?? 0,
        );
        _player1TimeLeft = _durationPlayer1;
        _durationPlayer2 = Duration(
          hours: sharedPreferences.getInt('player2Hour') ?? 0,
          minutes: sharedPreferences.getInt('player2Minutes') ?? 10,
          seconds: sharedPreferences.getInt('player2Seconds') ?? 0,
        );
        _player2TimeLeft = _durationPlayer2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RotatedBox(
              quarterTurns: 2,
              child: _createButton(() => _player1TimeLeft, () => startTimer(player1, player2), player1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  child: Icon(
                    Icons.refresh,
                    size: 70.0,
                    color: Colors.black,
                  ),
                  onPressed: _reset,
                ),
                TextButton(
                  child: Icon(
                    Icons.pause,
                    size: 70.0,
                    color: (!player1.isRunning && !player2.isRunning) ? Colors.white : Colors.black,
                  ),
                  onPressed: _stop,
                ),
                TextButton(
                  child: Icon(
                    Icons.settings,
                    size: 70.0,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
              ],
            ),
            _createButton(() => _player2TimeLeft, () => startTimer(player2, player1), player2),
          ],
        ),
      ),
    );
  }

  void _reset() {
    setState(() {
      player2.stop();
      player2.reset();
      player1.stop();
      player1.reset();
      loadPreferences();
    });
  }

  void _stop() {
    setState(() {
      player1.stop();
      player2.stop();
    });
  }

  Widget _createButton(Duration Function() duration, VoidCallback onPressed, Stopwatch stopwatch) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: stopwatch.isRunning
                ? MaterialStateProperty.all<Color>(Colors.orange)
                : MaterialStateProperty.all<Color>(Colors.grey.shade300),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _format(duration()),
              style: TextStyle(fontSize: 100.0),
            ),
          ),
        ),
      ),
    );
  }

  void startTimer(Stopwatch current, Stopwatch other) {
    if (_timer == null || !_timer.isActive) {
      _timer = Timer.periodic(Duration(milliseconds: 10), tick);
    }
    other.start();
    if (current.isRunning) {
      current.stop();
    }
    setState(() {
      updateTimeLeft();
    });
  }

  String _format(Duration duration) {
    if (duration != null) {
      if (duration.inHours >= 1) return formatByHours(duration);
      if (duration.inMinutes >= 1) return formatByMinutes(duration);

      return formatBySeconds(duration);
    }
    return '-';
  }

  void tick(Timer timer) {
    setState(() {
      updateTimeLeft();
      if (_timeElapsed(_durationPlayer1, player1) || _timeElapsed(_durationPlayer2, player2)) {
        player2.stop();
        player1.stop();
        _timer.cancel();
        HapticFeedback.heavyImpact();
      }
    });
  }

  void updateTimeLeft() {
    if (player1.isRunning) {
      _updateTimeLeft(_durationPlayer1, player1, (duration) => _player1TimeLeft = duration);
    }
    if (player2.isRunning) {
      _updateTimeLeft(_durationPlayer2, player2, (duration) => _player2TimeLeft = duration);
    }
  }

  void _updateTimeLeft(Duration duration, Stopwatch stopwatch, Function(Duration duration) updateDuration) {
    var diff = (duration.inMilliseconds ?? 0) - stopwatch.elapsedMilliseconds;
    updateDuration(Duration(milliseconds: diff));
  }

  bool _timeElapsed(Duration duration, Stopwatch stopwatch) {
    return duration.inMilliseconds - stopwatch.elapsedMilliseconds <= 0;
  }
}
