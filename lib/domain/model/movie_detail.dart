class MovieDetail {
  final String posterPath;
  final String title;
  final String releaseDate;
  final String tagline;
  final int runtime;
  final List<String> genres;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final int budget;
  final int revenue;
  final List<ProductionCompany> productionCompanies;

  MovieDetail({
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.tagline,
    required this.runtime,
    required this.genres,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.budget,
    required this.revenue,
    required this.productionCompanies,
  });
}

class ProductionCompany {
  final String name;
  final String logoPath;

  ProductionCompany({
    required this.name,
    required this.logoPath,
  });
}
