import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  TextAlign textAlign;
  FontWeight fontWeight;

  BigText({
    Key? key,
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 16,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.normal,
    this.overFlow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overFlow, // Overflow behavior (ellipsis, fade, clip)
      textAlign: textAlign,
      style: GoogleFonts.poppins().copyWith(
        color: color,
        fontWeight: fontWeight,
        fontSize: size == 0 ? Dimensions.font16 : size,
      ),
    );
  }
}
