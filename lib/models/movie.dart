class Movie {
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final String overview;
  final int runtime;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.overview,
    required this.runtime,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      posterPath: map['poster_path'] ?? '',
      voteAverage: (map['vote_average'] ?? 0).toDouble(),
      overview: map['overview'] ?? '',
      runtime: map['runtime'] ?? 0,
    );
  }
}
