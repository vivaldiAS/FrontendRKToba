import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppDropdownField extends StatefulWidget {
  final String? hintText;
  final IconData? icon;
  final TextEditingController controller;

  const AppDropdownField({
    Key? key,
    this.hintText,
    this.icon,
    required this.controller,
  }) : super(key: key);

  @override
  _AppDropdownFieldState createState() => _AppDropdownFieldState();
}

class _AppDropdownFieldState extends State<AppDropdownField> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height10 / 1.5,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding:
            EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: AppColors.redColor)
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide:
              BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: AppColors.redColor, width: 1.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          value: widget.controller.text.isNotEmpty
              ? widget.controller.text
              : null,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue;
              widget.controller.text = newValue!;
            });
          },
          items: <String>['Laki-laki', 'Perempuan']
              .map((value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
              .toList(),
        ),
      ),
    );
  }
}

