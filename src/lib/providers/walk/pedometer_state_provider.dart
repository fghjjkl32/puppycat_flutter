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
  final int _alertMin = 20;
  final int _forceExitMin = 30;

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
    state = PedoMeterWalkStatus.none;
  }

  void _handlePedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print('pedo event.status ${event.status}');

    switch (event.status) {
      case 'stopped':
        _startTimer();
        break;
      case 'walking':
      case 'unknown':
        _stopTimer();
        break;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print('pedo timer tick ${timer.tick}');
      if(timer.tick >= _alertMin && timer.tick < _forceExitMin) {
        state = PedoMeterWalkStatus.stoppedAlertMin;
      } else if(timer.tick >= _forceExitMin) {
        state = PedoMeterWalkStatus.stoppedForceExitMin;
      } else {
        state = PedoMeterWalkStatus.stopped;
      }
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer!.cancel();
      }
    }
    state = PedoMeterWalkStatus.walking;
  }

  void initPedoTimer() {
    if(_timer == null) {
      return;
    }

    if(state == PedoMeterWalkStatus.stopped) {
      _stopTimer();
      _startTimer();
    }
  }
}
