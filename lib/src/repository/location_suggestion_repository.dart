import 'package:anota_cep/src/core/exceptions/repository_exception.dart';
import 'package:anota_cep/src/dto/location_suggestion.dart';
import 'package:dartz/dartz.dart';

abstract class LocationSuggestionRepository {
Future<Either<RepositoryException, List<LocationSuggestion>>> searchLocations(
    String zipCode,
  );
}