import 'package:anota_cep/src/core/exceptions/repository_exception.dart';
import 'package:dartz/dartz.dart';

import '../models/location_model.dart';

abstract class LocationRepository {
  Future<Either<RepositoryException, Unit>> saveLocation(
    LocationModel location,
  );
  Future<Either<RepositoryException, List<LocationModel>>> getAllLocations();
  Future<Either<RepositoryException, Unit>> deleteLocation(int id);
  Future<Either<RepositoryException, bool>> locationExists(String zipCode);
}
