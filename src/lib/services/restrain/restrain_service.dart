import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_response_model.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_write_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restrain_service.g.dart';

@RestApi()
abstract class RestrainService {
  factory RestrainService(Dio dio, {String baseUrl}) = _RestrainService;

  @GET('v1/restrain/write/{memberIdx}')
  Future<RestrainWriteResponseModel> getWriteRestrain(
    @Path("memberIdx") int memberIdx,
  );
}
