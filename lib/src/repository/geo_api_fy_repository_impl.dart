import 'dart:developer';

import 'package:anota_cep/src/core/exceptions/repository_exception.dart';
import 'package:anota_cep/src/core/network/rest_client.dart';
import 'package:anota_cep/src/dto/location_suggestion.dart';
import 'package:anota_cep/src/repository/location_suggestion_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class GeoApiFyRepositoryImpl implements LocationSuggestionRepository {
  final RestClient restClient;

  GeoApiFyRepositoryImpl(this.restClient);

  @override
  Future<Either<RepositoryException, List<LocationSuggestion>>> searchLocations(
    String zipCode,
  ) async {
    try {
      const apiKey = '8c03b64dd5bf471b953d4eddf6a33f53';

      final response = await restClient.get(
        'https://api.geoapify.com/v1/geocode/autocomplete',
        queryParameters: {
          'text': zipCode,
          'limit': 10,
          'type': 'postcode',
          'format': 'json',
          'apiKey': apiKey
        },
      );
      final data = response.data;

      if (data != null && data['results'] != null) {
        final suggestions = (data['results'] as List)
            .map((item) => LocationSuggestion(
                  zipCode: item['postcode'],
                  address: item['formatted'],
                ))
            .toList();

        return Right(suggestions);
      }

      return const Right([]);
    } on DioException catch (e, s) {
      log(
        'Erro ao buscar a lista de sugestão pelo CEP',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
          message: 'Erro ao buscar a lista de sugestão pelo CEP.',
        ),
      );
    } catch (e, s) {
      log(
        'Erro inesperado ao buscar a lista de sugestão pelo CEP',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
          message: 'Erro inesperado ao buscar a lista de sugestão pelo CEP.',
        ),
      );
    }
  }
}
