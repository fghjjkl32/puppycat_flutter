import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';

extension ElevatedButtonExtension on ElevatedButton {
  ElevatedButton throttle() {
    return ElevatedButton(
      style: style,
      onPressed: () {
        EasyThrottle.throttle(
          'elevatedButtonThrottle',
          const Duration(
            milliseconds: 500,
          ),
          onPressed!,
        );
      },
      child: child,
    );
  }

  ElevatedButton debounce() {
    return ElevatedButton(
      style: style,
      onPressed: () {
        EasyDebounce.debounce(
          'elevatedButtonDebounce',
          const Duration(
            milliseconds: 500,
          ),
          onPressed!,
        );
      },
      child: child,
    );
  }
}

extension IconButtonExtension on IconButton {
  IconButton throttle() {
    return IconButton(
      onPressed: () {
        EasyThrottle.throttle(
          'iconButtonThrottle',
          const Duration(
            milliseconds: 500,
          ),
          onPressed!,
        );
      },
      icon: icon,
    );
  }

  IconButton debounce() {
    return IconButton(
      onPressed: () {
        EasyDebounce.debounce(
          'iconButtonDebounce',
          const Duration(
            milliseconds: 500,
          ),
          onPressed!,
        );
      },
      icon: icon,
    );
  }
}

extension InkWellExtension on InkWell {
  InkWell throttle() {
    return InkWell(
      onTap: () {
        EasyThrottle.throttle(
          'inkWellThrottle',
          const Duration(
            milliseconds: 500,
          ),
          onTap!,
        );
      },
      child: child,
    );
  }

  InkWell debounce() {
    return InkWell(
      onTap: () {
        EasyDebounce.debounce(
          'iconButtonDebounce',
          const Duration(
            milliseconds: 500,
          ),
          onTap!,
        );
      },
      child: child,
    );
  }
}

extension GestureDetectorExtension on GestureDetector {
  GestureDetector throttle() {
    return GestureDetector(
      onTap: () {
        EasyThrottle.throttle(
          'gestureDetectorThrottle',
          const Duration(
            milliseconds: 500,
          ),
          onTap!,
        );
      },
      child: child,
    );
  }

  GestureDetector debounce() {
    return GestureDetector(
      onTap: () {
        EasyDebounce.debounce(
          'gestureDetectorDebounce',
          const Duration(
            milliseconds: 500,
          ),
          onTap!,
        );
      },
      child: child,
    );
  }
}
