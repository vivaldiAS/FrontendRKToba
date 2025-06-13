class Subdistrict {
  String? subdistrictId;
  String? cityId;
  String? provinceId;
  String? province;
  String? type;
  String? cityName;
  String? postalCode;
  String? subdistrictName;

  Subdistrict({
    this.provinceId,
    this.province,
    this.type,
    this.cityId,
    this.cityName,
    this.subdistrictId,
    this.subdistrictName,
  });

  Subdistrict.fromJson(Map<String, dynamic> json) {
    provinceId = json['province_id'];
    province = json['province'];
    cityId = json['city_id'];
    type = json['type'];
    cityName = json['city'];
    subdistrictId = json['subdistrict_id'];
    subdistrictName = json['subdistrict_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['city_id'] = cityId;
    data['province_id'] = provinceId;
    data['province'] = province;
    data['type'] = type;
    data['city'] = cityName;
    data['subdistrict_id'] = subdistrictId;
    data['subdistrict_name'] = subdistrictName;
    return data;
  }

  static List<Subdistrict> fromJsonList(List list) {
    if (list.length == 0) return List<Subdistrict>.empty();
    return list.map((item) => Subdistrict.fromJson(item)).toList();
  }

  @override
  String toString() => subdistrictName!;
}
