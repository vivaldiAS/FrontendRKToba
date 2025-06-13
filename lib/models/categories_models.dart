class Categories {
  int? categoryId;
  String? namaKategori;

  Categories({this.categoryId, this.namaKategori});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    namaKategori = json['nama_kategori'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['nama_kategori'] = this.namaKategori;
    return data;
  }
}