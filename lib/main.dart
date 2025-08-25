import 'package:flutter/material.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 디폴트 다크 모드 설정
    return MaterialApp(
      title: 'Movie Info',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Info'),
      ),
      body: ListView(
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
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      // 안정적인 플레이스홀더 이미지로 변경
                      image: NetworkImage(
                          'https://picsum.photos/seed/popular/600/400'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. 영화 리스트 섹션들
          _buildMovieListSection(title: '현재 상영중', seed: 'now_playing'),
          _buildMovieListSection(title: '인기순', seed: 'popular', showRank: true),
          _buildMovieListSection(title: '평점 높은순', seed: 'top_rated'),
          _buildMovieListSection(title: '개봉예정', seed: 'upcoming'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 영화 리스트 섹션을 만드는 위젯
  Widget _buildMovieListSection(
      {required String title, required String seed, bool showRank = false}) {
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
            itemCount: 20, // 20개의 이미지 출력
            itemBuilder: (context, index) {
              return _buildMovieListItem(
                  seed: seed, index: index, showRank: showRank);
            },
          ),
        ),
      ],
    );
  }

  // 각 영화 아이템을 만드는 위젯
  Widget _buildMovieListItem(
      {required String seed, required int index, bool showRank = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              // URL에 한글이 들어가지 않도록 영문 seed를 사용
              'https://picsum.photos/seed/$seed$index/120/180',
              width: 120,
              height: 180,
              fit: BoxFit.cover,
              // 이미지 로딩 중 보여줄 위젯
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child; // 로딩 완료 시 실제 이미지 표시
                return Container(
                  width: 120,
                  height: 180,
                  color: Colors.grey.shade900,
                  child: Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey.shade700,
                  )),
                );
              },
              // 이미지 로딩 실패 시 보여줄 위젯
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    width: 120,
                    height: 180,
                    color: Colors.grey.shade900,
                    child: const Icon(Icons.error_outline));
              },
            ),
          ),
          if (showRank)
            Positioned(
              left: 8,
              bottom: -10,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 5,
                        offset: const Offset(0, 0))
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
