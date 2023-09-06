import 'package:freezed_annotation/freezed_annotation.dart';

part 'restrain_write_item_model.freezed.dart';
part 'restrain_write_item_model.g.dart';

@freezed
class RestrainWriteItemModel with _$RestrainWriteItemModel {
  factory RestrainWriteItemModel({
    String? nick,
    int? date,
    int? memberIdx,
    String? endDate,
    int? level,
    String? restrainName,
    String? id,
    int? state,
    int? idx,
    String? title,
    int? type,
    String? startDate,
  }) = _RestrainWriteItemModel;

  factory RestrainWriteItemModel.fromJson(Map<String, dynamic> json) => _$RestrainWriteItemModelFromJson(json);
}
