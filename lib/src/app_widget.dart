import 'package:anota_cep/src/core/binding/aplication_binding.dart';
import 'package:anota_cep/src/modules/home/home_module.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import 'core/ui/theme/app_theme.dart';
import 'pages/splash/splash_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      bindings: AplicationBinding(),
      pages: [
        FlutterGetItPageBuilder(
          page: (_) => const SplashPage(),
          path: '/',
        ),
      ],
      modules: [
        HomeModule(),
      ],
      builder: (context, routes, flutterGetItNavObserver) {
        return AsyncStateBuilder(
          builder: (_) {
            return MaterialApp(
              title: 'Anota CEP',
              theme: AppTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              routes: routes,
              navigatorObservers: [
                flutterGetItNavObserver,
              ],
            );
          },
        );
      },
    );
  }
}
