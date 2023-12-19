import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/restrain/restrain_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restrain_service.g.dart';

@RestApi()
abstract class RestrainService {
  factory RestrainService(Dio dio, {String baseUrl}) = _RestrainService;

  @GET('v1/restrain')
  Future<RestrainResponseModel> getRestrainDetail(
    @Query("type") int type,
  );
}
