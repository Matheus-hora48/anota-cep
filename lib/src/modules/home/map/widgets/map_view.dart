import 'package:anota_cep/src/modules/home/map/blocs/map_bloc.dart';
import 'package:anota_cep/src/modules/home/map/blocs/map_event.dart';
import 'package:anota_cep/src/modules/home/map/blocs/map_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final MapBloc bloc;

  const MapView({super.key, required this.bloc});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MapState>(
      stream: widget.bloc.stream,
      builder: (context, snapshot) {
        final state = snapshot.data?.markers;
        return GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(-12.9704, -38.5124),
            zoom: 12,
          ),
          markers: state ?? <Marker>{},
          onMapCreated: (controller) {
            widget.bloc.inputMap.add(
              SetGoogleMapControllerEvent(controller),
            );
          },
        );
      },
    );
  }
}
