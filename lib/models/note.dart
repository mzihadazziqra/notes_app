import 'package:isar/isar.dart';

// This line is needed to generate file
// Then run: dart run build_runner build
// to generate the file
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String title;
  late String text;
}
