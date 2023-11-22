import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_response_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/user/user_info_service.dart';

// final accountRepositoryProvider = Provider((ref) => AccountRepository());
final userInfoRepositoryProvider = Provider.family<UserInfoRepository, Dio>((ref, dio) => UserInfoRepository(dio: dio));

class UserInfoRepository {
  late final UserInfoService _userInfoService; // = UserInfoService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  UserInfoRepository({
    required this.dio,
  }) {
    _userInfoService = UserInfoService(dio, baseUrl: baseUrl);
  }

  Future<bool> restoreAccount(String simpleId) async {
    Map<String, dynamic> body = {
      "simpleId": simpleId,
    };

    ResponseModel responseModel = await _userInfoService.restoreAccount(body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'UserInfoRepository',
        caller: 'restoreAccount',
      );
    }

    return responseModel.result;
  }

  Future<UserInformationItemModel> getMyInfo(String memberIdx) async {
    UserInformationResponseModel responseModel = await _userInfoService.getMyInfo(memberIdx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'UserInfoRepository',
        caller: 'getMyInfo',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'UserInfoRepository',
        caller: 'getMyInfo',
      );
    }

    if (responseModel.data!.info.isEmpty) {
      throw APIException(
        msg: 'data info is null(or empty)',
        code: responseModel.code,
        refer: 'UserInfoRepository',
        caller: 'getMyInfo',
      );
    }

    return responseModel.data!.info.first;
  }

  Future<ResponseModel> updateMyInfo(UserModel userInfoModel, XFile? file, String beforeNick, bool isProfileImageDelete, bool isPhoneNumberEdit) async {
    // 기본 파라미터 설정
    Map<String, dynamic> baseParams = {
      "intro": userInfoModel.introText,
      "memberIdx": userInfoModel.idx,
      "name": userInfoModel.name,
      "resetState": isProfileImageDelete ? 1 : 0,
    };

    // nick 변경이 있는 경우에만 추가
    if (beforeNick != userInfoModel.nick) {
      baseParams["nick"] = userInfoModel.nick;
    }

    // 본인인증 한 경우에만 추가
    if (isPhoneNumberEdit) {
      baseParams["phone"] = userInfoModel.phone;
      baseParams["ci"] = userInfoModel.ci;
      baseParams["di"] = userInfoModel.di;
    }

    // 파일이 있는 경우에만 추가
    if (file != null) {
      baseParams["uploadFile"] = MultipartFile.fromFileSync(
        file.path,
        contentType: MediaType('image', 'jpg'),
      );
    }

    FormData params = FormData.fromMap(baseParams);

    ResponseModel responseModel = await _userInfoService.updateMyInfo(params);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'UserInfoRepository',
        caller: 'updateMyInfo',
      );
    }

    return responseModel;
  }

  ///NOTE
  ///2023.11.17.
  ///채팅 교체 예정으로 일단 주석 처리
  // Future<bool> updateMyChatInfo(UserInfoModel userInfoModel) async {
  //   FormData params = FormData.fromMap({
  //     "memberIdx": userInfoModel.userModel!.idx,
  //     // "chatInfo" : {
  //     "chatMemberId": userInfoModel.chatUserModel!.chatMemberId,
  //     "chatHomeServer": userInfoModel.chatUserModel!.homeServer,
  //     "chatAccessToken": userInfoModel.chatUserModel!.accessToken,
  //     "chatDeviceId": userInfoModel.chatUserModel!.deviceId,
  //     "resetState": 0,
  //     // }
  //   });
  //
  //   ResponseModel? responseModel = await _userInfoService.updateMyInfo(params);
  //
  //   if (responseModel == null) {
  //     ///TODO
  //     ///throw로 할지 그냥 return null로 할지 생각해보기
  //     throw "error";
  //   }
  //
  //   return true;
  // }
  ///여기까지 채팅 교체 주석

  //User Info
  Future<UserInformationResponseModel> getUserInformation(int? loginMemberIdx, int memberIdx) async {
    UserInformationResponseModel responseModel;

    loginMemberIdx == null
        ? responseModel = await _userInfoService.getLogoutUserInformation(
            memberIdx,
          )
        : responseModel = await _userInfoService.getUserInformation(
            loginMemberIdx,
            memberIdx,
          );

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'UserInfoRepository',
        caller: 'getUserInformation',
      );
    }

    return responseModel;
  }
}
