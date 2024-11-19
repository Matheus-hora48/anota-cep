import 'package:anota_cep/src/core/exceptions/repository_exception.dart';
import 'package:anota_cep/src/models/location_model.dart';
import 'package:dartz/dartz.dart';

abstract class GetZipCodeLocationRepository {
  Future<Either<RepositoryException, LocationModel>> searchLocations(
    String zipCode,
  );
}
