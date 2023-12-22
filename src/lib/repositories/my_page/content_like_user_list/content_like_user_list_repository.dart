import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/content_like_user_list/content_like_user_list_service.dart';

class ContentLikeUserListRepository {
  late final ContentLikeUserListService _contentLikeUserListService;

  final Dio dio;

  ContentLikeUserListRepository({
    required this.dio,
  }) {
    _contentLikeUserListService = ContentLikeUserListService(dio, baseUrl: baseUrl);
  }

  Future<ContentLikeUserListDataListModel> getContentLikeUserList({
    required int contentsIdx,
    required int page,
  }) async {
    ContentLikeUserListResponseModel responseModel = await _contentLikeUserListService.getContentLikeUserList(contentsIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ContentLikeUserListRepository',
        caller: 'getContentLikeUserList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'ContentLikeUserListRepository',
        caller: 'getContentLikeUserList',
      );
    }

    return responseModel.data!;
  }
}
