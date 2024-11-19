import 'package:anota_cep/src/modules/home/map/blocs/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import 'widgets/map_view.dart';
import 'widgets/search_bar.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<MapBloc>();

    return Stack(
      children: [
        MapView(
          bloc: controller,
        ),
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: SearchBarWidget(
            bloc: controller,
          ),
        ),
      ],
    );
  }
}
