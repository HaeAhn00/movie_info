import 'package:movie_info/domain/model/movie.dart';
import 'package:movie_info/domain/model/movie_detail.dart';

abstract interface class MovieRepository {
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getTopRatedMovies();
  Future<List<Movie>> getUpcomingMovies();

  Future<MovieDetail> getMovieDetail(int movieId);
}
