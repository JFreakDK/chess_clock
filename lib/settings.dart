import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
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
                  onHoursChanged: (hours) => updateState(hours, (item) => _player1Hours = item),
                  onMinutesChanged: (minutes) => updateState(minutes, (item) => _player1Minutes = item),
                  onSecondsChanged: (seconds) => updateState(seconds, (item) => _player1Seconds = item),
                ),
                Text(
                  'Player 2',
                  style: TextStyle(fontSize: 20.0),
                ),
                Time(
                  hours: _player2Hours,
                  minutes: _player2Minutes,
                  seconds: _player2Seconds,
                  onHoursChanged: (hours) => updateState(hours, (item) => _player2Hours = item),
                  onMinutesChanged: (minutes) => updateState(minutes, (item) => _player2Minutes = item),
                  onSecondsChanged: (seconds) => updateState(seconds, (item) => _player2Seconds = item),
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: TextButton(
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
              //style: ButtonStyle(textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.white)),
              //  foregroundColor:  MaterialStateProperty.all<Color>(Colors.blue),),
            ),
          ),
        ],
      ),
    );
  }

  int updateState(String minutes, Function(int item) update) {
    var result;
    try {
      result = int.parse(minutes);
      update(result);
    } on FormatException {
    } catch (e) {
      throw e;
    }
    return result;
  }
}
