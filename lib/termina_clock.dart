library termina_clock;

import 'dart:async';

import 'package:flutter/material.dart';

class TerminaClock extends StatefulWidget {
  final double? size;
  final DateTime? dateTime;
  final bool staticClock;

  const TerminaClock({super.key, this.size, this.dateTime, this.staticClock = false});

  @override
  createState() => TerminaClockState();
}

class TerminaClockState extends State<TerminaClock> {
  Timer? _timer;
  late DateTime _currentTime;

  DateTime get dateTime => _currentTime;
  set dateTime(DateTime dateTime) {
    setState(() {
      _currentTime = dateTime;
    });
  }

  String get _center => "assets/termina_clock/center.png";
  String get _dayIndicator => "assets/termina_clock/day_indicator.png";
  String get _hourHand => "assets/termina_clock/hours_disc.png";
  String get _indicator => _currentTime.isAfter(DateTime(_currentTime.year, _currentTime.month, _currentTime.day, 5, 59, 59)) && _currentTime.isBefore(DateTime(_currentTime.year, _currentTime.month, _currentTime.day, 18)) ? _dayIndicator : _nightIndicator;
  String get _minuteHand => "assets/termina_clock/minutes_disc.png";

  String get _nightIndicator => "assets/termina_clock/night_indicator.png";

  @override
  Widget build(BuildContext context) {
    double minuteRotation = (_currentTime.minute / 60) + (_currentTime.second / 3600);
    double hourRotation = (_currentTime.hour / 12) + (_currentTime.minute / 720);

    double size = widget.size ?? MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: AlwaysStoppedAnimation(minuteRotation),
            child: SizedBox(width: widget.size, child: Image.asset(_minuteHand, package: "termina_clock")), // Minute Hand
          ),
          RotationTransition(
            turns: AlwaysStoppedAnimation(hourRotation),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: size * .75, child: Image.asset(_hourHand, package: "termina_clock")),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: size * .48,
                    ),
                    SizedBox(
                      width: size * .25,
                      child: Image.asset(_indicator, package: "termina_clock"),
                    ),
                  ],
                ),
              ],
            ), // Hour Hand
          ),
          SizedBox(width: size * .15, child: Center(child: Image.asset(_center, package: "termina_clock"))), // Center
        ],
      ),
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
