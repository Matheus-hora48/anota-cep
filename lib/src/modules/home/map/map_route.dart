import 'package:anota_cep/src/modules/home/map/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class MapRoute extends FlutterGetItModulePageRouter {
  const MapRoute({super.key});

  @override
  WidgetBuilder get view => (_) => const MapPage();
}
