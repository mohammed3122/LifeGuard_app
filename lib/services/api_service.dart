import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _url = 'http://life-guard-monitor1.getenjoyment.net/api.php';

  Future<Map<String, dynamic>?> fetchData() async {
    try {
      final response = await _dio.get(_url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            response.data is String ? jsonDecode(response.data) : response.data;
        return jsonData;
      }
    } catch (e) {
      print('❌ Error fetching API data: $e');
    }
    return null;
  }
}
