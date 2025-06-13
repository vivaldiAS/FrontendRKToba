import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';

import '../utils/dimensions.dart';

class MonserratText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  MonserratText(
      {Key? key,
      this.color = const Color(0xFF332d2b),
      required this.text,
      this.size = 20,
      this.overFlow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overFlow,
      style: TextStyle(
          fontFamily: 'Montserrat',
          color: AppColors.blackColor,
          fontSize: size == 0 ? Dimensions.font16 : size),
    );
  }
}
