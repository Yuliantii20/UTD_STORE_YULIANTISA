import 'package:isar/isar.dart';

part 'bookmark_model.g.dart';

@collection
class Bookmark {
  Id id = Isar.autoIncrement;

  late String title;
  late double price;
  late DateTime createdAt;
  late DateTime savedAt;
}