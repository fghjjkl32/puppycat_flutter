import 'dart:async';

import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/models/maintenance/update_response_model.dart';
import 'package:pet_mobile_social_flutter/repositories/maintenance/maintenance_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'maintenance_state_provider.g.dart';

@Riverpod(keepAlive: true)
class MaintenanceState extends _$MaintenanceState {
  late final MaintenanceRepository _maintenanceRepository = MaintenanceRepository(dio: ref.read(dioProvider));

  Timer? _timer;

  bool isOpenPopup = false;

  @override
  bool build() {
    return false;
  }

  void startPopupPolling() {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      _callPopupApi();
    });
  }

  void stopPopupPolling() {
    _timer?.cancel();
  }

  void _callPopupApi() {
    getUpdateFile();
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
    final goRouter = ref.read(routerProvider);

    getLastDate();

    UpdateResponseModel updateResult = await _maintenanceRepository.getUpdateFile();

    if (APP_BUILD_NUMBER < updateResult.minBuildNumber) {
      stopPopupPolling();
      goRouter.pushNamed('force_update_dialog');
    } else if (!isOpenPopup && APP_BUILD_NUMBER < updateResult.recommendBuildNumber) {
      stopPopupPolling();
      goRouter.pushNamed('recommend_update_dialog');
    }
  }
}
