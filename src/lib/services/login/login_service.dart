import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/login/login_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'login_service.g.dart';

@RestApi()
abstract class LoginService {
  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;

  @POST('v1/login/social')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> socialLogin(@Body() Map<String, dynamic> body);

  @POST('v1/logout')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> logout(@Body() Map<String, dynamic> body);
}
