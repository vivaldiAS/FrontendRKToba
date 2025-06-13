class City {
  String? cityId;
  String? provinceId;
  String? province;
  String? type;
  String? cityName;

  City({
    this.cityId,
    this.provinceId,
    this.province,
    this.type,
    this.cityName,
  });

  City.fromJson(Map<String, dynamic> json) {
    provinceId = json['province_id'];
    province = json['province'];
    cityId = json['city_id'];
    type = json['type'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['province_id'] = provinceId;
    data['province'] = province;
    data['type'] = type;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    return data;
  }

  static List<City> fromJsonList(List list) {
    if (list.length == 0) return List<City>.empty();
    return list.map((item) => City.fromJson(item)).toList();
  }

  @override
  String toString() => cityName!;
}
