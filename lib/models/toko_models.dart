class Toko {
  int? merchant_id;
  int? user_id;
  String? nama_merchant;
  String? deskripsi_toko;
  String? kontak_toko;
  String? foto_merchant;
  int? is_verified;
  String? createdAt;
  String? updatedAt;

  Toko({
    this.merchant_id,
    this.user_id,
    this.nama_merchant,
    this.deskripsi_toko,
    this.kontak_toko,
    this.foto_merchant,
    this.is_verified,
    this.createdAt,
    this.updatedAt,
  });

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
      merchant_id: json['merchant_id'],
      user_id: json['user_id'],
      nama_merchant: json['nama_merchant'],
      deskripsi_toko: json['deskripsi_toko'],
      kontak_toko: json['kontak_toko'],
      foto_merchant: json['foto_merchant'],
      is_verified: json['is_verified'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchant_id'] = this.merchant_id;
    data['user_id'] = this.user_id;
    data['nama_merchant'] = this.nama_merchant;
    data['deskripsi_toko'] = this.deskripsi_toko;
    data['kontak_toko'] = this.kontak_toko;
    data['foto_merchant'] = this.foto_merchant;
    data['is_verified'] = this.is_verified;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
