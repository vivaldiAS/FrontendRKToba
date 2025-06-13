import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';

import '../utils/dimensions.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: Dimensions.height20*5,
        width: Dimensions.height20*5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.height10*5),
        ),
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: AppColors.redColor,),
      ),
    );
  }
}
