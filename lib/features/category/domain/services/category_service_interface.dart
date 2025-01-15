import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:get/get_connect/connect.dart';



abstract class CategoryServiceInterface{
  Future<List<CategoryModel>?> getCategoryList(bool reload, List<CategoryModel>? fetchedCategoryList);
  Future<List<CategoryModel>?> getSubCategoryList(String? parentID);
  Future<List<CategoryModel>?> getFilCategoryList(String? type,List<CategoryModel>? fetchedCategoryList);
  Future<List<CategoryModel>?> getFilUncookedCategoryList(String? type,List<CategoryModel>? fetchedCategoryList);
  Future<ProductModel?> getCategoryProductList(String? categoryID, int offset, String type);
  Future<ProductModel?> getAllProductList(int offset,type);
  Future<ProductModel?> getPopularTypeProducts(int offset,type);
  Future<ProductModel?> getCAllProductList(int offset,type);
  Future<RestaurantModel?> getFilterRestaurantList(int offset, String type);
  Future<ProductModel?> getUnCookedAllProductList(int offset,type);
  Future<RestaurantModel?> getCategoryRestaurantList(String? categoryID, int offset, String type);
  Future<Response> getSearchData(String? query, String? categoryID, bool isRestaurant, String type);





}