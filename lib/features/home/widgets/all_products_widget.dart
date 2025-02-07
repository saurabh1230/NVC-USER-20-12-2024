// import 'package:non_veg_city/features/category/controllers/category_controller.dart';
// import 'package:non_veg_city/features/home/widgets/restaurants_view_widget.dart';
// import 'package:non_veg_city/features/restaurant/controllers/restaurant_controller.dart';
// import 'package:non_veg_city/common/widgets/paginated_list_view_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // class AllRestaurantsWidget extends StatelessWidget {
// //   final ScrollController scrollController;
// //   const AllRestaurantsWidget({super.key, required this.scrollController});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GetBuilder<RestaurantController>(builder: (restaurantController) {
// //       return PaginatedListViewWidget(
// //         scrollController: scrollController,
// //         totalSize: restaurantController.restaurantModel?.totalSize,
// //         offset: restaurantController.restaurantModel?.offset,
// //         onPaginate: (int? offset) async => await restaurantController.getRestaurantList(offset!, false),
// //         productView: RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants),
// //       );
// //     });
// //   }
// // }
//
// class AllRestaurantsWidget extends StatelessWidget {
//   final ScrollController scrollController;
//   const AllRestaurantsWidget({super.key, required this.scrollController});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CategoryController>(builder: (categoryControl) {
//       return PaginatedListViewWidget(
//         scrollController: scrollController,
//         totalSize: categoryControl?.totalSize,
//         offset: categoryControl.restaurantModel?.offset,
//         onPaginate: (int? offset) async => await restaurantController.getRestaurantList(offset!, false),
//         productView: RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants),
//       );
//     });
//   }
// }
