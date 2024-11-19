import 'package:anota_cep/src/modules/home/review/review_route.dart';
import 'package:anota_cep/src/repository/brasil_api_repository_impl.dart';
import 'package:anota_cep/src/repository/geo_api_fy_repository_impl.dart';
import 'package:anota_cep/src/repository/get_zip_code_location_repository.dart';
import 'package:anota_cep/src/repository/location_repository.dart';
import 'package:anota_cep/src/repository/location_repository_impl.dart';
import 'package:anota_cep/src/repository/location_suggestion_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import 'home_route.dart';

class HomeModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<GetZipCodeLocationRepository>(
          (i) => BrasilApiRepositoryImpl(i()),
        ),
        Bind.lazySingleton<LocationRepository>(
          (i) => LocationRepositoryImpl(i()),
        ),
        Bind.lazySingleton<LocationSuggestionRepository>(
          (i) => GeoApiFyRepositoryImpl(i()),
        ),
      ];

  @override
  String get moduleRouteName => '/home';

  @override
  Map<String, WidgetBuilder> get pages => {
        '/': (context) => const HomeRoute(),
        '/review': (context) => const ReviewRoute(),
      };
}
