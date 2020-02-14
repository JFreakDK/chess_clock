import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final Iterable<int> sixty = Iterable<int>.generate(60);
  final Iterable<int> twentyfive = Iterable<int>.generate(25);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _player1Hours = 0, _player1Seconds = 0, _player1Minutes = 10;
  int _player2Hours = 0, _player2Seconds = 0, _player2Minutes = 10;

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
                  style: TextStyle(fontSize: 20.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton(
                      items: widget.twentyfive.map((int e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(),
                      onChanged: (value) => setState(() {
                        this._player1Hours = value;
                      }),
                      value: _player1Hours,
                    ),
                    Text('hours'),
                    DropdownButton(
                        items: widget.sixty.map((int e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(),
                        onChanged: (value) => setState(() {
                              this._player1Minutes = value;
                            }),
                        value: _player1Minutes),
                    Text('minutes'),
                    DropdownButton(
                        items: widget.sixty.map((int e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(),
                        onChanged: (value) => setState(() {
                              this._player1Seconds = value;
                            }),
                        value: _player1Seconds),
                    Text('Seconds'),
                  ],
                ),
                Text(
                  'Player 2',
                  style: TextStyle(fontSize: 20.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton(
                      items: widget.twentyfive.map((int e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(),
                      onChanged: (value) => setState(() {
                        this._player2Hours = value;
                      }),
                      value: _player2Hours,
                    ),
                    Text('hours'),
                    DropdownButton(
                        items: widget.sixty.map((int e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(),
                        onChanged: (value) => setState(() {
                              this._player2Minutes = value;
                            }),
                        value: _player2Minutes),
                    Text('minutes'),
                    DropdownButton(
                        items: widget.sixty.map((int e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(),
                        onChanged: (value) => setState(() {
                              this._player2Seconds = value;
                            }),
                        value: _player2Seconds),
                    Text('Seconds'),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
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

  void updateHours(int value) {
    setState(() {
      this._player1Hours = value;
    });
  }

  void updateMinutes(int value) {
    setState(() {
      this._player2Minutes = value;
    });
  }

  void updateSeconds(int value) {
    setState(() {
      this._player2Seconds = value;
    });
  }
}
