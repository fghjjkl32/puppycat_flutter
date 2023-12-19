import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/maintenance/inspect_response_model.dart';
import 'package:pet_mobile_social_flutter/models/maintenance/update_response_model.dart';
import 'package:pet_mobile_social_flutter/repositories/maintenance/maintenance_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'maintenance_state_provider.g.dart';

final isInspectProvider = StateProvider<bool>((ref) => false);
final isForceUpdateProvider = StateProvider<bool>((ref) => false);
final isRecommendUpdateProvider = StateProvider<bool>((ref) => false);

final inspectProvider = StateProvider<InspectResponseModel>((ref) => InspectResponseModel(endDate: '', startDate: '', targetServiceList: []));
final forceUpdateProvider =
    StateProvider<UpdateResponseModel>((ref) => UpdateResponseModel(currentBuildNumber: 0, minBuildNumber: 0, recommendBuildNumber: 0, forceTitle: '', forceContents: '', title: '', contents: ''));
final recommendUpdateProvider =
    StateProvider<UpdateResponseModel>((ref) => UpdateResponseModel(currentBuildNumber: 0, minBuildNumber: 0, recommendBuildNumber: 0, forceTitle: '', forceContents: '', title: '', contents: ''));

@Riverpod(keepAlive: true)
class MaintenanceState extends _$MaintenanceState {
  late final MaintenanceRepository _maintenanceRepository = MaintenanceRepository(dio: ref.read(dioProvider));

  Timer? _updateTimer;
  Timer? _inspectTimer;

  bool isOpenPopup = false;

  @override
  bool build() {
    return false;
  }

  void startUpdatePopupPolling() {
    _updateTimer?.cancel();

    getUpdateFile();

    _updateTimer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      getUpdateFile();
    });
  }

  void stopUpdatePopupPolling() {
    _updateTimer?.cancel();
  }

  void startInspectPopupPolling() {
    _inspectTimer?.cancel();

    getInspectFile();

    _inspectTimer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      getInspectFile();
    });
  }

  void stopInspectPopupPolling() {
    _inspectTimer?.cancel();
  }

  getLastDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString('lastPopUpDate');

    if (lastDate != null) {
      DateTime now = DateTime.now();
      int timeDifference = now.difference(DateTime.parse(lastDate)).inDays;

      if (timeDifference < 30) {
        isOpenPopup = true;
      } else {
        isOpenPopup = false;
      }
    }
  }

  void getUpdateFile() async {
    getLastDate();

    UpdateResponseModel updateResult = await _maintenanceRepository.getUpdateFile();

    if (APP_BUILD_NUMBER < updateResult.minBuildNumber) {
      stopUpdatePopupPolling();
      ref.read(forceUpdateProvider.notifier).state = updateResult;
      ref.read(isForceUpdateProvider.notifier).state = true;
    } else if (!isOpenPopup && APP_BUILD_NUMBER < updateResult.recommendBuildNumber) {
      stopUpdatePopupPolling();
      ref.read(recommendUpdateProvider.notifier).state = updateResult;
      ref.read(isRecommendUpdateProvider.notifier).state = true;
    }
  }

  void getInspectFile() async {
    InspectResponseModel inspectResult = await _maintenanceRepository.getInspectFile();

    if (isCurrentTimeInRange(inspectResult.startDate, inspectResult.endDate)) {
      stopInspectPopupPolling();
      stopUpdatePopupPolling();
      ref.read(inspectProvider.notifier).state = inspectResult;
      ref.read(isInspectProvider.notifier).state = true;
    }
  }

  bool isCurrentTimeInRange(String startDateStr, String endDateStr) {
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm");
    DateTime startDate = format.parse(startDateStr);
    DateTime endDate = format.parse(endDateStr);
    DateTime now = DateTime.now();

    return now.isAfter(startDate) && now.isBefore(endDate);
  }
}
