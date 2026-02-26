import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'local_sql_schema.dart';

Future<Database> openLingoIlDatabase() async {
  final appDir = await getApplicationDocumentsDirectory();
  final path = p.join(appDir.path, 'lingoil.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      for (final statement in localDbMigrations) {
        await db.execute(statement);
      }
    },
  );
}
