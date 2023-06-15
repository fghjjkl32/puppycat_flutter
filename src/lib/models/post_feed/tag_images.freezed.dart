// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_images.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TagImages _$TagImagesFromJson(Map<String, dynamic> json) {
  return _TagImages.fromJson(json);
}

/// @nodoc
mixin _$TagImages {
  int get index => throw _privateConstructorUsedError;
  List<Offset> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagImagesCopyWith<TagImages> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagImagesCopyWith<$Res> {
  factory $TagImagesCopyWith(TagImages value, $Res Function(TagImages) then) =
      _$TagImagesCopyWithImpl<$Res, TagImages>;
  @useResult
  $Res call({int index, List<Offset> tags});
}

/// @nodoc
class _$TagImagesCopyWithImpl<$Res, $Val extends TagImages>
    implements $TagImagesCopyWith<$Res> {
  _$TagImagesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TagImagesCopyWith<$Res> implements $TagImagesCopyWith<$Res> {
  factory _$$_TagImagesCopyWith(
          _$_TagImages value, $Res Function(_$_TagImages) then) =
      __$$_TagImagesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int index, List<Offset> tags});
}

/// @nodoc
class __$$_TagImagesCopyWithImpl<$Res>
    extends _$TagImagesCopyWithImpl<$Res, _$_TagImages>
    implements _$$_TagImagesCopyWith<$Res> {
  __$$_TagImagesCopyWithImpl(
      _$_TagImages _value, $Res Function(_$_TagImages) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? tags = null,
  }) {
    return _then(_$_TagImages(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@OffsetConverter()
class _$_TagImages implements _TagImages {
  _$_TagImages({required this.index, required final List<Offset> tags})
      : _tags = tags;

  factory _$_TagImages.fromJson(Map<String, dynamic> json) =>
      _$$_TagImagesFromJson(json);

  @override
  final int index;
  final List<Offset> _tags;
  @override
  List<Offset> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'TagImages(index: $index, tags: $tags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TagImages &&
            (identical(other.index, index) || other.index == index) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, index, const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TagImagesCopyWith<_$_TagImages> get copyWith =>
      __$$_TagImagesCopyWithImpl<_$_TagImages>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TagImagesToJson(
      this,
    );
  }
}

abstract class _TagImages implements TagImages {
  factory _TagImages(
      {required final int index,
      required final List<Offset> tags}) = _$_TagImages;

  factory _TagImages.fromJson(Map<String, dynamic> json) =
      _$_TagImages.fromJson;

  @override
  int get index;
  @override
  List<Offset> get tags;
  @override
  @JsonKey(ignore: true)
  _$$_TagImagesCopyWith<_$_TagImages> get copyWith =>
      throw _privateConstructorUsedError;
}
