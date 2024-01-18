import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/user_list/content_like_user_list/content_like_user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/user_list/content_like_user_list/content_like_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/services/user_list/user_list_service.dart';

class ContentLikeUserListRepository {
  late final UserListService _userListService;

  final Dio dio;

  ContentLikeUserListRepository({
    required this.dio,
  }) {
    _userListService = UserListService(dio, baseUrl: baseUrl);
  }

  Future<ContentLikeUserListDataListModel> getContentLikeUserList({
    required int contentsIdx,
    required int page,
  }) async {
    ContentLikeUserListResponseModel responseModel = await _userListService.getContentLikeUserList(contentsIdx, page);

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
