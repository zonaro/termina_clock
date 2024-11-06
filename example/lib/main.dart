import 'package:flutter/material.dart';
import 'package:termina_clock/termina_clock.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double _sliderValue = 0;

  final GlobalKey<TerminaClockState> _terminaClockKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: ListView(
          children: [
            TerminaClock(
              key: _terminaClockKey,
              dateTime: DateTime(2024),
              staticClock: true,
            ),
            Text(_terminaClockKey.currentState?.dateTime.toString() ?? ""),
            Slider(
              value: _sliderValue,
              min: -1 * (60 * 24),
              max: 60 * 24,
              label: _sliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                  _terminaClockKey.currentState?.dateTime = DateTime(2024).add(Duration(minutes: _sliderValue.toInt()));
                });
              },
            ),
          ],
        )),
      ),
    );
  }
}
