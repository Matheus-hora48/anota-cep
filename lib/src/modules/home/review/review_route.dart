import 'package:anota_cep/src/modules/home/review/bloc/review_bloc.dart';
import 'package:anota_cep/src/modules/home/review/review_page.dart';
import 'package:anota_cep/src/repository/location_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class ReviewRoute extends FlutterGetItModulePageRouter {
  const ReviewRoute({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
          (i) => ReviewBloc(
            locationRepository: i<LocationRepository>(),
          ),
        ),
      ];

  @override
  WidgetBuilder get view => (_) => const ReviewPage();
}
