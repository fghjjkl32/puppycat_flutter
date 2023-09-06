import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_list_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_data_info_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';

part 'withdrawal_detail_response_model.freezed.dart';
part 'withdrawal_detail_response_model.g.dart';

@freezed
class WithdrawalDetailResponseModel with _$WithdrawalDetailResponseModel {
  factory WithdrawalDetailResponseModel({
    required bool result,
    required String code,
    required WithdrawalDetailListModel data,
    String? message,
  }) = _WithdrawalDetailResponseModel;

  factory WithdrawalDetailResponseModel.fromJson(Map<String, dynamic> json) => _$WithdrawalDetailResponseModelFromJson(json);
}
