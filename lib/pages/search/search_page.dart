import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../controllers/popular_produk_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/card_produk.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';

class SearchPage extends StatefulWidget {
  final String kategori;
  const SearchPage({Key? key, required this.kategori}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _originalList = [];
  List<dynamic> _list = [];
  List<Map<String, dynamic>> _searchHistory = [];
  bool _isTyping = false;

  double? _minPrice;
  double? _maxPrice;
  double _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _searchController.addListener(() {
      setState(() {
        _isTyping = _searchController.text.isNotEmpty;
      });
    });
  }

  Future<void> _loadSearchHistory() async {
    try {
      final history = await _fetchSearchHistory();
      setState(() {
        _searchHistory = history;
      });
    } catch (e) {
      print("Gagal load history: $e");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSearchHistory() async {
    final token = await authController.authRepo.getUserToken();
    final response = await http.get(
      Uri.parse(AppConstants.SEARCH_HISTORY_URL),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body is List ? body : body['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Gagal memuat histori pencarian');
    }
  }

  Future<void> _saveSearchHistory(String keyword) async {
    final token = await authController.authRepo.getUserToken();
    await http.post(
      Uri.parse(AppConstants.SEARCH_HISTORY_URL),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'keyword': keyword}),
    );
  }

  Future<void> _deleteSearchHistory(int id) async {
    final token = await authController.authRepo.getUserToken();
    await http.delete(
      Uri.parse('${AppConstants.SEARCH_HISTORY_URL}/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<void> _clearSearchHistory() async {
    final token = await authController.authRepo.getUserToken();
    await http.delete(
      Uri.parse(AppConstants.SEARCH_HISTORY_URL),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<void> _search(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _list = [];
        _originalList = [];
      });
      return;
    }

    List<dynamic> results = Get.find<PopularProdukController>()
        .popularProdukList
        .where((produk) =>
        produk.productName.toLowerCase().contains(keyword.toLowerCase()))
        .toList();

    if (widget.kategori != "All") {
      results = results
          .where((produk) => produk.namaKategori.toString() == widget.kategori)
          .toList();
    }

    setState(() {
      _originalList = results;
      _list = results;
    });

    final alreadyExists =
    _searchHistory.any((item) => item['keyword'] == keyword);
    if (!alreadyExists) {
      await _saveSearchHistory(keyword);
      _loadSearchHistory();
    }

    _applyFilter(_minPrice, _maxPrice, _selectedRating);
  }

  void _showFilterModal() {
    double? modalMin = _minPrice;
    double? modalMax = _maxPrice;
    double modalRating = _selectedRating;

    TextEditingController minController =
    TextEditingController(text: modalMin != null ? modalMin.toStringAsFixed(0) : '');
    TextEditingController maxController =
    TextEditingController(text: modalMax != null ? modalMax.toStringAsFixed(0) : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: StatefulBuilder(builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Filter Produk",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Harga Input
                Text("Harga (Rp)", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: minController,
                        decoration: InputDecoration(
                          hintText: "Min",
                          prefixText: "Rp ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (val) {
                          setModalState(() {
                            modalMin = double.tryParse(val.trim());
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: maxController,
                        decoration: InputDecoration(
                          hintText: "Max",
                          prefixText: "Rp ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (val) {
                          setModalState(() {
                            modalMax = double.tryParse(val.trim());
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Rating Input with Icons
                Text("Rating Minimal", style: TextStyle(fontSize: 16)),
                DropdownButtonFormField<double>(
                  value: modalRating,
                  items: [0, 1, 2, 3, 4, 5].map((e) {
                    return DropdownMenuItem<double>(
                      value: e.toDouble(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: e == 0 ? Colors.grey : Colors.yellow,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(e == 0 ? "Semua" : "$e ke atas"),
                        ],
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (val) {
                    setModalState(() {
                      modalRating = val!;
                    });
                  },
                ),
                SizedBox(height: 20),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _minPrice = null;
                            _maxPrice = null;
                            _selectedRating = 0;
                          });
                          _applyFilter(null, null, 0);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text("Reset",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _minPrice = modalMin;
                            _maxPrice = modalMax;
                            _selectedRating = modalRating;
                          });
                          _applyFilter(_minPrice, _maxPrice, _selectedRating);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text("Terapkan",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            );
          }),
        );
      },
    );
  }

  void _applyFilter(double? min, double? max, double rating) {
    List<dynamic> data = _originalList; // pakai list asli

    List<dynamic> filtered = data.where((produk) {
      final harga = produk.price.toDouble();
      final rate = produk.averageRating?.toDouble() ?? 0.0;

      final cocokHarga =
          (min == null || harga >= min) && (max == null || harga <= max);
      final cocokRating = rating == 0 || rate >= rating;

      return cocokHarga && cocokRating;
    }).toList();

    setState(() {
      _list = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          // Search Bar
          Container(
            margin: EdgeInsets.only(
                top: Dimensions.height30, bottom: 5.0),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: AppIcon(
                    icon: Icons.arrow_back,
                    iconColor: AppColors.redColor,
                    backgroundColor: Colors.transparent,
                    iconSize: Dimensions.iconSize24,
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(Dimensions.radius20),
                      border: Border.all(color: AppColors.signColor),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: widget.kategori == "All"
                                  ? "Cari di Rumah Kreatif"
                                  : "Cari di ${widget.kategori}",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius15),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            _search(_searchController.text);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          onPressed: _showFilterModal,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          (!_isTyping && _searchHistory.isNotEmpty)
              ? Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _searchHistory.length > 5
                    ? 5
                    : _searchHistory.length,
                itemBuilder: (context, index) {
                  final keyword = _searchHistory[index]['keyword'];
                  final id = _searchHistory[index]['id'];
                  return ListTile(
                    title: Text(keyword),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () async {
                        await _deleteSearchHistory(id);
                        _loadSearchHistory();
                      },
                    ),
                    onTap: () {
                      _searchController.text = keyword;
                      _search(keyword);
                    },
                  );
                },
              ),
              TextButton(
                onPressed: () async {
                  await _clearSearchHistory();
                  _loadSearchHistory();
                },
                child: Text("Hapus Semua History"),
              )
            ],
          )
              : Container(),

          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: Dimensions.height45 * 7,
            ),
            itemBuilder: (context, index) {
              var produk = _list[index];
              var gambarproduk = Get.find<PopularProdukController>()
                  .imageProdukList
                  .where((img) => img.productId == produk.productId);
              return CardProduk(
                product_id: produk.productId,
                productImageName: gambarproduk.isNotEmpty
                    ? gambarproduk.single.productImageName
                    : "",
                productName: produk.productName,
                merchantAddress: produk.subdistrictName,
                price: produk.price,
                countPurchases: produk.countProductPurchases,
                average_rating: produk.averageRating,
              );
            },
          )
        ]),
      ),
    );
  }
}
