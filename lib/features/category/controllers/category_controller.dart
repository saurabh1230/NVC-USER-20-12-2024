import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor/features/category/domain/services/category_service_interface.dart';
import 'package:get/get.dart';


class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});

  String _mainCategoryType = 'cooked';
  String get mainCategoryType => _mainCategoryType;

  void setMainCategoryType(String type) {
    _mainCategoryType = type;
     getAllProductList(1, true,type);
    // getRestaurantList(1, true);
  }

  // void setMainCategoryType(String type) {
  //   _mainCategoryType = type;
  //   getRestaurantList(1, true);
  // }
  // String _restaurantType = 'all';
  // String get restaurantType => _restaurantType;

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? _subCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;

  List<Product>? _categoryProductList;
  List<Product>? get categoryProductList => _categoryProductList;


  // List<CookedProduct>? _cookedCategoryProductList;
  // List<CookedProduct>? get cookedCategoryProductList => _cookedCategoryProductList;

  List<Restaurant>? _categoryRestaurantList;
  List<Restaurant>? get categoryRestaurantList => _categoryRestaurantList;

  List<Product>? _searchProductList = [];
  List<Product>? get searchProductList => _searchProductList;

  List<Restaurant>? _searchRestaurantList = [];
  List<Restaurant>? get searchRestaurantList => _searchRestaurantList;

  // List<bool>? _interestCategorySelectedList;
  // List<bool>? get interestCategorySelectedList => _interestCategorySelectedList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _pageSize;
  int? get pageSize => _pageSize;

  int? _restaurantPageSize;
  int? get restaurantPageSize => _restaurantPageSize;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  int _subCategoryIndex = 0;
  int get subCategoryIndex => _subCategoryIndex;

  String _type = 'all';
  String get type => _type;

  bool _isRestaurant = false;
  bool get isRestaurant => _isRestaurant;

  String? _searchText = '';
  String? get searchText => _searchText;

  int _offset = 1;
  int get offset => _offset;

  // String? _restResultText = '';
  // String? _foodResultText = '';


  Future<void> getCategoryList(bool reload) async {
    _categoryProductList = null;
    if(_categoryList == null || reload) {
      _categoryList = await categoryServiceInterface.getCategoryList(reload, _categoryList);
      // _interestCategorySelectedList = categoryServiceInterface.processCategorySelectedList(_categoryList);
      update();
    }
  }
  // Future<void> getCookedCategoryList(bool reload) async {
  //   if(_categoryList == null || reload) {
  //     _categoryList = await categoryServiceInterface.getCookedCategoryList(reload, _categoryList);
  //     // _interestCategorySelectedList = categoryServiceInterface.processCategorySelectedList(_categoryList);
  //     update();
  //   }
  // }

  void getSubCategoryList(String? categoryID) async {
    _subCategoryIndex = 0;
    _subCategoryList = null;
    _categoryProductList = null;

    // _cookedCategoryProductList =null;
    _isRestaurant = false;
    _subCategoryList = await categoryServiceInterface.getSubCategoryList(categoryID);
    // if(_subCategoryList != null) {
    //   getCategoryProductList(categoryID, 1, 'all', false);
    // }
  }

  void setSubCategoryIndex(int index, String? categoryID) {
    _subCategoryIndex = index;
    if(_isRestaurant) {
      getCategoryRestaurantList(_subCategoryIndex == 0 ? categoryID : _subCategoryList![index].id.toString(), 1, _type, true);
    }else {
      getCategoryProductList(_subCategoryIndex == 0 ? categoryID : _subCategoryList![index].id.toString(), 1, _type, true);
    }
  }

  void getCategoryProductList(String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      if(_type == type) {
        _isSearching = false;
      }
      _type = type;
      if(notify) {
        update();
      }
      _categoryProductList = null;
      // _cookedCategoryProductList = null;
    }
    ProductModel? productModel = await categoryServiceInterface.getCategoryProductList(categoryID, offset, type);
    // CookedProductModel? categoryProductModel = await categoryServiceInterface.getCookedCategoryProductList(categoryID, offset, type);
    // CookedProductModel? categoryProductModel = await categoryServiceInterface.getCookedCategoryProductList(categoryID, offset, type);
    if(productModel != null) {
      if (offset == 1) {
        _categoryProductList = [];
        // _cookedCategoryProductList = [];
      }
      _categoryProductList!.addAll(productModel.products!);
      // _cookedCategoryProductList!.addAll(categoryProductModel!.cookedproducts!);
      _pageSize = productModel.totalSize;
      _isLoading = false;
    }
    update();
  }

  void getUncookedProducts(int offset, String type, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      if(_type == type) {
        _isSearching = false;
      }
      _type = type;
      if(notify) {
        update();
      }
      _categoryProductList = null;
      // _cookedCategoryProductList = null;
    }
    ProductModel? productModel = await categoryServiceInterface.getUnCookedAllProductList(offset, type);
    // CookedProductModel? categoryProductModel = await categoryServiceInterface.getCookedCategoryProductList(categoryID, offset, type);
    // CookedProductModel? categoryProductModel = await categoryServiceInterface.getCookedCategoryProductList(categoryID, offset, type);
    if(productModel != null) {
      if (offset == 1) {
        _categoryProductList = [];
        // _cookedCategoryProductList = [];
      }
      _categoryProductList!.addAll(productModel.products!);
      // _cookedCategoryProductList!.addAll(categoryProductModel!.cookedproducts!);
      _pageSize = productModel.totalSize;
      _isLoading = false;
    }
    update();
  }

  ProductModel? _productModel;
  ProductModel? get productModel => _productModel;

  Future<void> getAllProductList(int offset, bool reload,type ) async {
    if(reload) {
      _productModel = null;
      update();
    }
    ProductModel? productModel = await categoryServiceInterface.getAllProductList(offset,type);
    if (productModel != null) {
      if (offset == 1) {
        _productModel = productModel;
      }else {
        _productModel!.totalSize = productModel.totalSize;
        _productModel!.offset = productModel.offset;
        _productModel!.products!.addAll(productModel.products!);
      }
      update();
    }
  }

  List<Product>? _allProductList;
  List<Product>? get allProductList => _allProductList;

  // Future<void>  getAllProductList(int offset, bool notify) async {
  //   _offset = offset;
  //   if(offset == 1) {
  //     _allProductList = null;
  //   }
  //   ProductModel? productModel = await categoryServiceInterface.getAllProductList(offset);
  //   // CookedProductModel? categoryProductModel = await categoryServiceInterface.getCookedCategoryProductList(categoryID, offset, type);
  //   // CookedProductModel? categoryProductModel = await categoryServiceInterface.getCookedCategoryProductList(categoryID, offset, type);
  //   if(productModel != null) {
  //     if (offset == 1) {
  //       _allProductList = [];
  //       // _cookedCategoryProductList = [];
  //     }
  //     _allProductList!.addAll(productModel.products!);
  //     print("CHECK LENGHT ============>>>>>>>>>>");
  //     print(_allProductList!.length);
  //     // _cookedCategoryProductList!.addAll(categoryProductModel!.cookedproducts!);
  //     _pageSize = productModel.totalSize;
  //     _isLoading = false;
  //   }
  //   update();
  // }

  /*void getCookedCategoryProductList(String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      if(_type == type) {
        _isSearching = false;
      }
      _type = type;
      if(notify) {
        update();
      }
      _cookedCategoryProductList = null;
      // _cookedCategoryProductList = null;
    }
    ProductModel? productModel = await categoryServiceInterface.getCookedCategoryProductList(categoryID, offset, type);
    if(productModel != null) {
      if (offset == 1) {
        _cookedCategoryProductList = [];
        // _cookedCategoryProductList = [];
      }
      _cookedCategoryProductList!.addAll(productModel.products!);
      // _cookedCategoryProductList!.addAll(productModel.products!);
      _pageSize = productModel.totalSize;
      _isLoading = false;
    }
    update();
  }
*/




  //
  // void getCookedCategoryList(String? categoryID) async {
  //   _subCategoryIndex = 0;
  //   _subCategoryList = null;
  //   _cookedCategoryProductList = null;
  //   _isRestaurant = false;
  //   _subCategoryList = await categoryServiceInterface.getSubCategoryList(categoryID);
  //   if(_subCategoryList != null) {
  //     getCookedCategoryProductList(categoryID, 1, 'all', false);
  //   }
  // }


  // void getCookedCategoryProductList(String? categoryID, int offset, String type, bool notify) async {
  //   _offset = offset;
  //   if(offset == 1) {
  //     if(_type == type) {
  //       _isSearching = false;
  //     }
  //     _type = type;
  //     if(notify) {
  //       update();
  //     }
  //     _cookedCategoryProductList = null;
  //   }
  //   ProductModel? productModel = await categoryServiceInterface.getCookedCategoryProductList("7", offset, type);
  //   if(productModel != null) {
  //     if (offset == 1) {
  //       _cookedCategoryProductList = [];
  //     }
  //     _cookedCategoryProductList!.addAll(productModel.products!);
  //     _pageSize = productModel.totalSize;
  //     _isLoading = false;
  //   }
  //   update();
  // }


  // void getHomeCategoryList(String? categoryID) async {
  //   // _offset = offset;
  //   // if(offset == 1) {
  //   //   if(_type == type) {
  //   //     _isSearching = false;
  //   //   }
  //   //   _type = type;
  //   //   if(notify) {
  //   //     update();
  //   //   }
  //   //   _categoryProductList = null;
  //   // }
  //   ProductModel? productModel = await categoryServiceInterface.getHomeCategoryProductList(categoryID,);
  //   if(productModel != null) {
  //     if (offset == 1) {
  //       _categoryProductList = [];
  //     }
  //     _categoryProductList!.addAll(productModel.products!);
  //     // _pageSize = productModel.totalSize;
  //     _isLoading = false;
  //   }
  //   update();
  // }

  void getCategoryRestaurantList(String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      if(_type == type) {
        _isSearching = false;
      }
      _type = type;
      if(notify) {
        update();
      }
      _categoryRestaurantList = null;
    }
    RestaurantModel? restaurantModel = await categoryServiceInterface.getCategoryRestaurantList(categoryID, offset, type);
    if(restaurantModel != null) {
      if (offset == 1) {
        _categoryRestaurantList = [];
      }
      _categoryRestaurantList!.addAll(restaurantModel.restaurants!);
      _restaurantPageSize = restaurantModel.totalSize;
      _isLoading = false;
    }
    update();
  }

  void getFilterRestaurantList( int offset, String type, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      if(_type == type) {
        _isSearching = false;
      }
      _type = type;
      if(notify) {
        update();
      }
      _categoryRestaurantList = null;
    }
    RestaurantModel? restaurantModel = await categoryServiceInterface.getFilterRestaurantList(offset, type);
    if(restaurantModel != null) {
      if (offset == 1) {
        _categoryRestaurantList = [];
      }
      _categoryRestaurantList!.addAll(restaurantModel.restaurants!);
      _restaurantPageSize = restaurantModel.totalSize;
      _isLoading = false;
    }
    update();
  }

  void searchData(String? query, String? categoryID, String type) async {
    if((_isRestaurant && query!.isNotEmpty /*&& query != _restResultText*/) || (!_isRestaurant && query!.isNotEmpty/* && query != _foodResultText*/)) {
      _searchText = query;
      _type = type;
      if (_isRestaurant) {
        _searchRestaurantList = null;
      } else {
        _searchProductList = null;
      }
      _isSearching = true;
      update();

      Response response = await categoryServiceInterface.getSearchData(query, categoryID, _isRestaurant, type);
      if (response.statusCode == 200) {
        if (query.isEmpty) {
          if (_isRestaurant) {
            _searchRestaurantList = [];
          } else {
            _searchProductList = [];
          }
        } else {
          if (_isRestaurant) {
            // _restResultText = query;
            _searchRestaurantList = [];
            _searchRestaurantList!.addAll(RestaurantModel.fromJson(response.body).restaurants!);
          } else {
            // _foodResultText = query;
            _searchProductList = [];
            _searchProductList!.addAll(ProductModel.fromJson(response.body).products!);
          }
        }
      }
      update();
    }
  }




  void toggleSearch() {
    _isSearching = !_isSearching;
    _searchProductList = [];
    if(_categoryProductList != null) {
      _searchProductList!.addAll(_categoryProductList!);
    }
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  // Future<bool> saveInterest(List<int?> interests) async {
  //   _isLoading = true;
  //   update();
  //   bool isSuccess = await categoryServiceInterface.saveUserInterests(interests);
  //   _isLoading = false;
  //   update();
  //   return isSuccess;
  // }

  // void addInterestSelection(int index) {
  //   _interestCategorySelectedList![index] = !_interestCategorySelectedList![index];
  //   update();
  // }

  void setRestaurant(bool isRestaurant) {
    _isRestaurant = isRestaurant;
    update();
  }

  // List<Category>? categoryList;
  int? selectedCategoryId;

  void selectCategory(int categoryId) {
    selectedCategoryId = categoryId;
    update();
  }

  ProductModel? _cookedList;
  ProductModel? get cookedList => _cookedList;
  Future<void> getCookedProductList(int offset, bool reload,type) async {
    if(reload) {
      _cookedList = null;
      update();
    }
    ProductModel? productModel = await categoryServiceInterface.getCAllProductList(offset,type);
    if (productModel != null) {
      if (offset == 1) {
        _cookedList = productModel;
      }else {
        _cookedList!.totalSize = productModel.totalSize;
        _cookedList!.offset = productModel.offset;
        _cookedList!.products!.addAll(productModel.products!);
      }
      update();
    }
  }

  ProductModel? _uncookedList;
  ProductModel? get uncooked => _uncookedList;
  Future<void> getUnCookedProductList(int offset, bool reload,type) async {

    if(reload) {
      _uncookedList = null;
      update();
    }
    ProductModel? productModel = await categoryServiceInterface.getUnCookedAllProductList(offset,type);
    if (productModel != null) {
      if (offset == 1) {
        _uncookedList = productModel;
      }else {

        _uncookedList!.totalSize = productModel.totalSize;
        _uncookedList!.offset = productModel.offset;
        _uncookedList!.products!.addAll(productModel.products!);
      }
      update();
    }
  }

  int? selectedCookedCategoryId;

  void selectCookedCategory(int categoryCookedId) {
    selectedCookedCategoryId = categoryCookedId;
    update();
  }

  int? selectedUnCookedCategoryId;

  void selectUncookedCategory(int categoryUncookedId) {
    selectedUnCookedCategoryId = categoryUncookedId;
    update();
  }


  List<CategoryModel>? _cat;
  List<CategoryModel>? get cat => _cat;
  void getFilCategoryList(String? type) async {
    selectedCookedCategoryId = null;
    // update();
    _subCategoryIndex = 0;
    _cat = null;
    _categoryProductList = null;

    // // _cookedCategoryProductList =null;
    // _isRestaurant = false;
    _cat = await categoryServiceInterface.getFilCategoryList(type,_cat);

    update();
    // if(_subCategoryList != null) {
    //   getCategoryProductList(categoryID, 1, 'all', false);
    // }
  }

  List<CategoryModel>? _unCookedCat;
  List<CategoryModel>? get unCookedCat => _unCookedCat;
  void getFilUncookedCategoryList(String? type) async {
    selectedUnCookedCategoryId = null;
    // _subCategoryIndex = 0;
    _unCookedCat = null;
    _categoryProductList = null;
    // _cookedCategoryProductList =null;
    // _isRestaurant = false;
    _unCookedCat = await categoryServiceInterface.getFilUncookedCategoryList(type,_unCookedCat);
    // Get.find<CategoryController>().getSubCategoryList(_unCookedCat![0].id.toString());
    update();
    // if(_subCategoryList != null) {
    //   getCategoryProductList(categoryID, 1, 'all', false);
    // }
  }







}
