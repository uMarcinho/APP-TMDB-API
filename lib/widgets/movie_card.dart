import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final ApiService api;

  const MovieCard({Key? key, required this.movie, required this.api}) : super(key: key);

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  int? runtime; // tempo em minutos

  @override
  void initState() {
    super.initState();
    _loadRuntime();
  }

  Future<void> _loadRuntime() async {
    try {
      final rt = await widget.api.fetchMovieRuntime(widget.movie.id);
      if (mounted) {
        setState(() => runtime = rt);
      }
    } catch (e) {
      debugPrint('Erro ao buscar runtime: $e');
    }
  }

  String get formattedTime {
    if (runtime == null || runtime == 0) return '';
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    return '${hours}h${minutes.toString().padLeft(2, '0')}m';
  }

  @override
  Widget build(BuildContext context) {
    final poster = widget.movie.posterPath.isNotEmpty
        ? widget.api.posterUrl(widget.movie.posterPath)
        : null;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: poster != null
                ? Image.network(
              poster,
              width: 56,
              height: 84,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(width: 56, height: 84),
            )
                : const SizedBox(width: 56, height: 84),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 14, color: Colors.white54),
                    const SizedBox(width: 6),
                    Text(
                      formattedTime.isEmpty ? '...' : formattedTime,
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF2C7BFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.movie.voteAverage.toStringAsFixed(0),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
