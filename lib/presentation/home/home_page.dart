import 'package:flutter/material.dart';
import 'package:movie_info/domain/model/movie.dart';
import 'package:movie_info/domain/use_case/get_movie_detail_use_case.dart';
import 'package:movie_info/presentation/detail/detail_page.dart';
import 'package:movie_info/presentation/detail/detail_view_model.dart';
import 'package:movie_info/presentation/home/home_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영화 정보'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final popularMovies = viewModel.popularMovies;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(viewModel.errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }

    return ListView(
      children: [
        // 2. '가장 인기있는' 영화 섹션
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '가장 인기있는',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildMainBanner(context, popularMovies.first),
            ],
          ),
        ),

        // 2. 영화 리스트 섹션들
        _buildMovieListSection(
            context: context,
            title: '현재 상영중',
            movies: viewModel.nowPlayingMovies),
        _buildMovieListSection(
            context: context,
            title: '인기순',
            movies: viewModel.popularMovies,
            showRank: true),
        _buildMovieListSection(
            context: context,
            title: '평점 높은순',
            movies: viewModel.topRatedMovies),
        _buildMovieListSection(
            context: context, title: '개봉예정', movies: viewModel.upcomingMovies),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMainBanner(BuildContext context, Movie movie) {
    const String heroTag = 'main_banner';
    return GestureDetector(
      onTap: () => _navigateToDetail(context, movie.id, heroTag),
      child: Hero(
        tag: heroTag,
        child: Container(
          height: 250,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(15),
          ),
          child: _buildImage(path: movie.posterPath, size: 'w780'),
        ),
      ),
    );
  }

  Widget _buildMovieListSection(
      {required BuildContext context,
      required String title,
      required List<Movie> movies,
      bool showRank = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length > 20 ? 20 : movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return _buildMovieListItem(
                  context: context,
                  movie: movie,
                  index: index,
                  showRank: showRank,
                  listTitle: title);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieListItem(
      {required BuildContext context,
      required Movie movie,
      required int index,
      required String listTitle,
      bool showRank = false}) {
    final uniqueHeroTag = '${movie.id}_$listTitle';
    return GestureDetector(
      onTap: () => _navigateToDetail(context, movie.id, uniqueHeroTag),
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Hero(
          tag: uniqueHeroTag,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildImage(
                    path: movie.posterPath,
                    size: 'w342',
                    width: 120,
                    height: 180),
              ),
              if (showRank)
                Positioned(
                  left: -8,
                  bottom: -10,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 5,
                          offset: const Offset(0, 0),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, int movieId, Object heroTag) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) => DetailViewModel(
            getMovieDetailUseCase: context.read<GetMovieDetailUseCase>(),
            movieId: movieId,
          ),
          child: DetailPage(heroTag: heroTag),
        ),
      ),
    );
  }

  Widget _buildImage(
      {required String path,
      required String size,
      double? width,
      double? height}) {
    if (path.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade800,
        child: const Center(child: Icon(Icons.movie, color: Colors.white24)),
      );
    }
    return Image.network(
      'https://image.tmdb.org/t/p/$size$path',
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null
              ? child
              : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorBuilder: (context, error, stackTrace) =>
          const Center(child: Icon(Icons.error)),
    );
  }
}
