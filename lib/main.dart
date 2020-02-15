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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
        _durationPlayer2 = Duration(
          hours: sharedPreferences.getInt('player2Hour') ?? 0,
          minutes: sharedPreferences.getInt('player2Minutes') ?? 10,
          seconds: sharedPreferences.getInt('player2Seconds') ?? 0,
        );
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
              child: _createButton(() => _durationPlayer1, () => startTimer(player1, player2), player1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.refresh, size: 70.0),
                  onPressed: _reset,
                ),
                FlatButton(
                  child: Icon(
                    Icons.pause,
                    size: 70.0,
                    color: (!player1.isRunning && !player2.isRunning) ? Colors.white : null,
                  ),
                  onPressed: _stop,
                ),
                FlatButton(
                  child: Icon(Icons.settings, size: 70.0),
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
              ],
            ),
            _createButton(() => _durationPlayer2, () => startTimer(player2, player1), player2),
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
    var diff = (duration()?.inMilliseconds ?? 0) - stopwatch.elapsedMilliseconds;
    var timeLeft = Duration(milliseconds: diff);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlatButton(
          color: stopwatch.isRunning ? Colors.orange : Colors.grey.shade300,
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _format(timeLeft),
              style: TextStyle(fontSize: 100.0),
            ),
          ),
        ),
      ),
    );
  }

  void startTimer(Stopwatch current, Stopwatch other) {
    if (_timer == null || !_timer.isActive) {
      _timer = Timer.periodic(Duration(seconds: 1), tick);
    }
    other.start();
    if (current.isRunning) {
      current.stop();
    }
  }

  String _format(Duration duration) {
    if (duration.inHours >= 1) return formatByHours(duration);
    if (duration.inMinutes >= 1) return formatByMinutes(duration);

    return formatBySeconds(duration);
  }

  void tick(Timer timer) {
    setState(() {
      if (_timeElapsed(_durationPlayer1, player1) || _timeElapsed(_durationPlayer2, player2)) {
        player2.stop();
        player1.stop();
        _timer.cancel();
        HapticFeedback.heavyImpact();
      }
    });
  }

  bool _timeElapsed(Duration duration, Stopwatch stopwatch) {
    return duration.inMilliseconds - stopwatch.elapsedMilliseconds <= 0;
  }
}
