import 'package:flutter/material.dart';
import 'package:movie_info/domain/model/movie_detail.dart';
import 'package:movie_info/domain/use_case/get_movie_detail_use_case.dart';

class DetailViewModel with ChangeNotifier {
  final GetMovieDetailUseCase _getMovieDetailUseCase;
  final int movieId;

  DetailViewModel({
    required GetMovieDetailUseCase getMovieDetailUseCase,
    required this.movieId,
  }) : _getMovieDetailUseCase = getMovieDetailUseCase {
    fetchDetail();
  }

  MovieDetail? _movieDetail;
  MovieDetail? get movieDetail => _movieDetail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchDetail() async {
    _isLoading = true;
    notifyListeners();

    _movieDetail = await _getMovieDetailUseCase.execute(movieId);

    _isLoading = false;
    notifyListeners();
  }
}
