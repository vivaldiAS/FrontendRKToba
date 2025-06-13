import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';
import '../auth/masuk.dart';
import '../auth/register.dart';

class MainAccountPage extends StatefulWidget {
  const MainAccountPage({Key? key}) : super(key: key);

  @override
  State<MainAccountPage> createState() => _MainAccountPageState();
}

class _MainAccountPageState extends State<MainAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/account_background.jpg"),
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.7),
              BlendMode.dstATop,
            ),
          ),
        ),
        padding: EdgeInsets.only(
            bottom: Dimensions.height45*2,
            left: Dimensions.width45,
            right: Dimensions.width45
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Dimensions.width45*3,
              height: Dimensions.height45*3,
              margin: EdgeInsets.only(
                left: Dimensions.width10,
                right: Dimensions.width10,
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          "assets/images/logo_rkt.png"))),
            ),
            Container(
              margin: EdgeInsets.only(
                top: Dimensions.width10,
                bottom: Dimensions.height10,
              ),
              child: BigText(text: "Rumah Kreatif Toba", fontWeight: FontWeight.bold,color: Colors.white,size: Dimensions.font26*1.5,),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: Dimensions.height30,
              ),
              child: SmallText(text: "Temukan produk spesial untukmu",color: Colors.white, size: Dimensions.font20/1.3,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => Masuk());
                  },
                  child: Container(
                      width: Dimensions.screenWidth / 4,
                      height: Dimensions.screenHeight / 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Dimensions.radius30),
                        color: AppColors.redColor,
                      ),
                      child: Center(
                        child: BigText(
                            text: "Masuk",
                            size: Dimensions.font20/1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),

                SizedBox(
                  width: Dimensions.width20*2,
                ),
                //daftar
                GestureDetector(
                  onTap: () {
                    Get.to(() => Register());
                  },
                  child: Container(
                      width: Dimensions.screenWidth / 4,
                      height: Dimensions.screenHeight / 18,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(Dimensions.radius30),
                        color: Colors.white.withOpacity(0.0),
                        border: Border.all(color: AppColors.redColor),
                      ),
                      child: Center(
                        child: BigText(
                            text: "Daftar",
                            size: Dimensions.font20/1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ],
        )
    );
  }
}
