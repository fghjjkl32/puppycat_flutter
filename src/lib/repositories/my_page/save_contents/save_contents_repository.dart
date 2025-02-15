import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/save_contents/save_contents_service.dart';

class SaveContentsRepository {
  late final SaveContentsService _saveContentsService; // = SaveContentsService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  SaveContentsRepository({
    required this.dio,
  }) {
    _saveContentsService = SaveContentsService(dio, baseUrl: baseUrl);
  }

  Future<ContentDataListModel> getSaveContents({
    required int page,
    int limit = 15,
  }) async {
    ContentResponseModel responseModel = await _saveContentsService.getSaveContents(page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SaveContentsRepository',
        caller: 'getSaveContents',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'SaveContentsRepository',
        caller: 'getSaveContents',
      );
    }

    return responseModel.data!;
  }

  Future<FeedResponseModel> getSaveDetailContentList({
    required int page,
    int limit = 10,
    int imgLimit = 12,
  }) async {
    FeedResponseModel responseModel = await _saveContentsService.getSaveDetailContentList(page, limit, imgLimit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SaveContentsRepository',
        caller: 'getSaveDetailContentList',
      );
    }

    return responseModel;
  }
}
