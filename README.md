<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

![Termina Clock](https://tl.vhv.rs/dpng/s/424-4240750_termina-clock-majoras-mask-hd-png-download.png)


# Termina Clock

Termina Clock is a Flutter package that provides a customizable clock widget inspired by the Termina clock from The Legend of Zelda - Majora's Mask. It allows you to display a clock with custom images for the hour, minute, and second hands, as well as day and night indicators.

## Features

- Customizable clock face with images for hour, minute, and second hands.
- Day and night indicators.
- Static or dynamic clock display.
- Simple implemantation, just `TerminaClock()` for default clock with the current time

## Getting started

To use this package, add `termina_clock` as a dependency in your `pubspec.yaml` file.

## Usage
 
```dart
import 'package:termina_clock/termina_clock.dart';

// Default Termina Clock
TerminaCLock();


// Static display of a dateTime
TerminaCLock(
    dateTime: DateTime(2024),
    staticCLock: true // when true the clock will not update every tick
)

// Create a custom clock
TerminaClock.custom(
    face: ClockFace(
        hourHand: Image.asset('assets/hour_hand.png', package: 'your_package_name'),
        minuteHand: Image.asset('assets/minute_hand.png', package: 'your_package_name'),
        secondHand: Image.asset('assets/second_hand.png', package: 'your_package_name'),
        dayIndicator: Image.asset('assets/day_indicator.png', package: 'your_package_name'),
        nightIndicator: Image.asset('assets/night_indicator.png', package: 'your_package_name'),
    ),
);
```
> ATTENTION! All images need to have the same size. They will be stacked and centered.

## Additional information

For more information, visit the [Termina Clock GitHub repository](https://github.com/zonaro/termina_clock). To contribute, please submit a pull request or file an issue on GitHub. We welcome feedback and contributions from the community.
 
