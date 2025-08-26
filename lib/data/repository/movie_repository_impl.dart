import 'package:movie_info/data/data_source/movie_data_source.dart';
import 'package:movie_info/data/mapper/movie_mapper.dart';
import 'package:movie_info/domain/model/movie.dart';
import 'package:movie_info/domain/model/movie_detail.dart';
import 'package:movie_info/domain/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieDataSource _dataSource;

  MovieRepositoryImpl({required MovieDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    final dto = await _dataSource.getNowPlayingMovies();
    return dto.results.map((e) => e.toMovie()).toList();
  }

  @override
  Future<List<Movie>> getPopularMovies() async {
    final dto = await _dataSource.getPopularMovies();
    return dto.results.map((e) => e.toMovie()).toList();
  }

  @override
  Future<List<Movie>> getTopRatedMovies() async {
    final dto = await _dataSource.getTopRatedMovies();
    return dto.results.map((e) => e.toMovie()).toList();
  }

  @override
  Future<List<Movie>> getUpcomingMovies() async {
    final dto = await _dataSource.getUpcomingMovies();
    return dto.results.map((e) => e.toMovie()).toList();
  }

  @override
  Future<MovieDetail> getMovieDetail(int movieId) async {
    final dto = await _dataSource.getMovieDetail(movieId);
    return dto.toMovieDetail();
  }
}
