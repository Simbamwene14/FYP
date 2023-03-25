import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseIsNotOpen implements Exception {}

class UserAlreadyExist implements Exception {}

class CouldNotDeleteUser implements Exception {}

class CouldNotFindUser implements Exception {}

class DbServices {
  Database? _db;

  Future<DatabaseMtoto> createMtoto({
    required String email,
    required String jina,
    required int umri,
    required int uzito,
    required String jinsia,
    required String uhusiano,
  }) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      mtotoTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [
        email.toLowerCase(),
      ],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExist();
    }
    final mtotoID = await db.insert(mtotoTable, {
      emailColumn: email.toLowerCase(),
      jinaColumn: jina,
      jinsiaColumn: jinsia,
      umriColumn: umri,
      uhusinoColumn: uhusiano,
      uzitoColumn: uzito,
    });

    return DatabaseMtoto(
      id: mtotoID,
      jina: jina,
      umri: umri,
      uzito: uzito,
      jinsia: jinsia,
      email: email,
      uhusiano: uhusiano,
    );
  }

  Future<DatabaseMzazi> createMzazi({required DatabaseMtoto mzazi}) async {
    final db = _getDatabaseOrThrow();

    final dbMzazi = await getUser(email: mzazi.email);

    if (dbMzazi != mzazi) {
      throw CouldNotFindUser();
    }

    final mzaziId = await db.insert(mzaziTable, {
      emailColumn: mzazi.email,
      jinaColumn: mzazi.jina,
    });

    final Mzazi = DatabaseMzazi(
      id: mzaziId,
      email: mzazi.email,
      jina: mzazi.jina,
    );

    return Mzazi;
  }

  Future<void> deleteMzazi({required int id}) async{
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

  Future<DatabaseMtoto> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      mtotoTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [
        email.toLowerCase(),
      ],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseMtoto.fromMap(results.first);
    }
  }

  Future<void> deleteUser({required String email}) async {
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

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> closeDb() async {
    final db = _db;
    await db?.close;
    _db = null;
  }

  Future<void> openDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    final db = await openDatabase(path, version: 1);
    _db = db;
    await db.execute(createTablemtoto);
    await db.execute(createTableMzazi);
  }
}

@immutable
class DatabaseMtoto {
  final int id;
  final String jina;
  final int umri;
  final int uzito;
  final String jinsia;
  final String email;
  final String uhusiano;

  const DatabaseMtoto({
    required this.id,
    required this.jina,
    required this.umri,
    required this.uzito,
    required this.jinsia,
    required this.email,
    required this.uhusiano,
  });

  DatabaseMtoto.fromMap(Map<String, Object?> map)
      : id = map[idColumn] as int,
        jina = map[jinaColumn] as String,
        umri = map[umriColumn] as int,
        uzito = map[uzitoColumn] as int,
        jinsia = map[jinsiaColumn] as String,
        email = map[emailColumn] as String,
        uhusiano = map[uhusinoColumn] as String;

  @override
  String toString() =>
      'Mtoto, ID=$id, jina=$jina, umri=$umri, uzito=$uzito, jinsia=$jinsia, email=$email , uhusiano=$uhusiano';

  @override
  bool operator ==(covariant DatabaseMtoto other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseMzazi {
  final int id;
  final String email;
  final String jina;

  const DatabaseMzazi({
    required this.id,
    required this.email,
    required this.jina,
  });

  DatabaseMzazi.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String,
        jina = map[jinaColumn] as String;

  @override
  String toString() => 'Mzazi, id = $id, email = $email, jina = $jina';

  @override
  bool operator ==(covariant DatabaseMzazi other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//Database Constants
const dbName = 'users.db';
const mtotoTable = 'mtoto';
const mzaziTable = 'mzazi';
const idColumn = 'id';
const emailColumn = 'email';
const uhusinoColumn = 'uhusiano';
const jinaColumn = 'jina';
const umriColumn = 'umri';
const uzitoColumn = 'uzito';
const jinsiaColumn = 'jinsia';
const createTableMzazi = '''CREATE TABLE IF NOT EXISTS "mzazi" (
      "id"	INTEGER NOT NULL,
      "email"	TEXT NOT NULL UNIQUE,
      "jina"	TEXT NOT NULL,
      "uhusiano"	TEXT NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
      );
    ''';
const createTablemtoto = '''CREATE TABLE IF NOT EXISTS "mtoto" (
      "id"	INTEGER NOT NULL,
      "jina"	TEXT NOT NULL,
      "umri"	INTEGER NOT NULL,
      "uzito"	INTEGER NOT NULL,
      "jinsia"	TEXT NOT NULL,
      "id_ya_mzazi"	INTEGER NOT NULL,
      "email"	TEXT NOT NULL,
      FOREIGN KEY("email") REFERENCES "mzazi"("email"),
      FOREIGN KEY("id_ya_mzazi") REFERENCES "mzazi"("id"),
      PRIMARY KEY("id" AUTOINCREMENT),
      );
    ''';
