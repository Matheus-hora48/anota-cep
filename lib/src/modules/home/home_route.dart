import 'package:anota_cep/src/modules/home/home_page.dart';
import 'package:anota_cep/src/modules/home/map/blocs/map_bloc.dart';
import 'package:anota_cep/src/modules/home/passbook/bloc/passbook_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class HomeRoute extends FlutterGetItModulePageRouter {
  const HomeRoute({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
          (i) => MapBloc(
            getZipCodeLocation: i(),
            locationRepository: i(),
            locationSuggestion: i(),
          ),
        ),
        Bind.lazySingleton(
          (i) => PassbookBloc(
            locationRepository: i(),
          ),
        ),
      ];

  @override
  WidgetBuilder get view => (_) => const HomePage();
}
