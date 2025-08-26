import 'package:movie_info/domain/model/movie.dart';
import 'package:movie_info/domain/model/movie_detail.dart';
import 'package:movie_info/domain/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  // 실제로는 MovieApi를 주입받아 사용합니다.
  // final MovieApi _api;
  // MovieRepositoryImpl(this._api);

  final _movies = List.generate(
      20,
      (i) => Movie(
          id: i,
          title: '영화 ${i + 1}',
          posterPath: '/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg'));

  @override
  Future<List<Movie>> getNowPlayingMovies() async => _movies;
  @override
  Future<List<Movie>> getPopularMovies() async => _movies;
  @override
  Future<List<Movie>> getTopRatedMovies() async => _movies;
  @override
  Future<List<Movie>> getUpcomingMovies() async => _movies;

  @override
  Future<MovieDetail> getMovieDetail(int movieId) async {
    // 실제로는 API 호출: return _api.getMovieDetail(movieId);
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    return MovieDetail(
        posterPath: '/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg',
        title: '영화 제목 $movieId',
        releaseDate: '2024-01-01',
        tagline: '이곳에 인상적인 태그라인이 들어갑니다.',
        runtime: 148,
        genres: ['액션', 'SF', '모험'],
        overview:
            '이곳에 영화에 대한 자세한 설명이 들어갑니다. 줄거리는 관객의 흥미를 유발하고, 영화의 전반적인 분위기를 전달하는 중요한 역할을 합니다. 이 설명은 여러 줄에 걸쳐 표시될 수 있습니다.',
        voteAverage: 8.5,
        voteCount: 1234,
        popularity: 150.7,
        budget: 200000000,
        revenue: 850000000,
        productionCompanies: [
          ProductionCompany(
              name: 'Marvel Studios',
              logoPath: '/o86DbpburjxrqAzEDhXZcyE8pDb.png'),
          ProductionCompany(
              name: 'Warner Bros. Pictures',
              logoPath: '/1pBu6TbeD0ORs2rb1de7gA2iT2p.png'),
          ProductionCompany(
              name: 'Walt Disney Pictures',
              logoPath: '/wdrCwmkt_S2T1J2N3mIuT3iR3g9.png'),
        ]);
  }
}
