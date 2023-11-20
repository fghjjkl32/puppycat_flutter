import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_response_model.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_write_item_model.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_write_list_model.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_write_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/withdrawal/withdrawal_provider.dart';
import 'package:pet_mobile_social_flutter/services/restrain/restrain_service.dart';
import 'package:pet_mobile_social_flutter/services/withdrawal/withdrawal_service.dart';

class RestrainRepository {
  late final RestrainService _restrainService;

  final Dio dio;

  RestrainRepository({
    required this.dio,
  }) {
    _restrainService = RestrainService(dio, baseUrl: baseUrl);
  }

  Future<RestrainWriteResponseModel> getWriteRestrain(memberIdx) async {
    RestrainWriteResponseModel responseModel = await _restrainService.getWriteRestrain(memberIdx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'RestrainRepository',
        caller: 'getWriteRestrain',
      );
    }

    return responseModel;
  }
}
