import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/setting/setting_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/setting/setting_service.dart';

class SettingRepository {
  late final SettingService _settingService; // = SettingService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  SettingRepository({
    required this.dio,
  }) {
    _settingService = SettingService(dio, baseUrl: baseUrl);
  }

  Future<SettingResponseModel?> getSetting({
    required int memberIdx,
  }) async {
    SettingResponseModel? settingResponseModel = await _settingService.getSetting(memberIdx).catchError((Object obj) async {});

    if (settingResponseModel == null) {
      return null;
    }

    return settingResponseModel;
  }

  Future<ResponseModel> putSetting({
    required int memberIdx,
    required Map<String, dynamic> body,
  }) async {
    ResponseModel? followResponseModel = await _settingService.putSetting(body);

    if (followResponseModel == null) {
      throw "error";
    }

    return followResponseModel;
  }
}
