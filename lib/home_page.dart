import 'package:flutter/material.dart';
import 'package:movie_info/detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Info'),
      ),
      body: const MovieHomeBody(),
    );
  }
}

class MovieHomeBody extends StatelessWidget {
  const MovieHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const FeaturedMovieSection(),
        const MovieListSection(title: '현재 상영중', seed: 'now_playing'),
        const MovieListSection(title: '인기순', seed: 'popular', showRank: true),
        const MovieListSection(title: '평점 높은순', seed: 'top_rated'),
        const MovieListSection(title: '개봉예정', seed: 'upcoming'),
        const SizedBox(height: 20),
      ],
    );
  }
}

class FeaturedMovieSection extends StatelessWidget {
  const FeaturedMovieSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                image:
                    NetworkImage('https://picsum.photos/seed/popular/600/400'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MovieListSection extends StatelessWidget {
  final String title;
  final String seed;
  final bool showRank;

  const MovieListSection({
    super.key,
    required this.title,
    required this.seed,
    this.showRank = false,
  });

  @override
  Widget build(BuildContext context) {
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
            itemCount: 20,
            itemBuilder: (context, index) {
              return MovieListItem(
                seed: seed,
                index: index,
                showRank: showRank,
              );
            },
          ),
        ),
      ],
    );
  }
}

class MovieListItem extends StatelessWidget {
  final String seed;
  final int index;
  final bool showRank;

  const MovieListItem({
    super.key,
    required this.seed,
    required this.index,
    this.showRank = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final backdropUrl = 'https://picsum.photos/seed/$seed$index/600/400';
        final heroTag = '$seed$index';
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(backdropUrl: backdropUrl, heroTag: heroTag),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Hero(
          tag: '$seed$index',
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://picsum.photos/seed/$seed$index/120/180',
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 120,
                      height: 180,
                      color: Colors.grey.shade900,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 180,
                      color: Colors.grey.shade900,
                      child: const Icon(Icons.error_outline),
                    );
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
                            color: Colors.black.withOpacity(0.8), blurRadius: 5)
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
}
