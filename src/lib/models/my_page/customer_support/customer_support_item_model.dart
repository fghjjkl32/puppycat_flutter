import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_support_item_model.freezed.dart';
part 'customer_support_item_model.g.dart';

@freezed
class CustomerSupportItemModel with _$CustomerSupportItemModel {
  factory CustomerSupportItemModel({
    String? contents,
    String? regDate,
    String? menuName,
    int? menuIdx,
    int? state,
    int? idx,
    String? title,
    int? isTop,
  }) = _CustomerSupportItemModel;

  factory CustomerSupportItemModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerSupportItemModelFromJson(json);
}
