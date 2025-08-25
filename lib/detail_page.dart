import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  // 나중에는 영화 ID를 받아와서 상세 정보를 API로 호출해야 합니다.
  // 지금은 임시로 이미지 URL만 전달받습니다.
  final String backdropUrl;

  const DetailPage({
    super.key,
    required this.backdropUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar를 CustomScrollView 안에 넣어서 이미지와 함께 스크롤되도록 구현
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                backdropUrl,
                fit: BoxFit.cover,
                // 로딩 및 에러 처리
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
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
                  const Text(
                    '영화 제목 (Placeholder)',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '개봉일: 2024-01-01',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // 태그라인
                  const Text(
                    '"이곳에 인상적인 태그라인이 들어갑니다."',
                    style: TextStyle(
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
                      const Text('148분'),
                      const SizedBox(width: 16),
                      // 카테고리 (Chips)
                      Wrap(
                        spacing: 8.0,
                        children: ['액션', 'SF', '모험']
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
                    '영화 설명',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '이곳에 영화에 대한 자세한 설명이 들어갑니다. 줄거리는 관객의 흥미를 유발하고, 영화의 전반적인 분위기를 전달하는 중요한 역할을 합니다. 이 설명은 여러 줄에 걸쳐 표시될 수 있습니다.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // 평점, 투표수 등 가로 리스트
                  _buildStatsSection(),
                  const SizedBox(height: 24),

                  // 제작사
                  const Text(
                    '제작사',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildProductionCompaniesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 평점, 예산 등 통계 정보를 보여주는 가로 리스트 위젯
  Widget _buildStatsSection() {
    // 임시 데이터
    final stats = {
      '평점': '8.5 / 10',
      '평점 투표수': '1,234표',
      '인기 점수': '150.7',
      '예산': '\$200,000,000',
      '수익': '\$850,000,000',
    };

    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: stats.entries.map((entry) {
          return Container(
            width: 130,
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

  // 제작사 로고를 보여주는 가로 리스트 위젯
  Widget _buildProductionCompaniesSection() {
    // 임시 로고 URL (실제 API 연동 시 변경 필요)
    final companyLogos = [
      'https://image.tmdb.org/t/p/w200/o86DbpburjxrqAzEDhXZcyE8pDb.png', // Marvel
      'https://image.tmdb.org/t/p/w200/1pBu6TbeD0ORs2rb1de7gA2iT2p.png', // Warner Bros
      'https://image.tmdb.org/t/p/w200/wdrCwmkt_S2T1J2N3mIuT3iR3g9.png', // Disney
    ];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: companyLogos.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9), // 배경 흰색, 투명도 0.9
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(
              companyLogos[index],
              fit: BoxFit.contain,
              // 로고가 흰색일 수 있으므로 에러 시 아이콘 색상을 지정
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.business, color: Colors.black54);
              },
            ),
          );
        },
      ),
    );
  }
}
