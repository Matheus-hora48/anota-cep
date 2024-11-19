import 'dart:async';

import 'package:anota_cep/src/models/location_model.dart';
import 'package:anota_cep/src/modules/home/review/bloc/review_event.dart';
import 'package:anota_cep/src/modules/home/review/bloc/review_state.dart';
import 'package:anota_cep/src/repository/location_repository.dart';

class ReviewBloc {
  final LocationRepository _locationRepository;

  final StreamController<ReviewEvent> _inputReviewController =
      StreamController<ReviewEvent>();
  final StreamController<ReviewState> _outputReviewController =
      StreamController<ReviewState>.broadcast();

  ReviewBloc({
    required LocationRepository locationRepository,
  }) : _locationRepository = locationRepository {
    _inputReviewController.stream.listen(_mapEventToState);
  }

  Sink<ReviewEvent> get inputReview => _inputReviewController.sink;
  Stream<ReviewState> get stream => _outputReviewController.stream;

  Future<void> _mapEventToState(ReviewEvent event) async {
    if (event is SaveReviewEvent) {
      await _saveReview(event);
    }
  }

  Future<void> _saveReview(SaveReviewEvent event) async {
    _outputReviewController.add(ReviewLoading());

    final location = LocationModel(
      zipCode: event.cep,
      address: event.address,
      complement: event.complement,
      number: event.number,
      lat: '',
      lng: '',
    );
    final result = await _locationRepository.saveLocation(location);
    result.fold(
      (l) => _outputReviewController
          .add(ReviewError('Erro ao salvar o local: ${l.message}')),
      (r) => _outputReviewController
          .add(ReviewSuccess('Local salvo com sucesso!')),
    );
  }
}
