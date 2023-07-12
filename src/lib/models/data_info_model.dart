import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_info_model.freezed.dart';
part 'data_info_model.g.dart';

@freezed
@JsonSerializable(genericArgumentFactories: true)
class DataInfoModel<T> with _$DataInfoModel<T> {
  factory DataInfoModel({
    required List<T> info,
  }) = _DataInfoModel<T>;

  factory DataInfoModel.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$DataInfoModelFromJson<T>(json, fromJsonT);
  }
}
