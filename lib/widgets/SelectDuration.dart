import 'package:flutter/material.dart';

class SelectDuration extends StatefulWidget {
  @override
  _SelectDurationState createState() => _SelectDurationState();
}

class _SelectDurationState extends State<SelectDuration> {
  double _hourValue = 0;
  double _minuteValue = 0;
  Duration _duration;

  void setDuration() {
    if (_hourValue != 0 || _minuteValue != 0) {
      _duration =
          Duration(hours: _hourValue.toInt(), minutes: _minuteValue.toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromARGB(255, 204, 255, 255),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [
                Center(
                  child: Text(
                    "Select Hours",
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.deepPurple[700],
                    inactiveTrackColor: Colors.deepPurple[100],
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Colors.deepPurpleAccent,
                    overlayColor: Colors.deepPurple.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.deepPurple[700],
                    inactiveTickMarkColor: Colors.deepPurple[100],
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Colors.deepPurpleAccent,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: Slider(
                    value: _hourValue,
                    min: 0,
                    max: 12,
                    divisions: 12,
                    label: '${_hourValue.toInt()}',
                    onChanged: (value) {
                      setState(
                        () {
                          _hourValue = value;
                        },
                      );
                    },
                    onChangeEnd: (val) {
                      setDuration();
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "Select Minutes",
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.deepPurple[700],
                    inactiveTrackColor: Colors.deepPurple[100],
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Colors.deepPurpleAccent,
                    overlayColor: Colors.deepPurple.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.deepPurple[700],
                    inactiveTickMarkColor: Colors.deepPurple[100],
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Colors.deepPurpleAccent,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: Slider(
                    value: _minuteValue,
                    min: 0,
                    max: 59,
                    divisions: 60,
                    label: '${_minuteValue.toInt()}',
                    onChanged: (value) {
                      setState(
                        () {
                          _minuteValue = value;
                        },
                      );
                    },
                    onChangeEnd: (val) {
                      setDuration();
                    },
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text("${_hourValue.toInt()}", textScaleFactor: 2),
                          Text("Hours", textScaleFactor: 1.5)
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text("${_minuteValue.toInt()}", textScaleFactor: 2),
                          Text("Minutes", textScaleFactor: 1.5)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _duration);
                  },
                  child: Text("Done"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
