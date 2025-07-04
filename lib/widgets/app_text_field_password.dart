import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import '../utils/colors.dart';

class AppTextFieldPassword extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData? icon;
  final TextInputType textInputType;

  AppTextFieldPassword({
    Key? key,
    required this.textController,
    required this.hintText,
    this.icon,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  _AppTextFieldPasswordState createState() => _AppTextFieldPasswordState();
}

class _AppTextFieldPasswordState extends State<AppTextFieldPassword> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height10 / 1.5,
      ),
      child: TextField(
        controller: widget.textController,
        obscureText: isObscure,
        keyboardType: widget.textInputType,
        style: TextStyle(fontSize: Dimensions.font16),
        decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding:
          EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: AppColors.redColor)
              : null,
          suffixIcon: IconButton(
            icon: Icon(
              isObscure ? Icons.visibility_off : Icons.visibility,
              color: AppColors.redColor,
            ),
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
          ),
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
    );
  }
}

