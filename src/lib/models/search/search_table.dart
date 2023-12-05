import 'package:drift/drift.dart';

class Searches extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get contentId => text().nullable()();

  TextColumn get name => text().withLength(min: 1, max: 50).nullable()();

  TextColumn get date => text().withLength(min: 1, max: 50).nullable()();

  TextColumn get content => text().withLength(min: 1, max: 50).nullable()();

  TextColumn get intro => text().withLength(min: 0, max: 50).nullable()();

  TextColumn get image => text().withLength(min: 0, max: 1000).nullable()();

  BoolColumn get isBadge => boolean().nullable()();

  DateTimeColumn get created => dateTime().nullable()();
}
