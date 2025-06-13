import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/data/api/api_client.dart';

class SearchHistoryRepo {
  final ApiClient apiClient;

  SearchHistoryRepo({required this.apiClient});

  Future<List<dynamic>?> fetchSearchHistory(int userId) async {
    try {
      final response = await apiClient.getData('/search-history?user_id=$userId');
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print("Error fetching search history: $e");
    }
    return null;
  }
}
