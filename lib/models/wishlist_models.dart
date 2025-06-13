class WishlistModel {
  int? wishlistId;
  int? userId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  int? merchantId;
  int? categoryId;
  String? productName;
  String? productDescription;
  int? price;
  int? heavy;
  int? isDeleted;
  String? namaMerchant;
  String? deskripsiToko;
  String? kontakToko;
  String? fotoMerchant;
  int? isVerified;
  String? subdistrictName;

  WishlistModel(
      {this.wishlistId,
        this.userId,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.merchantId,
        this.categoryId,
        this.productName,
        this.productDescription,
        this.price,
        this.heavy,
        this.isDeleted,
        this.namaMerchant,
        this.deskripsiToko,
        this.kontakToko,
        this.fotoMerchant,
        this.isVerified,
        this.subdistrictName
      });

  WishlistModel.fromJson(Map<String, dynamic> json) {
    wishlistId = json['wishlist_id'];
    userId = json['user_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    merchantId = json['merchant_id'];
    categoryId = json['category_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    price = json['price'];
    heavy = json['heavy'];
    isDeleted = json['is_deleted'];
    namaMerchant = json['nama_merchant'];
    deskripsiToko = json['deskripsi_toko'];
    kontakToko = json['kontak_toko'];
    fotoMerchant = json['foto_merchant'];
    isVerified = json['is_verified'];
    subdistrictName = json['subdistrict_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wishlist_id'] = this.wishlistId;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['merchant_id'] = this.merchantId;
    data['category_id'] = this.categoryId;
    data['product_name'] = this.productName;
    data['product_description'] = this.productDescription;
    data['price'] = this.price;
    data['heavy'] = this.heavy;
    data['is_deleted'] = this.isDeleted;
    data['nama_merchant'] = this.namaMerchant;
    data['deskripsi_toko'] = this.deskripsiToko;
    data['kontak_toko'] = this.kontakToko;
    data['foto_merchant'] = this.fotoMerchant;
    data['is_verified'] = this.isVerified;
    data['subdistrict_name'] = this.subdistrictName;
    return data;
  }
}