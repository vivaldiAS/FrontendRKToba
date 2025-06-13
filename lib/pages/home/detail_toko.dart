import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/widgets/card_produk.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StorePage extends StatefulWidget {
  final int merchantId;
  const StorePage({Key? key, required this.merchantId}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late Future<Map<String, dynamic>> storeData;
  String sortBy = 'terlaris';  // Default sorting by "terlaris"

  @override
  void initState() {
    super.initState();
    storeData = fetchStoreData(widget.merchantId);
  }

  Future<Map<String, dynamic>> fetchStoreData(int id) async {
    final response = await http.get(Uri.parse('${AppConstants.BASE_URL}toko/$id'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print('Response Body: $decoded'); // Debug: Menampilkan seluruh response body
      return decoded['data'];
    } else {
      throw Exception('Gagal mengambil data toko');
    }
  }

  // Fungsi untuk mengurutkan produk berdasarkan pilihan pengguna
  List sortProducts(List products) {
    if (sortBy == 'terlaris') {
      // Urutkan berdasarkan count_product_purchases (terlaris)
      products.sort((a, b) {
        int countA = int.tryParse(a['count_product_purchases'].toString()) ?? 0;
        int countB = int.tryParse(b['count_product_purchases'].toString()) ?? 0;
        return countB.compareTo(countA); // Mengurutkan dari yang terlaris
      });
    } else if (sortBy == 'terbaru') {
      // Urutkan berdasarkan created_at (terbaru)
      products.sort((a, b) {
        String createdAtA = a['created_at'] ?? '';  // Cek null dan beri string kosong jika null
        String createdAtB = b['created_at'] ?? '';  // Cek null dan beri string kosong jika null

        // Hanya lanjutkan jika created_at tidak kosong
        if (createdAtA.isEmpty || createdAtB.isEmpty) {
          return 0; // Jika salah satu kosong, biarkan mereka tetap dalam posisi yang sama
        }

        DateTime dateA = DateTime.tryParse(createdAtA) ?? DateTime(1970);  // Jika parsing gagal, beri nilai default
        DateTime dateB = DateTime.tryParse(createdAtB) ?? DateTime(1970);  // Jika parsing gagal, beri nilai default

        return dateB.compareTo(dateA); // Mengurutkan dari yang terbaru
      });
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: storeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final store = snapshot.data!;

          // Correctly handle 'produk' being either a list or a map
          final List produkList = store['produk'] is List
              ? store['produk'] // If it's a List, use it directly
              : store['produk']?.values.toList() ?? []; // If it's a Map, convert to List

          // Sorting produk sesuai pilihan
          final sortedProducts = sortProducts(produkList);

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFF9F9F9)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Sampul
                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/Ulos.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Foto profil merchant
                          Positioned(
                            bottom: -50,
                            left: MediaQuery.of(context).size.width / 2 - 50,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: store['foto_merchant'] != null
                                  ? NetworkImage(
                                  '${AppConstants.BASE_URL_IMAGE}u_file/foto_merchant/${store['foto_merchant']}')
                                  : const AssetImage('assets/images/market.png') as ImageProvider,
                              backgroundColor: Colors.transparent,  // Makes background transparent for better design
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              store['nama_merchant'] ?? '-',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              store['deskripsi_toko'] ?? '-',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kontak: ${store['kontak_toko'] ?? '-'}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 10),
                            store['alamat'] != null
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store['alamat']['street_address'] ?? '-',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${store['alamat']['subdistrict_name']}, ${store['alamat']['city_name']}, ${store['alamat']['province_name']}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            )
                                : SizedBox.shrink(),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Urutkan berdasarkan: '),
                                DropdownButton<String>(
                                  value: sortBy,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      sortBy = newValue!;
                                    });
                                  },
                                  items: <String>['terlaris', 'terbaru']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value == 'terlaris' ? 'Terlaris' : 'Terbaru'),
                                    );
                                  }).toList(),
                                  icon: Icon(Icons.sort, color: AppColors.redColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            sortedProducts.isNotEmpty
                                ? GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                mainAxisExtent: Dimensions.height45 * 7,
                              ),
                              itemCount: sortedProducts.length,
                              itemBuilder: (context, index) {
                                final produk = sortedProducts[index];
                                String productImageName = produk['product_image_name'];
                                String productImageUrl = '${AppConstants.BASE_URL_IMAGE}u_file/product_image/$productImageName';

                                return CardProduk(
                                  product_id: produk['id'],
                                  productImageName: productImageUrl,  // Berikan URL lengkap
                                  productName: produk['name'] ?? '-',
                                  merchantAddress: produk['subdistrict_name'] ?? '-',
                                  price: produk['price'] ?? 0,
                                  countPurchases: produk['count_product_purchases']?.toString() ?? '0',
                                );
                              },
                            )
                                : Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: Text(
                                  'Produk tidak tersedia',
                                  style: TextStyle(color: AppColors.redColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
