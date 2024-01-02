import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_item_model.dart';

part 'withdrawal_detail_list_model.freezed.dart';
part 'withdrawal_detail_list_model.g.dart';

@freezed
class WithdrawalDetailListModel with _$WithdrawalDetailListModel {
  const factory WithdrawalDetailListModel({
    WithdrawalDetailItemModel? memberInfo,
  }) = _WithdrawalDetailListModel;

  factory WithdrawalDetailListModel.fromJson(Map<String, dynamic> json) => _$WithdrawalDetailListModelFromJson(json);
}
