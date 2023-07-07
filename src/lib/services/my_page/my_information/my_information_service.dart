import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/my_page/my_information/my_information_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'my_information_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class MyInformationService {
  factory MyInformationService(Dio dio, {String baseUrl}) =
      _MyInformationService;

  @GET('/my/info?memberIdx={memberIdx}')
  Future<MyInformationResponseModel?> getMyInformation(
    @Path("memberIdx") int memberIdx,
  );
}
