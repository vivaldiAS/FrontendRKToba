import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/controllers/categories_controller.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'package:get/get.dart';

class AppDropdownFieldKategori extends StatefulWidget {
  final String hintText;
  final bool isObscure;
  final TextEditingController controller;

  const AppDropdownFieldKategori({Key? key, required this.hintText, required this.controller, this.isObscure = false}) : super(key: key);

  @override
  _AppDropdownKategoriState createState() => _AppDropdownKategoriState();
}

class _AppDropdownKategoriState extends State<AppDropdownFieldKategori> {
  String dropdownValue = 'Laki-laki';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
      decoration: BoxDecoration(
          color : Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                spreadRadius: 7,
                offset: Offset(1, 1),
                color: Colors.grey.withOpacity(0.2)
            )
          ]
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          decoration: InputDecoration(
              hintText: widget.hintText,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  borderSide: BorderSide(
                      width: 1.0,
                      color: AppColors.redColor
                  )
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.white
                  )
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              )
          ),
          value: widget.controller.text.isNotEmpty ? widget.controller.text : null,
          onChanged: (dynamic newValue) {
            setState(() {
              dropdownValue = newValue;
            });
            widget.controller.text = newValue;
          },
          items: Get.find<CategoriesController>().kategoriList.map<DropdownMenuItem<dynamic>>((kategori) {
            return DropdownMenuItem<dynamic>(
              value: kategori.namaKategori,
              child: Text(kategori.namaKategori!),
            );
          }).toList(),
        ),
      ),
    );
  }
}
