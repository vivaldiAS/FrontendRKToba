class Alamat {
  int? user_address_id;
  int? user_id;
  int? province_id;
  String? province_name;
  int? city_id;
  String? city_name;
  int? subdistrict_id;
  String? subdistrict_name;
  String? user_street_address;
  int? is_deleted;

  Alamat({this.user_address_id, this.user_id, this.province_id, this.province_name, this.city_id, this.city_name, this.subdistrict_id, this.subdistrict_name, this.user_street_address, this.is_deleted});

  Alamat.fromJson(Map<String, dynamic> json) {
    user_address_id = json['user_address_id'];
    user_id = json['user_id'];
    province_id = json['province_id'];
    province_name = json['province_name'];
    city_id = json['city_id'];
    city_name = json['city_name'];
    subdistrict_id = json['subdistrict_id'];
    subdistrict_name = json['subdistrict_name'];
    user_street_address = json['user_street_address'];
    is_deleted = json['is_deleted'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_address_id'] = this.user_address_id;
    data['user_id'] = this.user_id;
    data['province_id'] = this.province_id;
    data['province_name'] = this.province_name;
    data['city_id'] = this.city_id;
    data['city_name'] = this.city_name;
    data['subdistrict_id'] = this.subdistrict_id;
    data['subdistrict_name'] = this.subdistrict_name;
    data['user_street_address'] = this.user_street_address;
    data['is_deleted'] = this.is_deleted;
    return data;
  }
}