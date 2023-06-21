
import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/login/login_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'login_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class LoginService {
  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;
  //
  // @GET('/auth/{provider}')
  // Future<LoginResponseModel?> socialLogin(@Path("provider") String provider, @Queries() Map<String, dynamic> queries);

  @POST('/login/social')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel?> socialLogin(@Body() Map<String, dynamic> body);

  @POST('/join/social')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<LoginResponseModel> socialSignUp(@Body() Map<String, dynamic> queries);

}
