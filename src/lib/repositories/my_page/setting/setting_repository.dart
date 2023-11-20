import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
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
    SettingResponseModel responseModel = await _settingService.getSetting(memberIdx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SettingRepository',
        caller: 'getSetting',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> putSetting({
    required int memberIdx,
    required Map<String, dynamic> body,
  }) async {
    ResponseModel responseModel = await _settingService.putSetting(body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SettingRepository',
        caller: 'putSetting',
      );
    }

    return responseModel;
  }
}
