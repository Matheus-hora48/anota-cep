import 'package:anota_cep/src/modules/home/map/blocs/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import 'widgets/map_view.dart';
import 'widgets/search_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _hasText = false;

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<MapBloc>();

    return Stack(
      children: [
        MapView(
          bloc: controller,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceIn,
          color: _hasText ? Colors.white : Colors.transparent,
          child: SearchBarWidget(
            bloc: controller,
            onTextChange: (bool value) {
              setState(() {
                _hasText = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
