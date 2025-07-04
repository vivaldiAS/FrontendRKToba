import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/dimensions.dart';
import '../utils/colors.dart';

class AppDateField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData? icon;
  final bool isObscure;

  AppDateField({
    Key? key,
    required this.textController,
    required this.hintText,
    this.icon,
    this.isObscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height10 / 1.5,
      ),
      child: TextField(
        controller: textController,
        obscureText: isObscure,
        readOnly: true,
        style: TextStyle(fontSize: Dimensions.font16),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1800),
            lastDate: DateTime(2101),
          );

          if (pickedDate != null) {
            String formattedDate =
            DateFormat('dd-MM-yyyy').format(pickedDate);
            textController.text = formattedDate;
          }
        },
      ),
    );
  }
}



