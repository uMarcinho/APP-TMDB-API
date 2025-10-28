import 'dart:async';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService api = ApiService();
  final TextEditingController _controller = TextEditingController();

  Future<List<Movie>>? _searchFuture;
  Timer? _debounce;
  bool _isManualSearching = false;


  void _onChangedDebounced(String q) {
    _debounce?.cancel();

    if (q.trim().isEmpty) {
      setState(() {
        _searchFuture = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(q);
    });
  }

  void _performSearch(String q) {
    final query = q.trim();
    if (query.isEmpty) return;

    setState(() {
      _isManualSearching = true;
      _searchFuture = _safeSearch(query);
    });
  }

  Future<List<Movie>> _safeSearch(String query) async {
    try {
      debugPrint('[SearchPage] buscando: $query');
      final res = await api.searchMovies(query);
      debugPrint('[SearchPage] resultados: ${res.length}');
      return res;
    } catch (e, st) {
      debugPrint('[SearchPage] erro: $e\n$st');
      rethrow;
    } finally {
      if (mounted) {
        setState(() {
          _isManualSearching = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Busca',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _controller,
              onChanged: _onChangedDebounced,
              onSubmitted: (v) => _performSearch(v),
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF262626),
                hintText: 'Buscar filmes',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchFuture == null
                ? const Center(
              child: Text('',
                  style: TextStyle(color: Colors.white54)),
            )
                : FutureBuilder<List<Movie>>(
              future: _searchFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    _isManualSearching) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final movies = snapshot.data ?? [];
                if (movies.isEmpty) {
                  return const Center(
                    child: Text('Nenhum filme encontrado.',
                        style: TextStyle(color: Colors.white54)),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: movies.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (_, i) =>
                      MovieCard(movie: movies[i], api: api),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
