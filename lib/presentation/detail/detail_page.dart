import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_info/domain/model/movie_detail.dart';
import 'package:movie_info/presentation/detail/detail_view_model.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  final Object heroTag;

  const DetailPage({
    super.key,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailViewModel>();
    final movie = viewModel.movieDetail;

    if (viewModel.isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.errorMessage != null || movie == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(viewModel.errorMessage ?? '영화 정보를 불러올 수 없습니다.'),
        ),
      );
    }

    return Scaffold(
      // AppBar를 CustomScrollView 안에 넣어서 이미지와 함께 스크롤되도록 구현
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: heroTag,
                child: Image.network(
                  'https://image.tmdb.org/t/p/w780${movie.posterPath}',
                  fit: BoxFit.cover,
                  // 로딩 및 에러 처리
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey.shade900,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade900,
                      child: const Center(child: Icon(Icons.error)),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 영화 제목, 개봉일
                  Text(
                    movie.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '개봉일: ${movie.releaseDate}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // 태그라인
                  Text(
                    '"${movie.tagline}"',
                    style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // 러닝타임, 카테고리
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text('${movie.runtime}분'),
                      const SizedBox(width: 16),
                      // 카테고리 (Chips)
                      Wrap(
                        spacing: 8.0,
                        children: movie.genres
                            .map((genre) => Chip(
                                  label: Text(genre),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ))
                            .toList(),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 영화 설명
                  const Text(
                    '개요',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // 평점, 투표수 등 가로 리스트
                  _StatsSection(movie: movie),
                  const SizedBox(height: 24),

                  // 제작사
                  const Text(
                    '제작사',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _ProductionCompaniesSection(
                      companies: movie.productionCompanies),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final MovieDetail movie;

  const _StatsSection({required this.movie});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern('en_US');
    final currencyFormat =
        NumberFormat.compactSimpleCurrency(locale: 'en_US', decimalDigits: 1);

    final stats = {
      '평점': '${movie.voteAverage.toStringAsFixed(1)} / 10',
      '평점 투표수': '${numberFormat.format(movie.voteCount)}표',
      '인기 점수': movie.popularity.toStringAsFixed(1),
      '예산': movie.budget > 0 ? currencyFormat.format(movie.budget) : 'N/A',
      '수익': movie.revenue > 0 ? currencyFormat.format(movie.revenue) : 'N/A',
    };

    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: stats.entries.map((entry) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  entry.value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProductionCompaniesSection extends StatelessWidget {
  final List<ProductionCompany> companies;

  const _ProductionCompaniesSection({required this.companies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9), // 배경 흰색, 투명도 0.9
              borderRadius: BorderRadius.circular(10),
            ),
            child: company.logoPath.isEmpty
                ? Center(
                    child: Text(
                    company.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ))
                : Image.network(
                    'https://image.tmdb.org/t/p/w200${company.logoPath}',
                    fit: BoxFit.contain,
                    // 로고가 흰색일 수 있으므로 에러 시 아이콘 색상을 지정
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          company.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
