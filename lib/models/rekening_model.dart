class Rekening {
  int? rekeningId;
  int? userId;
  String? namaBank;
  String? nomorRekening;
  String? atasNama;
  String? createdAt;
  String? updatedAt;

  Rekening(
      {this.rekeningId,
        this.userId,
        this.namaBank,
        this.nomorRekening,
        this.atasNama,
        this.createdAt,
        this.updatedAt});

  Rekening.fromJson(Map<String, dynamic> json) {
    rekeningId = json['rekening_id'];
    userId = json['user_id'];
    namaBank = json['nama_bank'];
    nomorRekening = json['nomor_rekening'];
    atasNama = json['atas_nama'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rekening_id'] = this.rekeningId;
    data['user_id'] = this.userId;
    data['nama_bank'] = this.namaBank;
    data['nomor_rekening'] = this.nomorRekening;
    data['atas_nama'] = this.atasNama;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}