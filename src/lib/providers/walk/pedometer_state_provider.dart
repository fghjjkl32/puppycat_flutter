import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'pedometer_state_provider.g.dart';

enum PedoMeterWalkStatus {
  none,
  walking,
  stopped,
  stoppedAlertMin,
  stoppedForceExitMin,
}

@Riverpod(keepAlive: true)
class PedoMeterState extends _$PedoMeterState {
  StreamSubscription<PedestrianStatus>? _pedestrianStatusStream;
  Timer? _timer;
  int _alertMin = 20;
  int _forceExitMin = 30;

  @override
  PedoMeterWalkStatus build() {
    return PedoMeterWalkStatus.none;
  }

  void startPedoMeter() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream.listen(onPedestrianStatusChanged); //.onError(_handlePedestrianStatusError);
    _pedestrianStatusStream!.onError(_handlePedestrianStatusError);
  }

  void stopPedoMeter() {
    if (_pedestrianStatusStream == null) {
      return;
    }

    _pedestrianStatusStream!.cancel();
  }

  void _handlePedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    switch (event.status) {
      case 'stopped':
        _startTimer();
        break;
      case 'walking':
        _stopTimer();
        break;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(timer.tick >= _alertMin && timer.tick < _forceExitMin) {
        state = PedoMeterWalkStatus.stoppedAlertMin;
      } else if(timer.tick >= _forceExitMin) {
        state = PedoMeterWalkStatus.stoppedForceExitMin;
      }
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer!.cancel();
      }
    }
  }
}
