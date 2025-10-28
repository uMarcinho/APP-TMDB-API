import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tmdb_app/models/movie.dart';

void main() {
  test('Movie.fromMap parses fields correctly', () {
    final map = {
      'id': 123,
      'title': 'Teste',
      'poster_path': '/abc.jpg',
      'vote_average': 7.5,
      'overview': 'descricao',
      'runtime': 120
    };

    final movie = Movie.fromMap(map);

    expect(movie.id, 123);
    expect(movie.title, 'Teste');
    expect(movie.posterPath, '/abc.jpg');
    expect(movie.voteAverage, 7.5);
    expect(movie.overview, 'descricao');
    expect(movie.runtime, 120);
  });
}
