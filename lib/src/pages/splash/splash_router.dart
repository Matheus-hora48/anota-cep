import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter/material.dart';

import 'splash_page.dart';

class SplashRoute extends FlutterGetItPageRouter {
  const SplashRoute({super.key});

  @override
  List<Bind<Object>> get bindings => [];

  @override
  String get routeName => '/';

  @override
  WidgetBuilder get view => (_) => const SplashPage();
}
