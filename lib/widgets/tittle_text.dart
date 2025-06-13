import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/dimensions.dart';

class TittleText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final TextOverflow overFlow;
  final int maxLines;

  const TittleText({
    Key? key,
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 20,
    this.overFlow = TextOverflow.ellipsis,
    this.maxLines = 2, // default tetap 2 agar kompatibel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overFlow,
      style: GoogleFonts.poppins().copyWith(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: size == 0 ? Dimensions.font16 : size,
      ),
    );
  }
}
