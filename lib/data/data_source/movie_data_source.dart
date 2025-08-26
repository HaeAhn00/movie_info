import 'package:movie_info/data/dto/movie_detail_dto.dart';
import 'package:movie_info/data/dto/movie_response_dto.dart';

abstract class MovieDataSource {
  Future<MovieResponseDto> getNowPlayingMovies();

  Future<MovieResponseDto> getPopularMovies();

  Future<MovieResponseDto> getTopRatedMovies();

  Future<MovieResponseDto> getUpcomingMovies();

  Future<MovieDetailDto> getMovieDetail(int id);
}
