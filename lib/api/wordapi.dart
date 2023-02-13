import 'package:translatehelper/entities/word.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordApi {
  static Future<List<Word>> getWordSuggestions(String query) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    final response = await http.get(url);

    final List words = json.decode(response.body);

    return words.map((json) => Word.fromMap(json)).where((word) {
      final nameLower = word.name.toLowerCase();
      final queryLower = query.toLowerCase();
 
      return nameLower.contains(queryLower);
    }).toList();
  }
}
