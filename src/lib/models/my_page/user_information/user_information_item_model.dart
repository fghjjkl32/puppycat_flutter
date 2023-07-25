import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_information_item_model.freezed.dart';
part 'user_information_item_model.g.dart';

@freezed
class UserInformationItemModel with _$UserInformationItemModel {
  factory UserInformationItemModel({
    int? memberIdx,
    String? nick,
    String? simpleType,
    String? name,
    String? phone,
    String? intro,
    String? profileImgUrl,
    String? email,
    int? followerCnt,
    int? followCnt,
    int? blockedState,
    int? blockedMeState,
    int? followState,
    //ChatInfo
    String? chatAccessToken,
    String? chatMemeberId,
    String? homeServer,
    String? deviceId,
  }) = _UserInformationItemModel;

  factory UserInformationItemModel.fromJson(Map<String, dynamic> json) =>
      _$UserInformationItemModelFromJson(json);
}
