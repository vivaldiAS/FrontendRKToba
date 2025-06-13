import 'package:http/http.dart' as http;

void main() async{
  Uri url = Uri.parse("https://pro.rajaongkir.com/api/cost");
  final response = await http.post(
    url,
    body: {
      "origin" : "501",
      "originType" : "city",
      "destination" : "574",
      "destinationType":"subdistrict",
      "weight" : "1700",
      "courier" : "jne",
    },
    headers: {
      "key" : "41df939eff72c9b050a81d89b4be72ba",
      "content-type" : "application/x-www-form-urlencoded"
    },
  );

  print(response.body);
}