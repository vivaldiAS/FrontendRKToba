import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';

import '../utils/dimensions.dart';

class PriceText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  PriceText(
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
      style: GoogleFonts.poppins().copyWith(
          color: AppColors.redColor,
          fontWeight: FontWeight.bold,
          fontSize: size == 0 ? Dimensions.font16 : size),
    );
  }
}
