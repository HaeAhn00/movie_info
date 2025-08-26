import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_info/data/data_source/movie_data_source.dart';
import 'package:movie_info/data/dto/movie_detail_dto.dart';
import 'package:movie_info/data/dto/movie_response_dto.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class MovieDataSourceImpl implements MovieDataSource {
  final http.Client _client;
  static const String _baseUrl = 'api.themoviedb.org';
  final String _token;

  MovieDataSourceImpl({required http.Client client})
      : _client = client,
        _token = dotenv.env['TMDB_API_TOKEN'] ?? '' {
    if (_token.isEmpty) {
      throw Exception('TMDB_API_TOKEN is not found in .env file');
    }
  }

  Future<Map<String, dynamic>> _fetchJson(String unencodedPath,
      [Map<String, String>? queryParameters]) async {
    final params = {'language': 'ko-KR', ...?queryParameters};
    final url = Uri.https(_baseUrl, '/3/movie/$unencodedPath', params);

    try {
      final response = await _client.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
            'Failed to load data from $url. Status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw ApiException('Request timed out. Please check your connection.');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MovieResponseDto> getNowPlayingMovies() async {
    final json = await _fetchJson('now_playing', {'page': '1'});
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto> getPopularMovies() async {
    final json = await _fetchJson('popular', {'page': '1'});
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto> getTopRatedMovies() async {
    final json = await _fetchJson('top_rated', {'page': '1'});
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto> getUpcomingMovies() async {
    final json = await _fetchJson('upcoming', {'page': '1'});
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieDetailDto> getMovieDetail(int id) async {
    final json = await _fetchJson('$id');
    return MovieDetailDto.fromJson(json);
  }
}
