import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() async {
  Uri url = Uri.parse("https://pro.rajaongkir.com/api/province");

  final response = await http.get(
    url,
    headers: {
      "key": "41df939eff72c9b050a81d89b4be72ba",
    },
  );
  print(response.body);
}
