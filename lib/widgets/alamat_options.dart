import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/controllers/pengiriman_controller.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';
import 'package:get/get.dart';
class AlamatOption extends StatelessWidget {
  final String value;
  final String street;
  final String city;
  final String province;
  const AlamatOption({Key? key, required this.street, required this.city, required this.province, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PengirimanController>(builder: (controller){
      return Row(
        children: [
          Container(width: Dimensions.screenWidth/1.7,
              child: SmallText(text: "${street}, ${city}, ${province}")),
          SizedBox(width: Dimensions.width20,),
          Radio(value: value, groupValue: controller.alamatType, onChanged: (String? value)=>controller.setTypeAlamat(value!)),
        ],
      );
    });
  }
}
