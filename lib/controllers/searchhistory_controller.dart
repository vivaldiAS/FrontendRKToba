import 'package:get/get.dart';
import '../data/repository/searchhistory_repo.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';

class SearchHistoryController extends GetxController {
  final SearchHistoryRepo searchHistoryRepo;

  SearchHistoryController({required this.searchHistoryRepo});

  List<dynamic> _searchHistoryList = [];
  List<dynamic> get searchHistoryList => _searchHistoryList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchSearchHistory() async {
    _isLoading = true;
    update();

    final userId = await Get.find<AuthController>().getUserId();
    if (userId != null) {
      final response = await searchHistoryRepo.fetchSearchHistory(userId);
      if (response != null) {
        _searchHistoryList = response;
      }
    }

    _isLoading = false;
    update();
  }
}
