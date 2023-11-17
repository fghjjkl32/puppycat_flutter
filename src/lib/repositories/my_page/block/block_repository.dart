import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
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

  Future<SearchResponseModel> getBlockSearchList({
    required int memberIdx,
    required int page,
    required String searchWord,
  }) async {
    SearchResponseModel responseModel = await _blockService.getBlockSearchList(memberIdx, page, searchWord);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'BlockRepository',
        caller: 'getBlockSearchList',
      );
    }

    return responseModel;
  }

  Future<SearchResponseModel> getBlockList({
    required int memberIdx,
    required int page,
  }) async {
    SearchResponseModel responseModel = await _blockService.getBlockList(memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'BlockRepository',
        caller: 'getBlockList',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteBlock({
    required int blockIdx,
    required int memberIdx,
  }) async {
    ResponseModel responseModel = await _blockService.deleteBlock(blockIdx, memberIdx);

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

  Future<ResponseModel> postBlock({
    required int blockIdx,
    required int memberIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel responseModel = await _blockService.postBlock(blockIdx, body);

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
