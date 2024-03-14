import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/keep_contents/keep_contents_service.dart';

class KeepContentsRepository {
  late final KeepContentsService _keepContentsService;
  final Dio dio;

  KeepContentsRepository({
    required this.dio,
  }) {
    _keepContentsService = KeepContentsService(dio, baseUrl: baseUrl);
  }

  Future<ContentDataListModel> getKeepContents({
    required int page,
    int limit = 15,
  }) async {
    ContentResponseModel responseModel = await _keepContentsService.getKeepContents(page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'getKeepContents',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'getKeepContents',
      );
    }

    return responseModel.data!;
  }

  Future<FeedResponseModel> getMyKeepContentDetail({
    required int contentIdx,
    int imgLimit = 12,
  }) async {
    FeedResponseModel responseModel = await _keepContentsService.getMyKeepContentDetail(contentIdx, imgLimit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'getMyKeepContentDetail',
        arguments: [responseModel.data],
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteKeepContents({required String idx}) async {
    print('idx $idx');
    ResponseModel responseModel = await _keepContentsService.deleteKeepContents(idx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'deleteKeepContents',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteOneKeepContents({required int idx}) async {
    ResponseModel responseModel = await _keepContentsService.deleteOneKeepContents(idx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'deleteOneKeepContents',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> postKeepContents({required List<int> idxList}) async {
    Map<String, dynamic> body = {
      "idxList": idxList,
    };

    ResponseModel responseModel = await _keepContentsService.postKeepContents(body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'postKeepContents',
      );
    }

    return responseModel;
  }
}
