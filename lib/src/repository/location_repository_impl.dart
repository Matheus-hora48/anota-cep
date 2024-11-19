import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../core/exceptions/repository_exception.dart';
import '../database/dao/location_dao.dart';
import '../models/location_model.dart';
import 'location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDao locationDao;

  LocationRepositoryImpl(this.locationDao);

  @override
  Future<Either<RepositoryException, Unit>> saveLocation(
    LocationModel location,
  ) async {
    try {
      await locationDao.saveLocation(location);
      return const Right(unit);
    } on Exception catch (e, s) {
      log('Erro ao salvar o local', error: e, stackTrace: s);
      return Left(
        RepositoryException(message: 'Erro ao salvar o local'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, List<LocationModel>>>
      getAllLocations() async {
    try {
      final result = await locationDao.getAllLocations();
      return Right(result);
    } on Exception catch (e, s) {
      log('Erro ao buscar todos os locais', error: e, stackTrace: s);
      return Left(
        RepositoryException(message: 'Erro ao buscar todos os locais'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, Unit>> deleteLocation(int id) async {
    try {
      await locationDao.deleteLocation(id);
      return const Right(unit);
    } on Exception catch (e, s) {
      log('Erro ao deletar os locais', error: e, stackTrace: s);
      return Left(
        RepositoryException(message: 'Erro ao deletar os locais'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, bool>> locationExists(
    String zipCode,
  ) async {
    try {
      final location = await locationDao.getLocationByZipCode(zipCode);
      return Right(location);
    } on Exception catch (e, s) {
      log('Erro ao verificar a existência do local', error: e, stackTrace: s);
      return Left(
        RepositoryException(message: 'Erro ao verificar o local'),
      );
    }
  }
}
