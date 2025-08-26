import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_info/data/data_source/movie_data_source_impl.dart';
import 'package:movie_info/data/repository/movie_repository_impl.dart';
import 'package:movie_info/domain/repository/movie_repository.dart';
import 'package:movie_info/domain/use_case/get_home_data_use_case.dart';
import 'package:movie_info/domain/use_case/get_movie_detail_use_case.dart';
import 'package:movie_info/presentation/home/home_page.dart';
import 'package:movie_info/presentation/home/home_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  // main 함수에서 비동기 작업을 수행하기 전에 Flutter 엔진과 위젯 바인딩을 초기화합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 로드
  await dotenv.load(fileName: ".env");

  runApp(MultiProvider(
    providers: [
      // Data Layer
      Provider<MovieRepository>(
          create: (_) => MovieRepositoryImpl(
              dataSource: MovieDataSourceImpl(client: http.Client()))),
      // Domain Layer (Use Cases)
      Provider<GetHomeDataUseCase>(
          create: (context) =>
              GetHomeDataUseCase(context.read<MovieRepository>())),
      Provider<GetMovieDetailUseCase>(
          create: (context) =>
              GetMovieDetailUseCase(context.read<MovieRepository>())),

      // Presentation Layer (ViewModels)
      ChangeNotifierProvider(
        create: (context) => HomeViewModel(
            getHomeDataUseCase: context.read<GetHomeDataUseCase>()),
      ),
    ],
    child: const MovieApp(),
  ));
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 디폴트 다크 모드 설정
    return MaterialApp(
      title: '영화 정보',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade800,
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}
