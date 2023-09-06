import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_detail_item_model.freezed.dart';
part 'withdrawal_detail_item_model.g.dart';

@freezed
class WithdrawalDetailItemModel with _$WithdrawalDetailItemModel {
  factory WithdrawalDetailItemModel({
    int? isBadge,
    String? totalActivityTime,
    String? totalContentsCnt,
    String? totalSaveCnt,
    String? totalTagCnt,
  }) = _WithdrawalDetailItemModel;

  factory WithdrawalDetailItemModel.fromJson(Map<String, dynamic> json) => _$WithdrawalDetailItemModelFromJson(json);
}
