import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:stackfood_multivendor/features/home/widgets/what_on_your_mind_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<CategoryController>().getCategoryList(false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: WebMenuBar(),
      // appBar: CustomAppBarWidget(title: 'categories'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: Scrollbar(controller: scrollController, child: SingleChildScrollView(
          controller: scrollController, child: FooterViewWidget(
            child: Column(children: [
        Container(
            color: Theme.of(context).primaryColor.withOpacity(0.10),
            child: Center(child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: Responsive.isTablet(context) ? 15 : 0,vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Categories",
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeOverLarge,
                              color: Theme.of(context).primaryColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                   WhatOnYourMindViewWidget()

                ],
              ),
            ),),
          ),


            ],
          )),
        )),
      ),
    );
  }
}
