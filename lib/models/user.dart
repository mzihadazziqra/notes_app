import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  Id id = 0;
  late String name;
  late String email;
}
