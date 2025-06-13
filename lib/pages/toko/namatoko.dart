import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/pages/toko/toko.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/app_text_field.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'dart:io';
import '../../base/show_custom_message.dart';
import '../../base/snackbar_message.dart';
import '../../controllers/toko_controller.dart';
import '../../controllers/user_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/small_text.dart';
import '../home/home_page.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
class NamaToko extends StatefulWidget {
  const NamaToko({Key? key}) : super(key: key);

  @override
  State<NamaToko> createState() => _NamaTokoState();
}

class _NamaTokoState extends State<NamaToko> {

  var NamaTokoController = TextEditingController();
  var DeskripsiTokoController = TextEditingController();
  var KontakTokoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> _tambahToko() async {
      String namatoko = NamaTokoController.text.trim();
      String deskripsitoko = DeskripsiTokoController.text.trim();
      String kontaktoko = KontakTokoController.text.trim();


      if(namatoko.isEmpty){
        AwesomeSnackbarButton("Warning","Nama toko masih kosong",ContentType.warning);
      }else if(deskripsitoko.isEmpty){
        AwesomeSnackbarButton("Warning","Deskripsi toko masih kosong",ContentType.warning);
      }else if(kontaktoko.isEmpty){
        AwesomeSnackbarButton("Warning","Kontak toko masih kosong",ContentType.warning);
      }else{
        var userController = Get.find<UserController>().usersList[0];

        var controller = Get.find<TokoController>();
        controller.tambahToko(userController.id, namatoko, deskripsitoko, kontaktoko).then((status) async {

        });
      }
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: Dimensions.height30, bottom: Dimensions.height20),
              padding: EdgeInsets.only(left: Dimensions.width10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(HomePage(initialIndex: 4));
                    },
                    child: AppIcon(
                      icon: Icons.arrow_back,
                      iconColor: AppColors.redColor,
                      backgroundColor: Colors.white.withOpacity(0.0),
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.width10,
                  ),
                  Container(
                    child: BigText(
                      text: "Profil Toko",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: AppTextField(
                      textController: NamaTokoController,
                      hintText: "Nama toko anda",
                      icon: Icons.shopping_bag,
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  Container(
                    child: AppTextField(
                      textController: DeskripsiTokoController,
                      hintText: "Deskripsi toko anda",
                      icon: Icons.description,
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  Container(
                    child: AppTextField(
                      textController: KontakTokoController,
                      hintText: "Kontak toko anda",
                      icon: Icons.call,
                      textInputType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  GetBuilder<TokoController>(builder: (controllertoko) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            controllertoko.pickImageFotoMerchant();
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.height20, right: Dimensions.height20, bottom: Dimensions.height20),
                              padding: EdgeInsets.only(
                                  left: Dimensions.width10, right: Dimensions.width20, top: Dimensions.height20, bottom: Dimensions.height20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(Dimensions.radius20),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        spreadRadius: 7,
                                        offset: Offset(1, 1),
                                        color: Colors.grey.withOpacity(0.2))
                                  ]),
                              child: Row(
                                children: [
                                  Icon(Icons.photo, color: AppColors.redColor,),
                                  SizedBox(width: Dimensions.width10,),
                                  SmallText(text:"Pilih Foto Toko Anda", size: Dimensions.font16,),
                                ],
                              )
                          ),
                        )
                        ,
                        controllertoko.pickedFileFotoMerchant != null
                            ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              //to show image, you type like this.
                              File(controllertoko.pickedFileFotoMerchant!.path),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                            ),
                          ),
                        )
                            : BigText(text: "Tidak Ada Gambar", size: Dimensions.font16,)
                      ],
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                _tambahToko();
              },
              child: Container(
                width: Dimensions.screenWidth / 1.5,
                height: Dimensions.height45,
                // alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.redColor),
                child: Center(
                  child: BigText(
                    text: "Lanjut",
                    fontWeight: FontWeight.bold,
                    size: Dimensions.font20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
