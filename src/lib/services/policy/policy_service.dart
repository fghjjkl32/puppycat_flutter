
import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'policy_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class PolicyService {
  factory PolicyService(Dio dio, {String baseUrl}) = _PolicyService;

  @GET('/policy')
  Future<PolicyResponseModel?> getPolicies();
}
