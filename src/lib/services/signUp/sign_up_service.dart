import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'sign_up_service.g.dart';

@RestApi()
abstract class SignUpService {
  factory SignUpService(Dio dio, {String baseUrl}) = _SignUpService;

  @POST('v1/join/social')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> socialSignUp(@Body() Map<String, dynamic> queries);

  @POST('v1/member/nick/check')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> checkNickName(@Body() Map<String, dynamic> queries);
}
