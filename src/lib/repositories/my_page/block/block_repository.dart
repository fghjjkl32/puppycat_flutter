import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/block/block_service.dart';

class BlockRepository {
  late final BlockService _blockService; //= BlockService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  BlockRepository({
    required this.dio,
  }) {
    _blockService = BlockService(dio, baseUrl: baseUrl);
  }

  Future<SearchDataListModel> getBlockSearchList({
    required int page,
    required String searchWord,
    int limit = 30,
  }) async {
    SearchResponseModel responseModel = await _blockService.getBlockList(searchWord, page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'BlockRepository',
        caller: 'getBlockSearchList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'BlockRepository',
        caller: 'getBlockSearchList',
      );
    }

    return responseModel.data!;
  }

  Future<SearchDataListModel> getBlockList({
    required int page,
    int limit = 30,
  }) async {
    SearchResponseModel responseModel = await _blockService.getBlockList(null, page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'BlockRepository',
        caller: 'getBlockList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'BlockRepository',
        caller: 'getBlockList',
      );
    }

    return responseModel.data!;
  }

  Future<ResponseModel> deleteBlock({
    required String blockUuid,
  }) async {
    ResponseModel responseModel = await _blockService.deleteBlock(blockUuid);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'BlockRepository',
        caller: 'deleteBlock',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> postBlock({required String blockUuid}) async {
    ResponseModel responseModel = await _blockService.postBlock(blockUuid);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'BlockRepository',
        caller: 'postBlock',
      );
    }

    return responseModel;
  }
}
