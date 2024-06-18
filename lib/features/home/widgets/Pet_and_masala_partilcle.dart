import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:universal_html/html.dart';

import '../../../util/images.dart';

class PetFoodAndMasalaParticle extends StatelessWidget {
  const PetFoodAndMasalaParticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Fluttertoast.showToast(
                msg: "NVC Masala & Pickles Coming soon!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            child: Container(height: 100,
                width: Get.size.width,
                clipBehavior: Clip.hardEdge,
                decoration :  BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                child: Image.asset(Images.masalaPickleBanner,fit: BoxFit.cover,)),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault,),
          InkWell(
            onTap: () {
              Fluttertoast.showToast(
                msg: "NVC Pet Food Coming soon!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            child: Container(height: 100,
                width: Get.size.width,
                clipBehavior: Clip.hardEdge,
                decoration :  BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                child: Image.asset(Images.petFoodParticle,fit: BoxFit.cover,)),
          ),
        ],
      ),
    );
  }
}
