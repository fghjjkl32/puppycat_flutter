import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/setting/setting_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'setting_service.g.dart';

@RestApi()
abstract class SettingService {
  factory SettingService(Dio dio, {String baseUrl}) = _SettingService;

  @GET('v1/notification')
  Future<SettingResponseModel> getSetting();

  @PUT('v1/notification')
  Future<ResponseModel> putSetting(
    @Body() Map<String, dynamic> body,
  );
}
