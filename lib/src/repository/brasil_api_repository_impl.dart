import 'dart:developer';

import 'package:anota_cep/src/core/exceptions/repository_exception.dart';
import 'package:anota_cep/src/core/network/rest_client.dart';
import 'package:anota_cep/src/models/location_model.dart';
import 'package:anota_cep/src/repository/get_zip_code_location_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class BrasilApiRepositoryImpl implements GetZipCodeLocationRepository {
  final RestClient restClient;

  BrasilApiRepositoryImpl(this.restClient);

  @override
  Future<Either<RepositoryException, LocationModel>> searchLocations(
    String zipCode,
  ) async {
    try {
      final response = await restClient.get(
        'https://brasilapi.com.br/api/cep/v2/$zipCode',
      );

      final data = response.data;

      final location = LocationModel(
        zipCode: data['cep'],
        address:
            '${data['street']}, ${data['neighborhood']}, ${data['city']} - ${data['state']}',
        lat: (data['location']?['coordinates']?['latitude'] ?? 0),
        lng: (data['location']?['coordinates']?['longitude'] ?? 0),
      );

      return Right(location);
    } on DioException catch (e, s) {
      log('Erro ao buscar o endereço pelo CEP', error: e, stackTrace: s);
      return Left(
        RepositoryException(message: 'Erro ao buscar o endereço pelo CEP.'),
      );
    } catch (e, s) {
      log('Erro inesperado ao buscar o endereço pelo CEP',
          error: e, stackTrace: s);
      return Left(
        RepositoryException(
          message: 'Erro inesperado ao buscar o endereço pelo CEP.',
        ),
      );
    }
  }
}
