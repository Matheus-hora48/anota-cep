import 'package:anota_cep/src/models/location_model.dart';

abstract class PassbookState {}

class PassbookInitialState extends PassbookState {}

class PassbookLoadingState extends PassbookState {}

class PassbookLoadedState extends PassbookState {
  final List<LocationModel> locations;

  PassbookLoadedState({required this.locations});
}

class PassbookErrorState extends PassbookState {
  final String errorMessage;

  PassbookErrorState({required this.errorMessage});
}

class PassbookFilteredState extends PassbookState {
  final List<LocationModel> filteredLocations;

  PassbookFilteredState({required this.filteredLocations});
}
