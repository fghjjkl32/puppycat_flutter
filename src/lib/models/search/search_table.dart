import 'package:drift/drift.dart';

class Searches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get image => text().nullable()();
}
