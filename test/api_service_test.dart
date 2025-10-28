import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tmdb_app/services/api_service.dart';

void main() {
  test('posterUrl returns correct full url', () {
    final api = ApiService();
    final path = '/poster.png';
    final url = api.posterUrl(path);
    expect(url.contains('image.tmdb.org'), true);
    expect(url.endsWith(path), true);
  });

  test('posterUrl returns empty string when path empty', () {
    final api = ApiService();
    final url = api.posterUrl('');
    expect(url, '');
  });
}
