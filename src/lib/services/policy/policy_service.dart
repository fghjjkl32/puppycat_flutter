import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'policy_service.g.dart';

@RestApi()
abstract class PolicyService {
  factory PolicyService(Dio dio, {String baseUrl}) = _PolicyService;

  @GET('v1/policy')
  Future<PolicyResponseModel> getPolicies();
}
