import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/carousel_model.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';

class CarouselWidget extends StatefulWidget {
  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  List<CarouselModel> carousels = [];

  Future<void> fetchCarousels() async {
    final response = await http.get(Uri.parse('${AppConstants.BASE_URL}carousels'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        carousels = data.map((item) => CarouselModel.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load carousels');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCarousels();
  }

  @override
  Widget build(BuildContext context) {
    return carousels.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Container(
      margin: EdgeInsets.only(top: 10), // Menambahkan margin di atas
      height: 250, // Ukuran carousel sesuai dengan layar
      width: MediaQuery.of(context).size.width, // Sesuaikan lebar dengan layar
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: carousels.length,
        itemBuilder: (context, index) {
          var carousel = carousels[index];
          return GestureDetector(
            onTap: () {
              if (carousel.linkCarousel != null) {
                if (carousel.openInNewTab == 1) {
                  // Handle opening in a new tab or perform any action
                  print('Opening: ${carousel.linkCarousel}');
                }
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 10), // Menambahkan margin di atas
              height: 250, // Tentukan tinggi tetap
              width: MediaQuery.of(context).size.width, // Sesuaikan lebar dengan layar
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: carousels.length,
                itemBuilder: (context, index) {
                  var carousel = carousels[index];
                  return GestureDetector(
                    onTap: () {
                      if (carousel.linkCarousel != null) {
                        if (carousel.openInNewTab == 1) {
                          // Handle opening in a new tab or perform any action
                          print('Opening: ${carousel.linkCarousel}');
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width - 20, // Sesuaikan lebar dengan layar
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15), // Border radius
                        image: DecorationImage(
                          image: NetworkImage(
                            '${AppConstants.BASE_URL_IMAGE}u_file/carousel_image/${carousel.carouselImage}',
                          ),
                          fit: BoxFit.cover, // Memastikan gambar menutupi area
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
