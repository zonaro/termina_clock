library termina_clock;

import 'dart:async';

import 'package:flutter/material.dart';

/// Represents the face of the clock with various components.
class ClockFace {
  /// The center image of the clock face.
  final Image? center;

  /// The image indicating day time.
  final Image? dayIndicator;

  /// The image representing the hour hand.
  final Image hourHand;

  /// The image representing the minute hand.
  final Image minuteHand;

  /// The image indicating night time.
  final Image? nightIndicator;

  /// The image representing the seconds hand.
  final Image? secondsHand;

  /// The clock background
  final Image? background;

  /// Constructs a [ClockFace] with the given components.
  /// All images must have the same size and be centered.
  const ClockFace({
    this.center,
    this.dayIndicator,
    required this.hourHand,
    required this.minuteHand,
    this.nightIndicator,
    this.secondsHand,
    this.background,
  });

  /// Constructs a [ClockFace] with default Termina clock assets.
  ClockFace.termina()
      : secondsHand = null,
        background = null,
        center = Image.asset("assets/termina_clock/center.png", package: "termina_clock"),
        dayIndicator = Image.asset("assets/termina_clock/day_indicator.png", package: "termina_clock"),
        hourHand = Image.asset("assets/termina_clock/hours_disc.png", package: "termina_clock"),
        minuteHand = Image.asset("assets/termina_clock/minutes_disc.png", package: "termina_clock"),
        nightIndicator = Image.asset("assets/termina_clock/night_indicator.png", package: "termina_clock");
}

/// A widget that displays a Termina clock.
class TerminaClock extends StatefulWidget {
  /// The initial date and time to display on the clock.
  final DateTime? dateTime;

  /// Whether the clock is static (does not update).
  final bool staticClock;

  /// The face of the clock.
  final ClockFace? face;

  /// Constructs a [TerminaClock] with optional dateTime and staticClock.
  const TerminaClock({super.key, this.dateTime, this.staticClock = false}) : face = null;

  /// Constructs a custom [TerminaClock] with a specified face.
  const TerminaClock.custom({super.key, this.dateTime, this.staticClock = false, required this.face});

  @override
  createState() => TerminaClockState();
}

/// The state for the [TerminaClock] widget.
class TerminaClockState extends State<TerminaClock> {
  /// The face of the clock.
  late ClockFace _faces;

  /// The timer that updates the clock.
  Timer? _timer;

  /// The current date and time displayed on the clock.
  late DateTime _currentTime;

  /// Gets the current date and time.
  DateTime get dateTime => _currentTime;

  /// Sets the current date and time.
  set dateTime(DateTime dateTime) {
    setState(() {
      _currentTime = dateTime;
    });
  }

  /// Gets the appropriate day or night indicator based on the current time.
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
        _faces.background,
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
