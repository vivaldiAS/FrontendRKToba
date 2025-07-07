import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/cart_controller.dart';
import 'package:rumah_kreatif_toba/controllers/popular_produk_controller.dart';
import 'package:rumah_kreatif_toba/controllers/wishlist_controller.dart';
import 'package:rumah_kreatif_toba/pages/pembelian/beli_langsung_page.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/app_icon.dart';
import 'package:rumah_kreatif_toba/widgets/expandable_text_widget.dart';
import 'package:rumah_kreatif_toba/widgets/price_text.dart';
import 'package:rumah_kreatif_toba/chat/chat_page.dart';
import 'package:rumah_kreatif_toba/chat/chat_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rumah_kreatif_toba/pages/review/review_widget.dart';
import '../home/detail_toko.dart';

import '../../base/snackbar_message.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/produk_models.dart';
import '../../utils/app_constants.dart';
import '../../widgets/big_text.dart';
import '../../widgets/card_produk.dart';
import '../../widgets/currency_format.dart';

class ProdukDetail extends StatefulWidget {
  const ProdukDetail({Key? key}) : super(key: key);

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  late Produk selectedProduct;
  bool isProdukExist = false;
  WishlistController isGetProdukExist = Get.find<WishlistController>();
  PageController pageController = PageController(viewportFraction: 0.90);
  PageController pageControllerPopulerProduct = PageController(viewportFraction: 0.90);

  var _currPageValue = 0.0;
  var _currPageValuePopulerProduct = 0.0;
  double _scaleFactor = 0.8;
  double _height = 200;

  // Kontrol jumlah produk serupa yang ditampilkan
  int produkSerupaLimit = 6;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = Get.arguments;

    // Pastikan data produk yang diterima diupdate sesuai dengan yang dipilih
    if (arguments != null && arguments['product'] != null) {
      selectedProduct = arguments['product']; // Produk yang dipilih
      Get.find<PopularProdukController>().getKategoriProdukList("${selectedProduct.namaKategori}");
    } else {
      // Fallback jika data produk tidak diterima
      selectedProduct = Get.find<PopularProdukController>().detailProdukList.first;
    }

    var wishlistList = Get.find<WishlistController>().wishlistList;
    isProdukExist = wishlistList.any((wishlist) => wishlist.productId == selectedProduct.productId.toInt());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
    pageControllerPopulerProduct.addListener(() {
      setState(() {
        _currPageValuePopulerProduct = pageControllerPopulerProduct.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    var produkList = arguments != null && arguments['product'] != null
        ? [arguments['product']]
        : Get.find<PopularProdukController>().detailProdukList;

    var daftarproduk = produkList.firstWhere(
            (produk) => produk.productId == produkList[0].productId.toInt());
    Get.find<PopularProdukController>().getKategoriProdukList("${selectedProduct.namaKategori}");
    var wishlistList = Get.find<WishlistController>().wishlistList;
    isProdukExist = wishlistList.any(
            (wishlist) => wishlist.productId == produkList[0].productId.toInt());

    Future<void> _tambahKeranjang(CartController cartController) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<UserController>().usersList[0];
        cartController.tambahKeranjang(controller.id, produkList[0].productId.toInt(), 1).then((status) {
          if (status.isSuccess) {
            AwesomeSnackbarButton("Berhasil", "Produk berhasil ditambahkan ke keranjang", ContentType.success);
          } else {
            AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
          }
        });
        cartController.getKeranjangList();
      }
    }

    Future<void> _tambahWishlist() async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<UserController>().usersList[0];

        var wishlistController = Get.find<WishlistController>();
        wishlistController.tambahWishlist(controller.id, produkList[0].productId.toInt()).then((status) {
          if (status.isSuccess) {
          } else {
            AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
          }
        });
        wishlistController.getWishlistList();
      }
    }

    Future<void> _hapusWishlist(int wishlist_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<UserController>();
        await controller.getUser();
        var cartController = Get.find<WishlistController>();
        cartController.hapusWishlist(wishlist_id).then((status) {
          if (status.isSuccess) {
            AwesomeSnackbarButton("Berhasil", "Produk berhasil dihapus", ContentType.success);
            isGetProdukExist.isProdukExist.value = false;
          } else {
            AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
          }
        });
        cartController.getWishlistList();
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.height30, bottom: Dimensions.height10),
                  padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: AppIcon(
                          icon: Icons.arrow_back,
                          size: Dimensions.height45,
                          iconColor: AppColors.redColor,
                          backgroundColor: Colors.white.withOpacity(0.0),
                        ),
                      ),
                      Center(
                          child: Row(
                            children: [
                              GetBuilder<CartController>(builder: (controller) {
                                return GestureDetector(
                                  onTap: () {
                                    if (Get.find<AuthController>().userLoggedIn()) {
                                      Get.toNamed(RouteHelper.getKeranjangPage());
                                    } else {
                                      Get.toNamed(RouteHelper.getMasukPage());
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      AppIcon(
                                        icon: Icons.shopping_cart_outlined,
                                        size: Dimensions.height45,
                                        iconColor: AppColors.redColor,
                                        backgroundColor: Colors.white.withOpacity(0.0),
                                      ),
                                      controller.keranjangList.length >= 1
                                          ? Positioned(
                                          right: 0,
                                          top: 0,
                                          child: AppIcon(
                                            icon: Icons.circle,
                                            size: 20,
                                            iconColor: AppColors.notification_success,
                                          ))
                                          : Container(),
                                      controller.keranjangList.length >= 1
                                          ? Positioned(
                                        right: 6,
                                        top: 3,
                                        child: BigText(
                                          text: controller.keranjangList.length.toString(),
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      )
                                          : Container(),
                                    ],
                                  ),
                                );
                              })
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              Container(
                height: Dimensions.pageView,
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: PageView.builder(
                    controller: pageController,
                    itemCount: produkList.length,
                    itemBuilder: (context, position) {
                      return _buildPageItem(position, produkList[position]);
                    }),
              ),
              DotsIndicator(
                dotsCount: produkList.isEmpty ? 1 : produkList.length,
                position: _currPageValue,
                decorator: DotsDecorator(
                  activeColor: AppColors.redColor,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
              Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, top: Dimensions.height20),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radius20), topRight: Radius.circular(Dimensions.radius20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceText(
                            text: CurrencyFormat.convertToIdr(selectedProduct.price, 0),
                            color: AppColors.blackColor,
                            size: Dimensions.font20,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (Get.find<AuthController>().userLoggedIn()) {
                                if (isProdukExist) {
                                  Get.find<WishlistController>().setTypeWishlist(selectedProduct.productId, false);
                                  _hapusWishlist(produkList[0].productId.toInt());
                                  isProdukExist = false;
                                } else if (!isProdukExist) {
                                  Get.find<WishlistController>().setTypeWishlist(selectedProduct.productId, true);
                                  _tambahWishlist();
                                  isProdukExist = true;
                                }
                              } else {
                                Get.toNamed(RouteHelper.getMasukPage());
                              }
                            },
                            child: Obx(() => Get.find<WishlistController>().getcheckedtypeWishlist[selectedProduct.productId] ?? false
                                ? Icon(
                              Icons.favorite,
                              color: Colors.pink,
                            )
                                : Icon(CupertinoIcons.heart)),
                          )
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: BigText(
                      text: selectedProduct.productName.toString(),
                      color: AppColors.blackColor,
                      size: Dimensions.font20,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: AppColors.buttonBackgroundColor),
                        BigText(
                          text: "Kategori : ${selectedProduct.namaKategori}",
                          size: Dimensions.font26 / 2,
                        ),
                        BigText(
                          text: "Berat : ${selectedProduct.heavy} gr",
                          size: Dimensions.font26 / 2,
                        ),
                        BigText(
                          text: "Stok : ${selectedProduct.stok}",
                          size: Dimensions.font26 / 2,
                        ),
                        SizedBox(
                          width: Dimensions.height20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                    child: BigText(
                      text: "Deskripsi",
                      size: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                    child: SingleChildScrollView(
                      child: ExpandableTextWidget(text: selectedProduct.productDescription.toString()),
                    ),
                  ),
                  Divider(color: AppColors.buttonBackgroundColor),
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius15)),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                '${AppConstants.BASE_URL_IMAGE}u_file/foto_merchant/${selectedProduct.fotoMerchant.toString()}',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (selectedProduct.merchantId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StorePage(merchantId: selectedProduct.merchantId!),
                                  ),
                                );
                              } else {
                                // Optional: Tampilkan pesan error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('ID Merchant tidak tersedia')),
                                );
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BigText(
                                  text: selectedProduct.namaMerchant.toString(),
                                  fontWeight: FontWeight.bold,
                                  size: Dimensions.font26 / 2,
                                ),
                                BigText(
                                  text: selectedProduct.cityName.toString(),
                                  size: Dimensions.font16 / 1.5,
                                ),
                                BigText(
                                  text: selectedProduct.subdistrictName.toString(),
                                  size: Dimensions.font16 / 1.5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      top: Dimensions.height10,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        int merchantId = selectedProduct.merchantId!;
                        String namaMerchant = selectedProduct.namaMerchant!;

                        Get.to(() => ChatDetailPage(
                          merchantId: merchantId,
                          namaMerchant: namaMerchant,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height10,
                          horizontal: Dimensions.width20,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat, color: Colors.white),
                          SizedBox(width: Dimensions.width10),
                          BigText(
                            text: "Chat dengan Toko",
                            color: Colors.white,
                            size: Dimensions.font16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ReviewSection(productId: selectedProduct.productId),
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, top: Dimensions.height10),
                    child: BigText(
                      text: "Produk lain yang serupa",
                      size: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GetBuilder<PopularProdukController>(
                    builder: (produkKategori) {
                      if (!produkKategori.isLoaded) {
                        return Center(child: CircularProgressIndicator(color: AppColors.redColor));
                      }

                      // Filter produk serupa dan hilangkan yang sedang ditampilkan
                      var produkSerupa = produkKategori.kategoriProdukList
                          .where((produk) => produk.namaKategori == selectedProduct.namaKategori)
                          .toList();

                      produkSerupa.removeWhere((produk) => produk.productId == selectedProduct.productId);

                      if (produkSerupa.isEmpty) {
                        return Center(child: Text("Tidak ada produk serupa"));
                      }

                      // Batasi jumlah produk yang ditampilkan
                      int tampilkan = produkSerupa.length < produkSerupaLimit ? produkSerupa.length : produkSerupaLimit;

                      return Column(
                        children: [
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: Dimensions.height45 * 7.5,
                            ),
                            itemCount: tampilkan,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final produk = produkSerupa[index];

                              String imageName = 'default.jpg';
                              final matched = produkKategori.imageProdukList.firstWhere(
                                    (img) => img.productId == produk.productId,
                                orElse: () => null,
                              );
                              if (matched != null && matched.productImageName != null) {
                                imageName = matched.productImageName;
                              }

                              return CardProduk(
                                product_id: produk.productId,
                                productImageName: imageName,
                                productName: produk.productName,
                                merchantAddress: produk.subdistrictName,
                                price: produk.price,
                                countPurchases: produk.countProductPurchases,
                              );
                            },
                          ),
                          if (produkSerupa.length > tampilkan)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    produkSerupaLimit += 6; // Tambah 6 produk lagi
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppColors.redColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Lihat lebih banyak",
                                  style: TextStyle(
                                    color: AppColors.redColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: GetBuilder<PopularProdukController>(
          builder: (produk) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<CartController>(builder: (cartController) {
                  return Container(
                    padding: EdgeInsets.only(
                        top: Dimensions.height10,
                        bottom: Dimensions.height10,
                        left: Dimensions.width20,
                        right: Dimensions.width20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.height10 / 2,
                              bottom: Dimensions.height10 / 2,
                              left: Dimensions.width10,
                              right: Dimensions.width20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
                            color: Colors.white,
                            border: Border.all(color: Colors.redAccent),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (Get.find<AuthController>().userLoggedIn()) {
                                _tambahKeranjang(cartController);
                              } else {
                                Get.toNamed(RouteHelper.getMasukPage());
                              }
                            },
                            child: Row(children: [
                              AppIcon(
                                  iconSize: Dimensions.iconSize16,
                                  iconColor: Colors.redAccent,
                                  backgroundColor: Colors.white,
                                  icon: Icons.add),
                              BigText(
                                text: "Keranjang",
                                color: Colors.redAccent,
                                size: Dimensions.height15,
                              ),
                            ]),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.height20 / 1.1,
                              bottom: Dimensions.height20 / 1.1,
                              left: Dimensions.width10,
                              right: Dimensions.width10),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.redColor),
                              borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
                              color: Colors.redAccent),
                          child: GestureDetector(
                              onTap: () {
                                if (Get.find<AuthController>().userLoggedIn()) {
                                  Get.find<CartController>().items.clear();
                                  Get.find<CartController>().addItem(daftarproduk, 1);
                                  Get.to(BeliLangsungPage());
                                } else {
                                  Get.toNamed(RouteHelper.getMasukPage());
                                }
                              },
                              child: Row(children: [
                                BigText(
                                  text: "Beli Sekarang",
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  size: Dimensions.height15,
                                ),
                              ])),
                        )
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ));
  }

  Widget _buildPageItem(int index, Produk produkList) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale = _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: Dimensions.pageViewContainer,
            margin: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${produkList.productImageName.toString()}',
                    ))),
          )
        ],
      ),
    );
  }
}