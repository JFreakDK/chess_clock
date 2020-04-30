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
  int _player2Hours = 0, _player2Seconds = 0, _player2Minutes = 10;
  TextEditingController _player1HoursController = TextEditingController(),
      _player1MinutesController = TextEditingController(),
      _player1SecondsController = TextEditingController(),
      _player2HoursController = TextEditingController(),
      _player2MinutesController = TextEditingController(),
      _player2SecondsController = TextEditingController();

  final focus = FocusNode();

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) {
      setState(() {
        _player1HoursController.text = getTimeText(sharedPreferences, 'player1Hour', 0);
        _player1MinutesController.text = getTimeText(sharedPreferences, 'player1Minutes', 10);
        _player1SecondsController.text = getTimeText(sharedPreferences, 'player1Seconds', 0);
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
                  style: TextStyle(fontSize: 20.0),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (input) {
                          if (input.length == 2) FocusScope.of(context).nextFocus();
                        },
                        controller: _player1HoursController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontSize: 40.0, height: 2.0, color: Colors.black),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(), // move focus to next
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ], // Only numbers can be entered
                      ),
                    ),
                    Text(
                      ':',
                      style: TextStyle(fontSize: 40.0),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (input) {
                          if (input.length == 2) FocusScope.of(context).nextFocus();
                        },
                        controller: _player1MinutesController,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(), // move focus to next
                        style: TextStyle(fontSize: 40.0, height: 2.0, color: Colors.black),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ], // Only numbers can be entered
                      ),
                    ),
                    Text(
                      ':',
                      style: TextStyle(fontSize: 40.0),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (input) {
                          if (input.length == 2) FocusScope.of(context).nextFocus();
                        },
                        controller: _player1SecondsController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        style: TextStyle(
                          fontSize: 40.0,
                          height: 2.0,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                      ),
                    ),
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
                await sharedPreferences.setInt('player1Hour', int.parse(_player1HoursController.text));
                await sharedPreferences.setInt('player1Minutes', int.parse(_player1MinutesController.text));
                await sharedPreferences.setInt('player1Seconds', int.parse(_player1SecondsController.text));
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

  String getTimeText(SharedPreferences sharedPreferences, String key, int defaultValue) {
    int value = sharedPreferences.getInt(key) ?? defaultValue;
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }
}
