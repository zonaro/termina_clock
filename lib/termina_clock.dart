library termina_clock;

import 'dart:async';

import 'package:flutter/material.dart';

class ClockFace {
  final Image? center;
  final Image? dayIndicator;
  final Image hourHand;
  final Image minuteHand;
  final Image? nightIndicator;
  final Image? secondsHand;

  const ClockFace({this.center, this.dayIndicator, required this.hourHand, required this.minuteHand, this.nightIndicator, this.secondsHand});

  ClockFace.termina()
      : center = Image.asset("assets/termina_clock/center.png", package: "termina_clock"),
        secondsHand = null,
        dayIndicator = Image.asset("assets/termina_clock/day_indicator.png", package: "termina_clock"),
        hourHand = Image.asset("assets/termina_clock/hours_disc.png", package: "termina_clock"),
        minuteHand = Image.asset("assets/termina_clock/minutes_disc.png", package: "termina_clock"),
        nightIndicator = Image.asset("assets/termina_clock/night_indicator.png", package: "termina_clock");
}

class TerminaClock extends StatefulWidget {
  final DateTime? dateTime;
  final bool staticClock;
  final ClockFace? face;

  const TerminaClock({super.key, this.dateTime, this.staticClock = false}) : face = null;
  const TerminaClock.custom({super.key, this.dateTime, this.staticClock = false, required this.face});

  @override
  createState() => TerminaClockState();
}

class TerminaClockState extends State<TerminaClock> {
  late ClockFace _faces;

  Timer? _timer;
  late DateTime _currentTime;

  DateTime get dateTime => _currentTime;
  set dateTime(DateTime dateTime) {
    setState(() {
      _currentTime = dateTime;
    });
  }

  Image? get _indicator {
    if (_faces.dayIndicator != null || _faces.nightIndicator != null) {
      return _currentTime.isAfter(DateTime(_currentTime.year, _currentTime.month, _currentTime.day, 5, 59, 59)) && _currentTime.isBefore(DateTime(_currentTime.year, _currentTime.month, _currentTime.day, 18)) ? _faces.dayIndicator : _faces.nightIndicator;
    }
    return _faces.dayIndicator ?? _faces.nightIndicator;
  }

  @override
  Widget build(BuildContext context) {
    double minuteRotation = (_currentTime.minute / 60) + (_currentTime.second / 3600);
    double hourRotation = (_currentTime.hour / 12) + (_currentTime.minute / 720);
    double secondRotation = _currentTime.second / 60;

    return Stack(
      alignment: Alignment.center,
      children: [
        RotationTransition(
          turns: AlwaysStoppedAnimation(minuteRotation),
          child: _faces.minuteHand, // Minute Hand
        ),
        RotationTransition(
          turns: AlwaysStoppedAnimation(hourRotation),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _faces.hourHand, // Hour Hand
              if (_indicator != null) _indicator! // Day/Night Indicator
            ],
          ),
        ),
        if (_faces.secondsHand != null)
          RotationTransition(
            turns: AlwaysStoppedAnimation(secondRotation),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _faces.secondsHand!, // Hour Hand
              ],
            ),
          ),
        if (_faces.center != null) _faces.center!, // Center
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _faces = widget.face ?? ClockFace.termina();
    _currentTime = widget.dateTime ?? DateTime.now();
    if (!widget.staticClock) {
      _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        setState(() {
          if (widget.staticClock) {
            timer.cancel();
            _currentTime = widget.dateTime ?? DateTime.now();
          }
          _currentTime = _currentTime.add(const Duration(milliseconds: 1));
        });
      });
    }
  }
}
