import 'package:movie_info/domain/model/movie_detail.dart';
import 'package:movie_info/domain/repository/movie_repository.dart';

class GetMovieDetailUseCase {
  final MovieRepository _repository;

  GetMovieDetailUseCase(this._repository);

  Future<MovieDetail> execute(int movieId) async {
    return _repository.getMovieDetail(movieId);
  }
}
