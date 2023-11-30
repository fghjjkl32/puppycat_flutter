import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/jwt/jwt_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'jwt_service.g.dart';

@RestApi()
abstract class JWTService {
  factory JWTService(Dio dio, {String baseUrl}) = _JWTService;

  @POST('/v1/oauth/token')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<JWTResponseModel> getAccessToken(@Body() Map<String, dynamic> queries);
}
