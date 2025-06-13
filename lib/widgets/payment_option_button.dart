import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/pengiriman_controller.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class PaymentOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final int index;

  const PaymentOptionButton(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subTitle,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PengirimanController>(builder: (pengirimanController) {
      bool _selected = pengirimanController.paymentIndex == index;
      return InkWell(
        onTap: () => {
          pengirimanController.setPaymentIndex(index),
          Get.find<PengirimanController>().typePengiriman,
          Navigator.pop(context)
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius20 / 4),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)
              ]),
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
              style: TextStyle(fontSize: Dimensions.font20),
            ),
            subtitle: Text(
              subTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontSize: Dimensions.font16),
            ),
            trailing: _selected
                ? Icon(Icons.check_circle,
                    color: Theme.of(context).primaryColor)
                : null,
          ),
        ),
      );
    });
  }
}
