import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppDropdownField extends StatefulWidget {
  final String? hintText;
  final IconData? icon;
  final bool isObscure;
  final TextEditingController controller;

  const AppDropdownField({Key? key, this.hintText, this.icon, required this.controller, this.isObscure = false}) : super(key: key);

  @override
  _AppDropdownState createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdownField> {
  String? dropdownValue ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 7,
            offset: Offset(1, 1),
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.icon == null ? null : Icon(widget.icon, color: AppColors.redColor,),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(
                width: 1.0,
                color: AppColors.redColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(
                width: 1.0,
                color: Colors.white,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
          ),
          value: widget.controller.text.isNotEmpty ? widget.controller.text : null,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
            widget.controller.text = newValue!;
          },
          items: <String>['Laki-laki', 'Perempuan']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: IntrinsicWidth(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(value),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );

  }
}
