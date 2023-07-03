import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @GET('/certification/popup')
  // Future<ResponseModel?> getPassAuthUrl(@Queries(encoded: false) Map<String, dynamic> queries);
  Future<ResponseModel?> getPassAuthUrl({
    @Query('appKey') required String appKey,
    @Query('token', encoded: false) required String token,
  });
}
