import 'package:freezed_annotation/freezed_annotation.dart';

part 'restrain_item_model.freezed.dart';
part 'restrain_item_model.g.dart';

@freezed
class RestrainItemModel with _$RestrainItemModel {
  factory RestrainItemModel({
    int? date,
    String? nick,
    String? memberUuid,
    String? startDate,
    String? endDate,
    String? restrainType,
    String? id,
    String? restrainName,
    int? state,
    int? idx,
  }) = _RestrainItemModel;

  factory RestrainItemModel.fromJson(Map<String, dynamic> json) => _$RestrainItemModelFromJson(json);
}
