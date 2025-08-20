import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String url;

  ApiService(this.url);

  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else {
      throw Exception('Failed to load data');
    }
  }
}
