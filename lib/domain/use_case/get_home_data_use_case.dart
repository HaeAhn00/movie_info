import 'package:movie_info/domain/model/movie.dart';
import 'package:movie_info/domain/repository/movie_repository.dart';

class GetHomeDataUseCase {
  final MovieRepository _repository;

  GetHomeDataUseCase(this._repository);

  Future<HomeData> execute() async {
    final results = await Future.wait([
      _repository.getNowPlayingMovies(),
      _repository.getPopularMovies(),
      _repository.getTopRatedMovies(),
      _repository.getUpcomingMovies(),
    ]);

    return HomeData(
      nowPlaying: results[0],
      popular: results[1],
      topRated: results[2],
      upcoming: results[3],
    );
  }
}

// Use case의 결과물을 담을 클래스
class HomeData {
  final List<Movie> nowPlaying;
  final List<Movie> popular;
  final List<Movie> topRated;
  final List<Movie> upcoming;

  HomeData({
    required this.nowPlaying,
    required this.popular,
    required this.topRated,
    required this.upcoming,
  });
}
