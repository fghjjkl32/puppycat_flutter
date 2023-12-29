import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_item_model.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/restrain/restrain_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/restrain/restrain_service.dart';

class RestrainRepository {
  late final RestrainService _restrainService;

  final Dio dio;

  RestrainRepository({
    required this.dio,
  }) {
    _restrainService = RestrainService(dio, baseUrl: memberBaseUrl);
  }

  Future<RestrainItemModel> getRestrainDetail(RestrainType type) async {
    RestrainResponseModel responseModel = await _restrainService.getRestrainDetail(type.index);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'RestrainRepository',
        caller: 'getWriteRestrain',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'RestrainRepository',
        caller: 'getWriteRestrain',
      );
    }

    if (responseModel.data!.restrain == null) {
      throw APIException(
        msg: 'restrain is null',
        code: 'Restrain-null', //백단에서 제재가 이미 풀렸을 때,
        refer: 'RestrainRepository',
        caller: 'getWriteRestrain',
      );
    }

    return responseModel.data!.restrain!;
  }
}
