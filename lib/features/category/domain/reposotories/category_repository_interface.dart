
import 'package:non_veg_city/common/models/product_model.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/features/category/domain/models/category_model.dart';
import 'package:non_veg_city/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class CategoryRepositoryInterface implements RepositoryInterface {
  Future<List<CategoryModel>?> getSubCategoryList(String? parentID);
  Future<List<CategoryModel>?> getFilCategoryList(String? type);
  Future<List<CategoryModel>?> getFilUncookedCategoryList(String? type);

  Future<ProductModel?> getCategoryProductList(String? categoryID, int offset, String type);
  Future<ProductModel?> getAllProductList(int offset,type);
  Future<ProductModel?> getPopularTypeProducts(int offset,type);
  Future<ProductModel?> getUnCookedAllProductList(int offset,type);

  Future<ProductModel?> getCAllProductList(int offset,type);


  // Future<CookedProductModel?> getCookedCategoryProductList(String? categoryID, int offset, String type);

  Future<ProductModel?> getHomeCategoryProductList(String? categoryID, );
  Future<RestaurantModel?> getCategoryRestaurantList(String? categoryID, int offset, String type);
  Future<RestaurantModel?> getFilterRestaurantList(int offset, String type);
  Future<Response> getSearchData(String? query, String? categoryID, bool isRestaurant, String type);

}