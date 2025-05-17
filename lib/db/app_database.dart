import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/note.dart';
import '../models/user.dart';

class AppDatabase {
  static late Isar _isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([NoteSchema, UserSchema], directory: dir.path);
  }

  static Isar get isar => _isar;
}
