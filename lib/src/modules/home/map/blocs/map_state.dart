import 'package:anota_cep/src/dto/location_suggestion.dart';
import 'package:anota_cep/src/models/location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState {
  final LocationModel? location;
  final Set<Marker> markers;

  MapState({required this.location, required this.markers});
}

class MapInitial extends MapState {
  MapInitial() : super(location: null, markers: <Marker>{});
}

class MapLoading extends MapState {
  MapLoading() : super(location: null, markers: <Marker>{});
}

class MapLoaded extends MapState {
  MapLoaded({
    required super.location,
    required super.markers,
  });

  MapLoaded copyWith({
    LocationModel? location,
    Set<Marker>? markers,
  }) {
    return MapLoaded(
      location: location ?? this.location,
      markers: markers ?? this.markers,
    );
  }
}

class MapError extends MapState {
  final String message;

  MapError({
    required this.message,
    super.location,
    super.markers = const <Marker>{},
  });
}

class SuggestionsLoaded extends MapState {
  final List<LocationSuggestion> suggestions;

  SuggestionsLoaded(this.suggestions)
      : super(
          location: null,
          markers: <Marker>{},
        );
}

class SuggestionsLoading extends MapState {
  SuggestionsLoading() : super(location: null, markers: <Marker>{});
}

class SuggestionsError extends MapState {
  final String message;

  SuggestionsError(this.message) : super(location: null, markers: <Marker>{});
}
