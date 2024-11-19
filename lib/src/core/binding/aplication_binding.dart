import 'package:anota_cep/src/database/dao/location_dao.dart';
import 'package:anota_cep/src/database/dao/location_dao_impl.dart';
import 'package:anota_cep/src/database/sqlite_database.dart';
import 'package:anota_cep/src/database/sqlite_database_impl.dart';
import 'package:anota_cep/src/repository/location_repository.dart';
import 'package:anota_cep/src/repository/location_repository_impl.dart';
import 'package:flutter_getit/flutter_getit.dart';

import '../network/rest_client.dart';

class AplicationBinding extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.lazySingleton(
          (i) => RestClient(),
        ),
        Bind.lazySingleton<SQLiteDatabase>(
          (i) => SQLiteDatabaseImpl.instance,
        ),
        
        Bind.lazySingleton<LocationDao>(
          (i) => LocationDaoImpl(i()),
        ),
        Bind.lazySingleton<LocationRepository>(
          (i) => LocationRepositoryImpl(i()),
        ),
      ];
}
