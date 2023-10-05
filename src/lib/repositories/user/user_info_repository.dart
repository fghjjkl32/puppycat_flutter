import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_response_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_info_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/user/user_info_service.dart';
import 'package:http_parser/http_parser.dart';

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

    ResponseModel? responseModel = await _userInfoService.restoreAccount(body);

    if (responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    return responseModel.result;
  }

  Future<UserInformationItemModel> getMyInfo(String memberIdx) async {
    UserInformationResponseModel? responseModel = await _userInfoService.getMyInfo(memberIdx);

    if (responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    if (responseModel.data == null || responseModel.data.info.isEmpty) {
      ///TODO
      throw "empty error";
    }

    UserInformationItemModel infoModel = responseModel.data.info!.first;

    return infoModel;
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

    ResponseModel? responseModel = await _userInfoService.updateMyInfo(params);

    if (responseModel == null) {
      throw "error";
    }

    return responseModel;
  }

  Future<bool> updateMyChatInfo(UserInfoModel userInfoModel) async {
    FormData params = FormData.fromMap({
      "memberIdx": userInfoModel.userModel!.idx,
      // "chatInfo" : {
      "chatMemberId": userInfoModel.chatUserModel!.chatMemberId,
      "chatHomeServer": userInfoModel.chatUserModel!.homeServer,
      "chatAccessToken": userInfoModel.chatUserModel!.accessToken,
      "chatDeviceId": userInfoModel.chatUserModel!.deviceId,
      "resetState": 0,
      // }
    });

    ResponseModel? responseModel = await _userInfoService.updateMyInfo(params);

    if (responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    return true;
  }

  //User Info
  Future<UserInformationResponseModel> getUserInformation(int? loginMemberIdx, int memberIdx) async {
    UserInformationResponseModel? userInformationResponseModel;

    loginMemberIdx == null
        ? userInformationResponseModel = await _userInfoService.getLogoutUserInformation(
            memberIdx,
          )
        : userInformationResponseModel = await _userInfoService.getUserInformation(
            loginMemberIdx,
            memberIdx,
          );

    if (userInformationResponseModel == null) {
      throw "error";
    }

    return userInformationResponseModel;
  }
}
