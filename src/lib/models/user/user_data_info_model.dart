import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data_info_model.freezed.dart';
part 'user_data_info_model.g.dart';

@freezed
@JsonSerializable(genericArgumentFactories: true)
class DataInfoModel<T> with _$DataInfoModel<T> {
  factory DataInfoModel({
    required List<T> info,
    String? imgDomain,
  }) = _DataInfoModel<T>;

  factory DataInfoModel.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$DataInfoModelFromJson<T>(json, fromJsonT);
  }
}
