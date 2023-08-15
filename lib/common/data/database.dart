import 'package:address_book/common/domain/address_model.dart';
import 'package:address_book/common/domain/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@singleton
class DatabaseProvider {
  Future<Database> get database async => openDatabase(
        join(await getDatabasesPath(), 'address_book.db'),
        onCreate: _createDatabase,
        onConfigure: _onConfigure,
        version: 1,
      );

  Future<void> _createDatabase(Database db, int version) async {
    db.execute(
      'CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT)',
    );
    db.execute(
      'CREATE TABLE address(id INTEGER PRIMARY KEY, postalCode TEXT, street TEXT, number TEXT, complement TEXT, neighborhood TEXT, city TEXT, estado TEXT, userId INTEGER, FOREIGN KEY(userId) REFERENCES user(id))',
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<int> insertUser(UserModel user) async {
    final db = await database;

    final int id = await db.insert(
      'user',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    return id;
  }

  Future<List<UserModel>> findUsers() async {
    final db = await database;

    final result = await db.query('user');

    return result.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel?> findUserByEmail(String email) async {
    final db = await database;

    final result =
        await db.query('user', where: 'email = ?', whereArgs: [email]);

    return result.isNotEmpty ? UserModel.fromJson(result.first) : null;
  }

  Future<UserModel?> findUserById(int id) async {
    final db = await database;

    final result = await db.query('user', where: 'id = ?', whereArgs: [id]);

    return result.isNotEmpty ? UserModel.fromJson(result.first) : null;
  }

  Future<void> updateUser(UserModel user) async {
    final db = await database;

    await db.update(
      'user',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> insertAddress(AddressModel address) async {
    final db = await database;

    await db.insert(
      'address',
      address.toJson(),
    );
  }

  Future<void> updateAddress(AddressModel address) async {
    final db = await database;

    await db.update(
      'address',
      address.toJson(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  Future<void> removeAddress(int addressId) async {
    final db = await database;

    await db.delete('address', where: 'id = ?', whereArgs: [addressId]);
  }

  Future<List<AddressModel>> findAddresses(int userId) async {
    final db = await database;

    final result =
        await db.query('address', where: 'userId = ?', whereArgs: [userId]);

    return result.map((json) => AddressModel.fromJson(json)).toList();
  }
}
