import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/main/popular_user_list/popular_user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/popular_user_list/popular_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/user_list/user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/user_list/user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/services/main/user_list/user_list_service.dart';

class UserListRepository {
  late final UserListService _userListService; // = UserListService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  UserListRepository({
    required this.dio,
  }) {
    _userListService = UserListService(dio, baseUrl: baseUrl);
  }

  Future<UserListDataListModel> getFavoriteUserList({
    int page = 1,
    int limit = 19,
  }) async {
    UserListResponseModel responseModel = await _userListService.getFavoriteUserList(page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'UserListRepository',
        caller: 'getFavoriteUserList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'UserListRepository',
        caller: 'getFavoriteUserList',
      );
    }

    return responseModel.data!;
  }

  Future<PopularUserListDataListModel> getPopularUserList() async {
    PopularUserListResponseModel responseModel = await _userListService.getPopularUserList();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'UserListRepository',
        caller: 'getPopularUserList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'UserListRepository',
        caller: 'getPopularUserList',
      );
    }

    return responseModel.data!;
  }
}
