import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../product/screens/restaunrant_product_view_widget.dart';

class FavItemViewWidget extends StatelessWidget {
  final bool isRestaurant;
  const FavItemViewWidget({super.key, required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FavouriteController>(builder: (favouriteController) {
        return (favouriteController.wishProductList != null && favouriteController.wishRestList != null) ? RefreshIndicator(
          onRefresh: () async {
            await favouriteController.getFavouriteList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(
              width: Dimensions.webMaxWidth, child:

            isRestaurant == true ?
            RestaurantProductViewWidget(isRestaurantWishlist: isRestaurant,
              isRestaurant: isRestaurant, products: favouriteController.wishProductList, restaurants: favouriteController.wishRestList,
              noDataText: 'no_wish_data_found'.tr,
            ) :

            ProductViewWidget(isRestaurantWishlist: isRestaurant,
                isRestaurant: isRestaurant, products: favouriteController.wishProductList, restaurants: favouriteController.wishRestList,
                noDataText: 'no_wish_data_found'.tr,
              ),
            )),
          ),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
