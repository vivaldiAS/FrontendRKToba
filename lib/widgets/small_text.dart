import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;
  TextAlign textAlign;
  SmallText(
      {Key? key,
        this.color = const Color(0xFF625D5D),
        required this.text,
        this.size = 12,
        this.height = 1.2,
        this.textAlign = TextAlign.start,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins().copyWith(
          color: color,
          fontWeight: FontWeight.w400,
          fontSize: size)
    );
  }
}
