// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_db_helper.dart';

// ignore_for_file: type=lint
class $SearchesTable extends Searches with TableInfo<$SearchesTable, Searche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _contentIdMeta =
      const VerificationMeta('contentId');
  @override
  late final GeneratedColumn<int> contentId = GeneratedColumn<int>(
      'content_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _introMeta = const VerificationMeta('intro');
  @override
  late final GeneratedColumn<String> intro = GeneratedColumn<String>(
      'intro', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 0, maxTextLength: 1000),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _isBadgeMeta =
      const VerificationMeta('isBadge');
  @override
  late final GeneratedColumn<bool> isBadge = GeneratedColumn<bool>(
      'is_badge', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_badge" IN (0, 1))'));
  static const VerificationMeta _createdMeta =
      const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
      'created', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, contentId, name, date, content, intro, image, isBadge, created];
  @override
  String get aliasedName => _alias ?? 'searches';
  @override
  String get actualTableName => 'searches';
  @override
  VerificationContext validateIntegrity(Insertable<Searche> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content_id')) {
      context.handle(_contentIdMeta,
          contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('intro')) {
      context.handle(
          _introMeta, intro.isAcceptableOrUnknown(data['intro']!, _introMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('is_badge')) {
      context.handle(_isBadgeMeta,
          isBadge.isAcceptableOrUnknown(data['is_badge']!, _isBadgeMeta));
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Searche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Searche(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      contentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}content_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content']),
      intro: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}intro']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      isBadge: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_badge']),
      created: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created']),
    );
  }

  @override
  $SearchesTable createAlias(String alias) {
    return $SearchesTable(attachedDatabase, alias);
  }
}

class Searche extends DataClass implements Insertable<Searche> {
  final int id;
  final int? contentId;
  final String? name;
  final String? date;
  final String? content;
  final String? intro;
  final String? image;
  final bool? isBadge;
  final DateTime? created;
  const Searche(
      {required this.id,
      this.contentId,
      this.name,
      this.date,
      this.content,
      this.intro,
      this.image,
      this.isBadge,
      this.created});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || contentId != null) {
      map['content_id'] = Variable<int>(contentId);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || intro != null) {
      map['intro'] = Variable<String>(intro);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || isBadge != null) {
      map['is_badge'] = Variable<bool>(isBadge);
    }
    if (!nullToAbsent || created != null) {
      map['created'] = Variable<DateTime>(created);
    }
    return map;
  }

  SearchesCompanion toCompanion(bool nullToAbsent) {
    return SearchesCompanion(
      id: Value(id),
      contentId: contentId == null && nullToAbsent
          ? const Value.absent()
          : Value(contentId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      intro:
          intro == null && nullToAbsent ? const Value.absent() : Value(intro),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      isBadge: isBadge == null && nullToAbsent
          ? const Value.absent()
          : Value(isBadge),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
    );
  }

  factory Searche.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Searche(
      id: serializer.fromJson<int>(json['id']),
      contentId: serializer.fromJson<int?>(json['contentId']),
      name: serializer.fromJson<String?>(json['name']),
      date: serializer.fromJson<String?>(json['date']),
      content: serializer.fromJson<String?>(json['content']),
      intro: serializer.fromJson<String?>(json['intro']),
      image: serializer.fromJson<String?>(json['image']),
      isBadge: serializer.fromJson<bool?>(json['isBadge']),
      created: serializer.fromJson<DateTime?>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contentId': serializer.toJson<int?>(contentId),
      'name': serializer.toJson<String?>(name),
      'date': serializer.toJson<String?>(date),
      'content': serializer.toJson<String?>(content),
      'intro': serializer.toJson<String?>(intro),
      'image': serializer.toJson<String?>(image),
      'isBadge': serializer.toJson<bool?>(isBadge),
      'created': serializer.toJson<DateTime?>(created),
    };
  }

  Searche copyWith(
          {int? id,
          Value<int?> contentId = const Value.absent(),
          Value<String?> name = const Value.absent(),
          Value<String?> date = const Value.absent(),
          Value<String?> content = const Value.absent(),
          Value<String?> intro = const Value.absent(),
          Value<String?> image = const Value.absent(),
          Value<bool?> isBadge = const Value.absent(),
          Value<DateTime?> created = const Value.absent()}) =>
      Searche(
        id: id ?? this.id,
        contentId: contentId.present ? contentId.value : this.contentId,
        name: name.present ? name.value : this.name,
        date: date.present ? date.value : this.date,
        content: content.present ? content.value : this.content,
        intro: intro.present ? intro.value : this.intro,
        image: image.present ? image.value : this.image,
        isBadge: isBadge.present ? isBadge.value : this.isBadge,
        created: created.present ? created.value : this.created,
      );
  @override
  String toString() {
    return (StringBuffer('Searche(')
          ..write('id: $id, ')
          ..write('contentId: $contentId, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('content: $content, ')
          ..write('intro: $intro, ')
          ..write('image: $image, ')
          ..write('isBadge: $isBadge, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, contentId, name, date, content, intro, image, isBadge, created);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Searche &&
          other.id == this.id &&
          other.contentId == this.contentId &&
          other.name == this.name &&
          other.date == this.date &&
          other.content == this.content &&
          other.intro == this.intro &&
          other.image == this.image &&
          other.isBadge == this.isBadge &&
          other.created == this.created);
}

class SearchesCompanion extends UpdateCompanion<Searche> {
  final Value<int> id;
  final Value<int?> contentId;
  final Value<String?> name;
  final Value<String?> date;
  final Value<String?> content;
  final Value<String?> intro;
  final Value<String?> image;
  final Value<bool?> isBadge;
  final Value<DateTime?> created;
  const SearchesCompanion({
    this.id = const Value.absent(),
    this.contentId = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.content = const Value.absent(),
    this.intro = const Value.absent(),
    this.image = const Value.absent(),
    this.isBadge = const Value.absent(),
    this.created = const Value.absent(),
  });
  SearchesCompanion.insert({
    this.id = const Value.absent(),
    this.contentId = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.content = const Value.absent(),
    this.intro = const Value.absent(),
    this.image = const Value.absent(),
    this.isBadge = const Value.absent(),
    this.created = const Value.absent(),
  });
  static Insertable<Searche> custom({
    Expression<int>? id,
    Expression<int>? contentId,
    Expression<String>? name,
    Expression<String>? date,
    Expression<String>? content,
    Expression<String>? intro,
    Expression<String>? image,
    Expression<bool>? isBadge,
    Expression<DateTime>? created,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contentId != null) 'content_id': contentId,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (content != null) 'content': content,
      if (intro != null) 'intro': intro,
      if (image != null) 'image': image,
      if (isBadge != null) 'is_badge': isBadge,
      if (created != null) 'created': created,
    });
  }

  SearchesCompanion copyWith(
      {Value<int>? id,
      Value<int?>? contentId,
      Value<String?>? name,
      Value<String?>? date,
      Value<String?>? content,
      Value<String?>? intro,
      Value<String?>? image,
      Value<bool?>? isBadge,
      Value<DateTime?>? created}) {
    return SearchesCompanion(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      name: name ?? this.name,
      date: date ?? this.date,
      content: content ?? this.content,
      intro: intro ?? this.intro,
      image: image ?? this.image,
      isBadge: isBadge ?? this.isBadge,
      created: created ?? this.created,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<int>(contentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (intro.present) {
      map['intro'] = Variable<String>(intro.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (isBadge.present) {
      map['is_badge'] = Variable<bool>(isBadge.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchesCompanion(')
          ..write('id: $id, ')
          ..write('contentId: $contentId, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('content: $content, ')
          ..write('intro: $intro, ')
          ..write('image: $image, ')
          ..write('isBadge: $isBadge, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }
}

abstract class _$SearchDbHelper extends GeneratedDatabase {
  _$SearchDbHelper(QueryExecutor e) : super(e);
  late final $SearchesTable searches = $SearchesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [searches];
}
