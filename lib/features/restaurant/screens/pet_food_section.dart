// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stackfood_multivendor/common/widgets/particular_category_view_widget.dart';
// import 'package:stackfood_multivendor/common/widgets/pets_particular_category_view_widget.dart';
// import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
// import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
// import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
// import 'package:stackfood_multivendor/helper/route_helper.dart';
//
// import '../../../common/models/product_model.dart';
// import '../../../common/widgets/home_category_product_view.dart';
// import '../../../helper/responsive_helper.dart';
// import '../../../util/dimensions.dart';
// import '../../../util/styles.dart';
//
// class PetFoodCategoryWidget extends StatefulWidget {
//   final String? categoryID;
//   final String categoryName;
//   final String categoryBanner;
//   final String heading;
//   // final bool isCooked;
//
//   const PetFoodCategoryWidget({
//     Key? key,
//     required this.categoryID,
//     required this.categoryName,
//     required this.categoryBanner,
//     required this.heading,
//     // required this.isCooked,
//   }) : super(key: key);
//
//   @override
//   State<PetFoodCategoryWidget> createState() => _PetFoodCategoryWidgetState();
// }
//
// class _PetFoodCategoryWidgetState extends State<PetFoodCategoryWidget> {
//
//   @override
//   void initState() {
//     super.initState();
//     Get.find<CategoryController>().getAllUncookedProducts(1, widget.categoryName);
//     Get.find<CategoryController>().getFilUncookedCategoryList("69");
//     Get.find<CategoryController>().getCategoryProductList(
//       "69",
//       Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
//     );
//
//
//     // _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
//     // Get.find<CategoryController>().getSubCategoryList("12");
//     // // scrollController.addListener(() {
//     //   if (Get.find<CategoryController>().categoryProductList != null
//     //       && !Get.find<CategoryController>().isLoading) {
//     //     int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
//     //     if (Get.find<CategoryController>().offset < pageSize) {
//     //       debugPrint('end of the page');
//     //       Get.find<CategoryController>().showBottomLoader();
//     //       Get.find<CategoryController>().getAllUncookedProducts( Get.find<CategoryController>().offset+1, true);
//     //     }
//     //   }
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GetBuilder<CategoryController>(
//       builder: (catController) {
//         return Padding(
//           padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraLarge,
//               horizontal: Dimensions.paddingSizeDefault),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: Dimensions.paddingSizeDefault,),
//               Padding(
//                 padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
//                 child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Nvc Pet Food", style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.black.withOpacity(0.90))),
//                         // Text("Hot and Fresh Food At Your Door", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.80))),
//
//                       ],
//                     ),
//                     // const Spacer(),
//                     ArrowIconButtonWidget(
//                         onTap: () {
//                           Get.toNamed(
//                               RouteHelper.getCookedUnCookedCategoryProductRoute(
//                                 catController.cat![0].id,
//                                 "cooked",
//                               ));
//                         }
//                       //     Get.toNamed(RouteHelper.getUnCookedCategoryProductRoute(
//                       //   1, "uncooked",
//                       // )),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: Dimensions.paddingSizeDefault,),
//
//               // const SizedBox(height: Dimensions.paddingSizeLarge,),
//               ProductViewWidget(
//                 // isCooked: true,
//                 isRestaurant: false,
//                 products: catController.categoryProductList,
//                 restaurants: null,
//                 noDataText: 'no_category_food_found'.tr,
//                 // ategoryBanner: widget.categoryBanner,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
