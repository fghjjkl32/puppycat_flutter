import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'bearer_token_auth_service.g.dart';

@RestApi()
abstract class BearerTokenAuthService {
  factory BearerTokenAuthService(Dio dio, {String baseUrl}) = _BearerTokenAuthService;

  @POST("https://oauth2.cert.toss.im/token")
  @FormUrlEncoded()
  Future<String> getTossToken(
    @Field("grant_type") String type,
    @Field("client_id") String clientId,
    @Field("client_secret") String clientSecret,
    @Field("scope") String scope,
  );

  @POST("https://cert.toss.im/api/v2/sign/user/auth/request")
  Future<String> getTossAuthUrl(@Body() Map<String, dynamic> body, @Header('Authorization') String token);
}
