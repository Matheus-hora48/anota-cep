import 'dart:async';
import 'dart:developer';

import 'package:anota_cep/src/app_widget.dart';
import 'package:anota_cep/src/database/sqlite_database_impl.dart';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SQLiteDatabaseImpl.instance.initialize();

    runApp(const AppWidget());
  }, (error, stack) {
    log('Erro não tratado', error: error, stackTrace: stack);
    throw error;
  });
}
