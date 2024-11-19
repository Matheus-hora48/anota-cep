import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent {}

class SearchLocationEvent extends MapEvent {
  final String zipCode;

  SearchLocationEvent(this.zipCode);
}

class ZipCodeSearchEvent extends MapEvent {
  final String zipCode;

  ZipCodeSearchEvent(this.zipCode);
}

class AddMarkerEvent extends MapEvent {
  final String zipCode;
  final double latitude;
  final double longitude;

  AddMarkerEvent({
    required this.zipCode,
    required this.latitude,
    required this.longitude,
  });
}

class SetGoogleMapControllerEvent extends MapEvent {
  final GoogleMapController controller;

  SetGoogleMapControllerEvent(this.controller);
}

class FetchSuggestionsEvent extends MapEvent {
  final String query;

  FetchSuggestionsEvent(this.query);
}

class ClearSuggestionsEvent extends MapEvent {}
