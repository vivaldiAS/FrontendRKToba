import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/data/api/api_client.dart';

import '../../utils/app_constants.dart';

class CategoriesRepo extends GetxService {
  final ApiClient apiClient;
  CategoriesRepo({required this.apiClient});

  Future<Response> getKategoriList() async {
    return await apiClient.getData(AppConstants.KATEGORI_URL);
  }

}
