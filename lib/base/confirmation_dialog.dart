import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';

Future<void> showConfirmPopUp({
  String? title,
  String? acceptActionButton,
  String? cancelActionButton,
  Function()? onCancel,
  Function()? onAccept,
  Widget? iconCenter,
  String? subTitle,
  TextAlign? subtitleAlign,
  Widget? content,
  String? failedIcon,
  Widget? child,
  double? height,
}) async {
  await Get.dialog(
    Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            InkWell(
                onTap: Get.back,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: SizedBox(
                  height: Get.context?.size?.height,
                  width: Get.context?.size?.width,
                )),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20)),
                height: height ?? 270,
                width: 320,
                margin: EdgeInsets.symmetric(horizontal: 34),
                child: child ??
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        if (iconCenter != null) iconCenter,
                        if (title != null)
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 6),
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                        if (subTitle != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text(
                              subTitle,
                              textAlign: subtitleAlign ?? TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        if (content != null) content,
                        const Spacer(),
                        const Divider(
                            thickness: 0.5, color: Colors.black, height: 0),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onAccept,
                            child: SizedBox(
                              height: 54,
                              width: Get.context?.size?.width,
                              child: Center(
                                child: Text(
                                  acceptActionButton ?? 'Oke',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                            thickness: 0.5, color: Colors.black, height: 0),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onCancel,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            child: SizedBox(
                              height: 54,
                              width: Get.context?.size?.width,
                              child: Center(
                                child: Text(
                                  cancelActionButton ?? 'Batal',
                                  style: TextStyle(
                                    color: AppColors.redColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ],
        )),
    barrierDismissible: true,
  );
}
