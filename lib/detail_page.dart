import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영화 상세 정보'),
      ),
      body: const Center(
        child: Text('이곳에 영화 상세 정보가 표시.'),
      ),
    );
  }
}
