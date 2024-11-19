import 'dart:async';

import 'package:anota_cep/src/models/location_model.dart';
import 'package:anota_cep/src/modules/home/passbook/bloc/passbook_state.dart';
import 'package:anota_cep/src/repository/location_repository.dart';

import 'passbook_event.dart';

class PassbookBloc {
  final LocationRepository _locationRepository;

  final StreamController<PassbookEvent> _inputPassbookController =
      StreamController<PassbookEvent>();
  final StreamController<PassbookState> _outputPassbookController =
      StreamController<PassbookState>.broadcast();

  List<LocationModel> _locations = [];

  PassbookBloc({
    required LocationRepository locationRepository,
  }) : _locationRepository = locationRepository {
    _inputPassbookController.stream.listen(_mapEventToState);
  }

  Sink<PassbookEvent> get inputReview => _inputPassbookController.sink;
  Stream<PassbookState> get stream => _outputPassbookController.stream;

  Future<void> _mapEventToState(PassbookEvent event) async {
    if (event is LoadLocations) {
      await _loadLocations();
    } else if (event is DeleteLocation) {
      await _deleteLocation(event.id);
    } else if (event is FilterLocations) {
      _filterLocations(event.searchQuery);
    }
  }

  Future<void> _loadLocations() async {
    _outputPassbookController.add(PassbookLoadingState());

    final result = await _locationRepository.getAllLocations();
    result.fold(
      (error) {
        _outputPassbookController.add(
          PassbookErrorState(errorMessage: error.message),
        );
      },
      (locations) {
        _locations = locations;
        _outputPassbookController.add(
          PassbookLoadedState(locations: locations),
        );
      },
    );
  }

  Future<void> _deleteLocation(int id) async {
    _outputPassbookController.add(PassbookLoadingState());

    final result = await _locationRepository.deleteLocation(id);
    result.fold(
      (error) {
        _outputPassbookController.add(
          PassbookErrorState(errorMessage: error.message),
        );
      },
      (_) {
        _loadLocations();
      },
    );
  }

  void _filterLocations(String query) {
    final filtered = _locations
        .where((location) =>
            location.address.toLowerCase().contains(query.toLowerCase()) ||
            location.zipCode.contains(query))
        .toList();

    _outputPassbookController.add(
      PassbookFilteredState(filteredLocations: filtered),
    );
  }

  void dispose() {
    _inputPassbookController.close();
    _outputPassbookController.close();
  }
}
