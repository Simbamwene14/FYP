import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class DatabaseIsNotOpen implements Exception {}

class UserAlreadyExist implements Exception {}

class CouldNotDeleteUser implements Exception {}

class DatabaseIsOpen implements Exception {}

class CouldNotFindUser implements Exception {}

class DatabaseServices {
  Database? _db;

  //The DatabaseServices is made singleton
  static final DatabaseServices _shared = DatabaseServices._sharedInstance();
  DatabaseServices._sharedInstance();
  factory DatabaseServices() => _shared;


  Future<void> openDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    final db = await openDatabase(path, version: 1);
    _db = db;

    await db.execute(createTableMzazi);
    await db.execute(createTableMtoto);
  }

  Future<void> ensureDbIsOpen() async {
    try {
      await openDB();
    } on DatabaseIsOpen {
      // empty
    }
  }

  Future<void> closeDB() async {
    final db = _db;
    await db?.close();

    _db = null;
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<DatabaseMzazi> createMzazi(
      {required String email,
      required String jina,
      required String uhusiano}) async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      mzaziTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [
        email.toLowerCase(),
      ],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExist();
    }

    final mzaziId = await db.insert(mzaziTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseMzazi(
        id: mzaziId, jina: jina, email: email, uhusiano: uhusiano);
  }

  Future<DatabaseMzazi> getMzazi(
      {required String email}) async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      mzaziTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [
        email.toLowerCase(),
      ],
    );

    if (result.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseMzazi.fromRow(result.first);
    }
  }

  Future<DatabaseMtoto> createMtoto({
    required DatabaseMzazi owner,
    required String jina,
    required int umri,
    required String jinsia,
    required int mzaziId,
  }) async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final dbMtoto = await getMzazi(email: owner.email);

    if (dbMtoto != owner) {
      throw CouldNotFindUser();
    }

    final mtotoId = await db.insert(mtotoTable, {
      emailColumn: owner.email,
      mzaziIdColumn: owner.id,
      uhusinoColumn: owner.uhusiano,
    });

    final Mtoto = DatabaseMtoto(
        id: mtotoId,
        jina: jina,
        umri: umri,
        jinsia: jinsia,
        email: owner.email,
        mzaziId: mzaziId);

    return Mtoto;
  }

  Future<void> deleteMtoto({required int id}) async{
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      mzaziTable,
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );

    if(deletedCount == 0){
      throw CouldNotDeleteUser();
    }
  }

  Future<void> deleteMzazi({required String email}) async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      mzaziTable,
      where: 'email = ?',
      whereArgs: [
        email.toLowerCase(),
      ],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

}

@immutable
class DatabaseMzazi {
  final int id;
  final String jina;
  final String email;
  final String uhusiano;

  const DatabaseMzazi({
    required this.id,
    required this.jina,
    required this.email,
    required this.uhusiano,
  });

  DatabaseMzazi.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        jina = map[jinaColumn] as String,
        email = map[emailColumn] as String,
        uhusiano = map[uhusinoColumn] as String;

  @override
  String toString() =>
      "id = $id, jina = $jina, email = $email, uhusiano = $uhusiano";

  @override
  bool operator ==(covariant DatabaseMzazi other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseMtoto {
  final int id;
  final String jina;
  final int umri;
  final String jinsia;
  final String email;
  final int mzaziId;

  const DatabaseMtoto({
    required this.id,
    required this.jina,
    required this.umri,
    required this.jinsia,
    required this.email,
    required this.mzaziId,
  });

  DatabaseMtoto.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        jina = map[jinaColumn] as String,
        umri = map[umriColumn] as int,
        jinsia = map[jinsiaColumn] as String,
        email = map[emailColumn] as String,
        mzaziId = map[mzaziIdColumn] as int;

  @override
  String toString() =>
      "id = $id, jina = $jina, umri = $umri, jinsia = $jinsia, email = $email, mzaziId = $mzaziId";

  @override
  bool operator ==(covariant DatabaseMtoto other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//Database constant values
const dbName = 'users.db';
const mtotoTable = 'mtoto';
const mzaziTable = 'mzazi';
const idColumn = 'id';
const mzaziIdColumn = 'id';
const emailColumn = 'email';
const uhusinoColumn = 'uhusiano';
const jinaColumn = 'jina';
const umriColumn = 'umri';
const jinsiaColumn = 'jinsia';

const createTableMzazi = '''CREATE TABLE "mzazi" (
	"id"	INTEGER NOT NULL,
	"jina"	TEXT NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	"uhusiano"	TEXT NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';

const createTableMtoto = '''CREATE TABLE "mtoto" (
	"id"	INTEGER NOT NULL,
	"jina"	TEXT NOT NULL,
	"umri"	INTEGER NOT NULL,
	"jinsia"	TEXT NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	"mzaziId"	INTEGER NOT NULL,
	FOREIGN KEY("email") REFERENCES "mzazi"("email"),
	FOREIGN KEY("mzaziId") REFERENCES "mzazi"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
