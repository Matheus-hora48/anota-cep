import 'dart:async';

import 'package:anota_cep/src/dto/location_suggestion.dart';
import 'package:anota_cep/src/models/location_model.dart';
import 'package:anota_cep/src/repository/get_zip_code_location.dart';
import 'package:anota_cep/src/repository/location_repository.dart';
import 'package:anota_cep/src/repository/location_suggestion_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_event.dart';
import 'map_state.dart';

class MapBloc {
  final GetZipCodeLocation _getZipCodeLocation;
  final LocationRepository _locationRepository;
  final LocationSuggestionRepository _locationSuggestion;

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  final StreamController<MapEvent> _inputMapController =
      StreamController<MapEvent>();
  final StreamController<MapState> _outputMapController =
      StreamController<MapState>.broadcast();

  MapBloc({
    required GetZipCodeLocation getZipCodeLocation,
    required LocationRepository locationRepository,
    required LocationSuggestionRepository locationSuggestion,
  })  : _getZipCodeLocation = getZipCodeLocation,
        _locationRepository = locationRepository,
        _locationSuggestion = locationSuggestion {
    _inputMapController.stream.listen(_mapEventToState);
  }

  Sink<MapEvent> get inputMap => _inputMapController.sink;
  Stream<MapState> get stream => _outputMapController.stream;

  Future<void> _mapEventToState(MapEvent event) async {
    LocationModel? currentLocation;

    if (event is SearchLocationEvent) {
      final result = await _zipCodeSearch(event.zipCode);

      if (!result) {
        currentLocation = await _searchLocation(
          event,
          currentLocation,
        );

        if (currentLocation == null) {
          _outputMapController.add(
            MapError(
              message: 'CEP não encontrado. Verifique e tente novamente.',
            ),
          );
          return;
        }
      } else {
        _outputMapController.add(
          MapError(message: 'O CEP já está salvo.'),
        );
        return;
      }
    } else if (event is AddMarkerEvent) {
      await _addMarkerAndCamera(event);
    } else if (event is SetGoogleMapControllerEvent) {
      _mapController = event.controller;
    } else if (event is FetchSuggestionsEvent) {
      _outputMapController.add(SuggestionsLoading());
      final suggestions = await _fetchSuggestions(event.query);
      if (suggestions != null) {
        _outputMapController.add(SuggestionsLoaded(suggestions));
      } else {
        _outputMapController.add(
          SuggestionsError('Erro ao buscar sugestões.'),
        );
      }
      return;
    } else if (event is ClearSuggestionsEvent) {
      _outputMapController.add(SuggestionsLoaded([]));
    }

    _outputMapController.add(
      MapLoaded(location: currentLocation, markers: _markers),
    );
    currentLocation = null;
  }

  Future<bool> _zipCodeSearch(String zipCode) async {
    final result = await _locationRepository.locationExists(zipCode);
    return result.fold((l) => false, (r) => r);
  }

  Future<void> _addMarkerAndCamera(AddMarkerEvent event) async {
    final newMarkers = Marker(
      markerId: MarkerId('marker_${event.latitude}_${event.longitude}'),
      position: LatLng(event.latitude, event.longitude),
      infoWindow: InfoWindow(title: event.zipCode),
    );

    _markers.add(newMarkers);

    if (_mapController != null) {
      await Future.delayed(const Duration(milliseconds: 300));

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(event.latitude, event.longitude), 15),
      );
    }
  }

  Future<LocationModel?> _searchLocation(
      SearchLocationEvent event, LocationModel? currentLocation) async {
    final result = await _getZipCodeLocation.searchLocations(
      event.zipCode,
    );
    result.fold((l) => '', (r) => currentLocation = r);
    return currentLocation;
  }

  Future<List<LocationSuggestion>?> _fetchSuggestions(String query) async {
    final result = await _locationSuggestion.searchLocations(query);
    return result.fold((l) => null, (r) => r);
  }

  void dispose() {
    _inputMapController.close();
    _outputMapController.close();
  }
}
