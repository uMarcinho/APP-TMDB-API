import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

const String TMDB_API_KEY = 'a63444a49135e5e8294525286b6d7553';
const String BASE_URL = 'https://api.themoviedb.org/3';
const String IMAGE_BASE = 'https://image.tmdb.org/t/p/w500';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    final url = Uri.parse('$BASE_URL/movie/popular?api_key=$TMDB_API_KEY&language=pt-BR&page=$page');
    final res = await client.get(url).timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List results = data['results'] ?? [];
      return results.map((m) => Movie.fromMap(m)).toList();
    } else {
      throw Exception('Erro ao buscar filmes populares (status ${res.statusCode})');
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final url = Uri.parse(
      '$BASE_URL/search/movie?api_key=$TMDB_API_KEY&language=pt-BR&query=${Uri.encodeQueryComponent(query)}&page=$page&include_adult=false',
    );
    final res = await client.get(url).timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List results = data['results'] ?? [];
      return results.map((m) => Movie.fromMap(m)).toList();
    } else {
      throw Exception('Erro ao pesquisar filmes (status ${res.statusCode})');
    }
  }

  Future<int> fetchMovieRuntime(int movieId) async {
    final url = Uri.parse('$BASE_URL/movie/$movieId?api_key=$TMDB_API_KEY&language=pt-BR');
    final res = await client.get(url).timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return data['runtime'] ?? 0;
    } else {
      throw Exception('Erro ao buscar runtime do filme $movieId (status ${res.statusCode})');
    }
  }

  String posterUrl(String path) => path.isNotEmpty ? '$IMAGE_BASE$path' : '';
}
