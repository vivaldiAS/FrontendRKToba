import 'dart:convert';

import 'package:rumah_kreatif_toba/models/produk_models.dart';

class CartModel {
  int? cartId, userId, productId, jumlahMasukKeranjang, merchantId, categoryId,
      price, heavy, isDeleted, isVerified, id;
  String? createdAt, updatedAt, productName, productDescription, namaMerchant, deskripsiToko, kontakToko, fotoMerchant,
      username, email, password;
  Null? emailVerifiedAt, isAdmin, isBanned, rememberToken;
  Produk? produk;
  bool isChecked;
  int? cityId;

  CartModel({
    this.cartId,
    this.userId,
    this.productId,
    this.jumlahMasukKeranjang,
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
    this.id,
    this.username,
    this.email,
    this.emailVerifiedAt,
    this.password,
    this.isAdmin,
    this.isBanned,
    this.rememberToken,
    this.cityId,
    this.isChecked = false,
    this.produk
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    cartId: json['cart_id'],
    userId: json['user_id'],
    productId: json['product_id'],
    jumlahMasukKeranjang: json['jumlah_masuk_keranjang'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    merchantId: json['merchant_id'],
    categoryId: json['category_id'],
    productName: json['product_name'],
    productDescription: json['product_description'],
    price: json['price'],
    heavy: json['heavy'],
    isDeleted: json['is_deleted'],
    namaMerchant : json['nama_merchant'],
    deskripsiToko : json['deskripsi_toko'],
    kontakToko : json['kontak_toko'],
    fotoMerchant : json['foto_merchant'],
    isVerified : json['is_verified'],
    id: json['id'],
    username: json['username'],
    email: json['email'],
    emailVerifiedAt: json['email_verified_at'],
    password: json['password'],
    isAdmin: json['is_admin'],
    isBanned: json['is_banned'],
    rememberToken: json['remember_token'],
    cityId : json['city_id'],
    produk : json['produk'] != null ? Produk.fromJson(json['produk']) : null,
  );

  Map<String, dynamic> toJson() => {
    'cart_id': cartId,
    'user_id': userId,
    'product_id': productId,
    'jumlah_masuk_keranjang': jumlahMasukKeranjang,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'merchant_id': merchantId,
    'category_id': categoryId,
    'product_name': productName,
    'product_description': productDescription,
    'price': price,
    'heavy': heavy,
    'is_deleted': isDeleted,
    'nama_merchant' : namaMerchant,
    'deskripsi_toko' : deskripsiToko,
    'kontak_toko' : kontakToko,
    'foto_merchant' : fotoMerchant,
    'is_verified' : isVerified,
    'id': id,
    'username': username,
    'email': email,
    'email_verified_at': emailVerifiedAt,
    'password': password,
    'is_admin': isAdmin,
    'is_banned': isBanned,
    'remember_token': rememberToken,
    'city_id' : cityId
  };

  bool getChecked() {
    return isChecked;
  }
}
