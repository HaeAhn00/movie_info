import 'package:flutter/material.dart';
import 'package:movie_info/domain/model/movie.dart';
import 'package:movie_info/domain/use_case/get_home_data_use_case.dart';

class HomeViewModel with ChangeNotifier {
  final GetHomeDataUseCase _getHomeDataUseCase;

  HomeViewModel({required GetHomeDataUseCase getHomeDataUseCase})
      : _getHomeDataUseCase = getHomeDataUseCase {
    fetchData();
  }

  List<Movie> _nowPlayingMovies = [];
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  List<Movie> _popularMovies = [];
  List<Movie> get popularMovies => _popularMovies;

  List<Movie> _topRatedMovies = [];
  List<Movie> get topRatedMovies => _topRatedMovies;

  List<Movie> _upcomingMovies = [];
  List<Movie> get upcomingMovies => _upcomingMovies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final homeData = await _getHomeDataUseCase.execute();
      _nowPlayingMovies = homeData.nowPlaying;
      _popularMovies = homeData.popular;
      _topRatedMovies = homeData.topRated;
      _upcomingMovies = homeData.upcoming;
    } catch (e) {
      _errorMessage = '데이터를 불러오는 데 실패했습니다: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
