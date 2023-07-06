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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, image];
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
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
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
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
    );
  }

  @override
  $SearchesTable createAlias(String alias) {
    return $SearchesTable(attachedDatabase, alias);
  }
}

class Searche extends DataClass implements Insertable<Searche> {
  final int id;
  final String name;
  final String? image;
  const Searche({required this.id, required this.name, this.image});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    return map;
  }

  SearchesCompanion toCompanion(bool nullToAbsent) {
    return SearchesCompanion(
      id: Value(id),
      name: Value(name),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
    );
  }

  factory Searche.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Searche(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      image: serializer.fromJson<String?>(json['image']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'image': serializer.toJson<String?>(image),
    };
  }

  Searche copyWith(
          {int? id,
          String? name,
          Value<String?> image = const Value.absent()}) =>
      Searche(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image.present ? image.value : this.image,
      );
  @override
  String toString() {
    return (StringBuffer('Searche(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, image);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Searche &&
          other.id == this.id &&
          other.name == this.name &&
          other.image == this.image);
}

class SearchesCompanion extends UpdateCompanion<Searche> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> image;
  const SearchesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
  });
  SearchesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.image = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Searche> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? image,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
    });
  }

  SearchesCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String?>? image}) {
    return SearchesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('image: $image')
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
