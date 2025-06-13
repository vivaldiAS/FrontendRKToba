import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/pembelian_controller.dart';
import 'package:rumah_kreatif_toba/controllers/pengiriman_controller.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class PengirimanOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final int index;
  const PengirimanOptionButton(
      {Key? key, required this.icon, required this.title, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PengirimanController>(builder: (controller) {
      bool _selected = controller.paymentIndex.value == index;
      print( controller.paymentIndex.value);
      return InkWell(
        onTap: () => {
          controller.setPaymentIndex(index),
          if(index == 1){
            Navigator.pop(context)
          },
          Get.find<PengirimanController>().setTypePengiriman(title),
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20 / 4),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200]!,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(
                  icon,
                  size: 40,
                  color: _selected
                      ? AppColors.redColor
                      : Theme.of(context).disabledColor,
                ),
                title: Text(
                  title,
                  style: TextStyle(fontSize: Dimensions.font16),
                ),
                trailing: _selected
                    ? Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                )
                    : null,
              ),
            ),

          ],
        ),
      );
    });
  }

}
