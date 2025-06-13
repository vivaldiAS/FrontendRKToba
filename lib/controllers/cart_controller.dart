import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';

import '../base/snackbar_message.dart';
import '../data/repository/cart_repo.dart';
import '../models/cart_models.dart';
import '../models/produk_models.dart';
import '../models/response_model.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;
  CartController({required this.cartRepo});
  Map<int, CartModel> _items = {};
  Map<int, CartModel> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<dynamic> _keranjangList = [].obs;
  List<dynamic> get keranjangList => _keranjangList;

  List<dynamic> _merchantKeranjangList = [];
  List<dynamic> get merchantKeranjangList => _merchantKeranjangList;

  List<int?> _checkedCartIds = [];
  List<int?> get checkedCartIds => _checkedCartIds;

  int _totalItems = 0;

  @override
  void onInit() {
    super.onInit();
    _tambahKeranjang(this);
    getKeranjangList(); // Call the function here
  }

  @override
  void initState() {
    _tambahKeranjang(this);
    getKeranjangList();
  }

  void addItem(Produk produk, int jumlahMasukKeranjang) {
    var totalQuantity = 0;
    if (_items.containsKey(produk.productId)) {
      _items.update(produk.productId, (value) {
        totalQuantity = value.jumlahMasukKeranjang! + jumlahMasukKeranjang;
        print("ini alamat ${value.cityId}");
        return CartModel(
            productId: value.productId,
            jumlahMasukKeranjang:
            value.jumlahMasukKeranjang! + jumlahMasukKeranjang,
            merchantId: value.merchantId,
            categoryId: value.categoryId,
            productName: value.productName,
            price: value.price,
            heavy: value.heavy,
            cityId: value.cityId,
            produk: produk);
      });

      if (totalQuantity <= 0) {
        _items.remove(produk.productId);
      }
    } else {
      print("length of the item is " + _items.length.toString());
      _items.putIfAbsent(produk.productId, () {
        print("adding item to the cart " +
            produk.productId.toString() +
            " quantity " +
            jumlahMasukKeranjang.toString());
        _items.forEach((key, value) {
          print("quantity is " + value.jumlahMasukKeranjang.toString());
        });
        return CartModel(
            productId: produk.productId,
            jumlahMasukKeranjang: jumlahMasukKeranjang,
            merchantId: produk.merchantId,
            categoryId: produk.categoryId,
            productName: produk.productName,
            price: produk.price,
            heavy: produk.heavy,
            cityId: produk.cityId,
            produk: produk);
      });
      //  }
    }
    update();
  }

  Future<ResponseModel> tambahKeranjang(
      int? user_id, int product_id, int jumlah_masuk_keranjang) async {
    _isLoading = true;
    update();
    Response response = await cartRepo.tambahKeranjang(
        user_id!, product_id, jumlah_masuk_keranjang);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      _totalItems = response.body;
      AwesomeSnackbarButton("Berhasil",
          "Produk berhasil ditambahkan ke keranjang", ContentType.success);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getKeranjangList() async {
    if (Get.find<AuthController>().userLoggedIn()) {
      if (Get.find<UserController>().usersList.isNotEmpty) {
        var controller = Get.find<UserController>().usersList[0];

        Response response = await cartRepo.getKeranjangList(controller.id!);
        if (response.statusCode == 200) {
          List<dynamic> responseBody = response.body["cart"];
          _keranjangList = [].obs;
          for (dynamic item in responseBody) {
            CartModel cartModel = CartModel.fromJson(item);
            _keranjangList.add(cartModel);
          }

          List<dynamic> responseBodymerchant =
          response.body["cart_by_merchants"];
          _merchantKeranjangList = [];
          for (dynamic item in responseBodymerchant) {
            CartModel cartModel = CartModel.fromJson(item);
            _merchantKeranjangList.add(cartModel);
          }

          _isLoading = true;
          update();
        } else {}
      }
    }
  }

  Future<void> _tambahKeranjang(CartController cartController) async {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      cartController.getKeranjangList();
    }
  }

  Future<ResponseModel> hapusKeranjang(int cart_id) async {
    _isLoading = true;
    update();
    Response response = await cartRepo.hapusKeranjang(cart_id);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      AwesomeSnackbarButton(
          "Berhasil", "Produk berhasil dihapus", ContentType.success);
      getKeranjangList();
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> kurangKeranjang(int cart_id) async {
    _isLoading = true;
    update();
    Response response = await cartRepo.kurangKeranjang(cart_id);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      getKeranjangList();
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> jumlahKeranjang(int cart_id) async {
    _isLoading = true;
    update();
    Response response = await cartRepo.jumlahKeranjang(cart_id);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (response.body == 1) {
        AwesomeSnackbarButton(
            "Gagal", "Stok produk telah habis", ContentType.failure);
      }
      getKeranjangList();
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Map<String, bool> _checkedStatusMap = {};

  // bool getMerchantCheckedStatus(String merchantName) {
  //   return _checkedStatusMap[merchantName] ?? false;
  // }

  bool getMerchantCheckedStatus(String merchantName) {
    bool allItemsChecked = true;
    for (var item in _keranjangList) {
      if (item.namaMerchant == merchantName) {
        if (!_checkedCartMap.containsKey(item.productId.toString()) ||
            !_checkedCartMap[item.productId.toString()]!) {
          allItemsChecked = false;
          break;
        }
      }
    }
    return _checkedStatusMap[merchantName] ?? allItemsChecked;
  }

  void setMerchantCheckedStatus(String merchantName, bool? value) {
    _checkedStatusMap[merchantName] = value ?? false;
  }

  Map<String, bool> _checkedCartMap = {};

  bool getCartCheckedStatus(int? cartId) {
    return _checkedCartMap[cartId.toString()] ?? false;
  }

  void setCartCheckedStatus(int? cartId, bool? value) {
    _checkedCartMap[cartId.toString()] = value ?? false;
  }

  bool existInCart(Produk produk) {
    if (_items.containsKey(produk.productId)) {
      return true;
    }
    return false;
  }

  int getQuantity(Produk produk) {
    var quantity = 0;
    if (_items.containsKey(produk.productId)) {
      _items.forEach((key, value) {
        if (key == produk.productId) {
          quantity = value.jumlahMasukKeranjang!;
        }
      });
    }
    return quantity;
  }

  // int get totalItems => _totalItems;
  //
  // set totalItems(int value) {
  //   _totalItems = value;
  // }
  //
  // int gettotalItems() {
  //   return _totalItems;
  // }

  List<CartModel> get getItems {
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.jumlahMasukKeranjang!;
    });
    return totalQuantity;
  }

  num get totalAmount {
    num total = 0;
    _items.forEach((key, value) {
      total += value.jumlahMasukKeranjang! * value.price!;
    } as void Function(dynamic, dynamic));
    return total;
  }
}
