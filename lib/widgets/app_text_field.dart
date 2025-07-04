import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import '../utils/colors.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData? icon;
  final TextInputType textInputType;
  final bool isObscure;

  AppTextField({
    Key? key,
    required this.textController,
    required this.hintText,
    this.icon,
    this.isObscure = false,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputFormatters = textInputType == TextInputType.number
        ? [FilteringTextInputFormatter.digitsOnly]
        : null;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height10 / 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optional label text (if needed, you can pass label as new parameter)
          // Text(
          //   "Username/Email *",
          //   style: TextStyle(
          //     fontWeight: FontWeight.w600,
          //     fontSize: Dimensions.font16,
          //     color: Colors.black87,
          //   ),
          // ),
          // SizedBox(height: 6),

          TextField(
            controller: textController,
            obscureText: isObscure,
            keyboardType: textInputType,
            inputFormatters: inputFormatters,
            style: TextStyle(fontSize: Dimensions.font16),
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding:
              EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: icon != null
                  ? Icon(icon, color: AppColors.redColor)
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: AppColors.redColor, width: 1.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
