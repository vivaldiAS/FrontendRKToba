import 'package:get/get.dart';

import '../data/repository/categories_repo.dart';
import '../models/categories_models.dart';
class CategoriesController extends GetxController {
  final CategoriesRepo categoriesRepo;
  CategoriesController({required this.categoriesRepo});

  List<dynamic> _kategoriList=[];
  List<dynamic> get kategoriList => _kategoriList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getKategoriList() async{
    Response response = await categoriesRepo.getKategoriList();
    if(response.statusCode == 200){
      List<dynamic> responseBody = response.body;
      _kategoriList = [];
      for (dynamic item in responseBody) {
        Categories categories = Categories.fromJson(item);
        _kategoriList.add(categories);
      }
      _isLoaded = true;
      update();
    }else{

    }
  }
}