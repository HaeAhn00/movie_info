import 'package:movie_info/data/dto/movie_detail_dto.dart' as detail_dto;
import 'package:movie_info/data/dto/movie_response_dto.dart' as response_dto;
import 'package:movie_info/domain/model/movie.dart';
import 'package:movie_info/domain/model/movie_detail.dart';

extension ToMovie on response_dto.Result {
  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      posterPath: posterPath ?? '',
    );
  }
}

extension ToMovieDetail on detail_dto.MovieDetailDto {
  MovieDetail toMovieDetail() {
    return MovieDetail(
      posterPath: posterPath ?? '',
      title: title,
      releaseDate: releaseDate,
      tagline: tagline,
      runtime: runtime,
      genres: genres.map((e) => e.name).toList(),
      overview: overview,
      voteAverage: voteAverage,
      voteCount: voteCount,
      popularity: popularity,
      budget: budget,
      revenue: revenue,
      productionCompanies: productionCompanies
          .where((e) => e.logoPath != null)
          .map((e) => e.toProductionCompany())
          .toList(),
    );
  }
}

extension ToProductionCompany on detail_dto.ProductionCompany {
  ProductionCompany toProductionCompany() {
    return ProductionCompany(name: name, logoPath: logoPath ?? '');
  }
}
