import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import '../utils/colors.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController textController;
  final String? hintText;
  final String? labelText;
  final TextInputType textInputType;

  bool isObscure;
  InputTextField({Key? key, required this.textController, this.hintText, this.isObscure = false, this.textInputType = TextInputType.text, this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
      decoration: BoxDecoration(
          color : Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius20/2),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                spreadRadius: 7,
                offset: Offset(1, 1),
                color: Colors.grey.withOpacity(0.2)
            )
          ]
      ),
      child: TextField(
        keyboardType: textInputType,
        obscureText: isObscure?true:false,
        controller: textController,
        decoration: InputDecoration(
            hintText: hintText,
            labelStyle: TextStyle(
                color: AppColors.redColor
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                borderSide: BorderSide(
                    width: 1.0,
                    color: AppColors.redColor
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                borderSide: BorderSide(
                    width: 1.0,
                    color: Colors.white
                )
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius20/2),
            )
        ),
      ),
    );
  }
}
