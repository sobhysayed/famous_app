import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';
import '../models/person_details.dart';
import '../models/person_images.dart';

class ApiService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey =
      '2dfe23358236069710a379edd4c65a6b';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String originalImageBaseUrl =
      'https://image.tmdb.org/t/p/original';

  static Future<List<Person>> fetchPopularPersons() async {
    final response = await http.get(
      Uri.parse('$baseUrl/person/popular?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Person.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular persons');
    }
  }

  static Future<PersonDetails> fetchPersonDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/person/$id?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      return PersonDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<PersonImages> fetchPersonImages(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/person/$id/images?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      return PersonImages.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load person images');
    }
  }

  static String getImageUrl(String? path, {bool original = false}) {
    if (path == null) return '';
    return original ? '$originalImageBaseUrl$path' : '$imageBaseUrl$path';
  }
}
