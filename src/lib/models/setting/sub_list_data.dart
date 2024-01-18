import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_list_data.freezed.dart';
part 'sub_list_data.g.dart';

@freezed
class SubListData with _$SubListData {
  factory SubListData({
    String? regDateTz,
    int? notiType,
    String? regDate,
    int? subType,
    int? state,
    int? idx,
  }) = _SubListData;

  factory SubListData.fromJson(Map<String, dynamic> json) =>
      _$SubListDataFromJson(json);
}
