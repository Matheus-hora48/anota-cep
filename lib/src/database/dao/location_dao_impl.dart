import 'package:anota_cep/src/database/dao/location_dao.dart';
import 'package:anota_cep/src/database/sqlite_database.dart';
import 'package:anota_cep/src/models/location_model.dart';

class LocationDaoImpl implements LocationDao {
  final SQLiteDatabase databaseProvider;

  LocationDaoImpl(this.databaseProvider);

  var dbName = 'locations';

  @override
  Future<int> saveLocation(LocationModel location) async {
    final db = await databaseProvider.database;
    return await db.insert(dbName, location.toMap());
  }

  @override
  Future<List<LocationModel>> getAllLocations() async {
    final db = await databaseProvider.database;
    final result = await db.query(dbName);
    return result.map((e) => LocationModel.fromMap(e)).toList();
  }

  @override
  Future<int> deleteLocation(int id) async {
    final db = await databaseProvider.database;
    return await db.delete(
      dbName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<bool> getLocationByZipCode(String zipCode) async {
    final normalizedZipCode = zipCode.replaceAll(RegExp(r'[^0-9]'), '');
    final db = await databaseProvider.database;
    final result = await db.query(
      dbName,
      where: 'zipCode = ?',
      whereArgs: [normalizedZipCode],
    );
    if (result.isNotEmpty) {
      return true;
    }
    return false;
  }
}
