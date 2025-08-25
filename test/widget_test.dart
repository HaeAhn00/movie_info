// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_info/main.dart';

void main() {
  testWidgets('HomePage has a title and movie lists',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MovieApp());

    // 앱 바에 'Movie Info' 제목이 있는지 확인합니다.
    expect(find.text('Movie Info'), findsOneWidget);

    // 주요 섹션 제목들이 표시되는지 확인합니다.
    expect(find.text('가장 인기있는'), findsOneWidget);
    expect(find.text('현재 상영중'), findsOneWidget);
  });
}
