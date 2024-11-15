import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor/features/category/domain/reposotories/category_repository_interface.dart';
import 'package:stackfood_multivendor/features/category/domain/services/category_service_interface.dart';
import 'package:get/get_connect/connect.dart';

class CategoryService implements CategoryServiceInterface {
  final CategoryRepositoryInterface categoryRepositoryInterface;

  CategoryService({required this.categoryRepositoryInterface});

  @override
  Future<List<CategoryModel>?> getCategoryList(bool reload, List<CategoryModel>? fetchedCategoryList) async {
    if(fetchedCategoryList == null || reload) {
      return await categoryRepositoryInterface.getList();
    } else {
      return fetchedCategoryList;
    }
  }

  @override
  Future<List<CategoryModel>?> getSubCategoryList(String? parentID) async {
    return await categoryRepositoryInterface.getSubCategoryList(parentID);
  }

  @override
  Future<ProductModel?> getCategoryProductList(String? categoryID, int offset, String type) async {
    return await categoryRepositoryInterface.getCategoryProductList(categoryID, offset, type);
  }

  @override
  Future<RestaurantModel?> getCategoryRestaurantList(String? categoryID, int offset, String type) async {
    return await categoryRepositoryInterface.getCategoryRestaurantList(categoryID, offset, type);
  }

  @override
  Future<RestaurantModel?> getFilterRestaurantList(int offset, String type) async {
    return await categoryRepositoryInterface.getFilterRestaurantList(offset, type);
  }

  @override
  Future<Response> getSearchData(String? query, String? categoryID, bool isRestaurant, String type) async {
    return await categoryRepositoryInterface.getSearchData(query, categoryID, isRestaurant, type);
  }

  @override
  Future<ProductModel?> getAllProductList(int offset,String type) async {
    return await categoryRepositoryInterface.getAllProductList(offset,type);
  }

  @override
  Future<ProductModel?> getPopularTypeProducts(int offset,type) async {
    return await categoryRepositoryInterface.getPopularTypeProducts(offset,type);
  }



  @override
  Future<ProductModel?> getCAllProductList(int offset,type) async {
    return await categoryRepositoryInterface.getCAllProductList(offset,type);
  }

  @override
  Future<ProductModel?> getUnCookedAllProductList(int offset,type) async {
    return await categoryRepositoryInterface.getUnCookedAllProductList(offset,type);
  }

  @override
  Future<List<CategoryModel>?> getFilCategoryList(String? type,List<CategoryModel>? fetchedCategoryList) async {
    return await categoryRepositoryInterface.getFilCategoryList(type);
  }
  @override
  Future<List<CategoryModel>?> getFilUncookedCategoryList(String? type,List<CategoryModel>? fetchedUnCategoryList) async {
    return await categoryRepositoryInterface.getFilUncookedCategoryList(type);
  }



}