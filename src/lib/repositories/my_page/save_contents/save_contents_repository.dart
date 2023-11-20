import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
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

  Future<ContentResponseModel> getSaveContents({required int memberIdx, required int page}) async {
    ContentResponseModel responseModel = await _saveContentsService.getSaveContents(memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SaveContentsRepository',
        caller: 'getSaveContents',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getSaveDetailContentList({required int loginMemberIdx, required int page}) async {
    FeedResponseModel responseModel = await _saveContentsService.getSaveDetailContentList(loginMemberIdx, page);

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
