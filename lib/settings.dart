import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'time.dart';

class Settings extends StatefulWidget {
  final Iterable<int> sixty = Iterable<int>.generate(60);
  final Iterable<int> twentyfive = Iterable<int>.generate(25);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _player1Hours = 0, _player1Seconds = 0, _player1Minutes = 10, _player2Hours = 0, _player2Seconds = 0, _player2Minutes = 10;

  final focus = FocusNode();

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) {
      setState(() {
        _player1Hours = sharedPreferences.getInt('player1Hour') ?? 0;
        _player1Minutes = sharedPreferences.getInt('player1Minutes') ?? 10;
        _player1Seconds = sharedPreferences.getInt('player1Seconds') ?? 0;
        _player2Hours = sharedPreferences.getInt('player2Hour') ?? 0;
        _player2Minutes = sharedPreferences.getInt('player2Minutes') ?? 10;
        _player2Seconds = sharedPreferences.getInt('player2Seconds') ?? 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Player 1',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Time(
                  hours: _player1Hours,
                  minutes: _player1Minutes,
                  seconds: _player1Seconds,
                  onHoursChanged: (hours) => _player1Hours = int.parse(hours),
                  onMinutesChanged: (minutes) => _player1Minutes = int.parse(minutes),
                  onSecondsChanged: (seconds) => _player1Seconds = int.parse(seconds),
                ),
                Text(
                  'Player 2',
                  style: TextStyle(fontSize: 20.0),
                ),
                Time(
                  hours: _player2Hours,
                  minutes: _player2Minutes,
                  seconds: _player2Seconds,
                  onHoursChanged: (hours) => _player2Hours = int.parse(hours),
                  onMinutesChanged: (minutes) => _player2Minutes = int.parse(minutes),
                  onSecondsChanged: (seconds) => _player2Seconds = int.parse(seconds),
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: FlatButton(
              onPressed: () async {
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                await sharedPreferences.setInt('player1Hour', _player1Hours);
                await sharedPreferences.setInt('player1Minutes', _player1Minutes);
                await sharedPreferences.setInt('player1Seconds', _player1Seconds);
                await sharedPreferences.setInt('player2Hour', _player2Hours);
                await sharedPreferences.setInt('player2Minutes', _player2Minutes);
                await sharedPreferences.setInt('player2Seconds', _player2Seconds);
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(fontSize: 20)),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
