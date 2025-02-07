import 'package:non_veg_city/common/models/product_model.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/features/category/domain/models/category_model.dart';
import 'package:non_veg_city/features/category/domain/services/category_service_interface.dart';
import 'package:get/get.dart';



class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});


  String _mainCategoryType = '';
  String get mainCategoryType => _mainCategoryType;

  void setMainCategoryType(String type) {
    _mainCategoryType = type;
    getAllProductList(1, true,type);
    // getRestaurantList(1, true);
  }

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? _subCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;

  List<Product>? _categoryProductList;
  List<Product>? get categoryProductList => _categoryProductList;




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
    // _subCategoryList = null;
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
    if(_subCategoryList != null) {
      getCategoryProductList(categoryID, 1, 'all', false);
    }
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
    _unCookedCat = null;
    _categoryProductList = null;
    _unCookedCat = await categoryServiceInterface.getFilUncookedCategoryList(type,_unCookedCat);
    update();
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
    }
    ProductModel? productModel = await categoryServiceInterface.getCategoryProductList(categoryID, offset, type);
    if(productModel != null) {
      if (offset == 1) {
        _categoryProductList = [];
      }
      _categoryProductList!.addAll(productModel.products!);
      _pageSize = productModel.totalSize;
      _isLoading = false;
    }
    update();
  }



  List<Product>? _muttonCategoryList;
  List<Product>? get muttonCategoryList => _muttonCategoryList;

  void getMuttonCategoryProductList(String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
      if (offset == 1) {
      if (_type == type) {
        _isSearching = false;
      }
      _type = type;
      if (notify) {
        update();
      }
      _muttonCategoryList = null;
    }
    ProductModel? productModel = await categoryServiceInterface.getCategoryProductList(categoryID, offset, type);
    if (productModel != null) {
      if (offset == 1) {
        _muttonCategoryList = [];
      }
      _muttonCategoryList!.addAll(productModel.products!);
      _pageSize = productModel.totalSize;
      _isLoading = false;
    }
    update();
  }

  List<Product>? _petFoodList;
  List<Product>? get petFoodList => _petFoodList;

  void getPetFoodProductList(String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if (offset == 1) {
      if (_type == type) {
        _isSearching = false;
      }
      _type = type;
      if (notify) {
        update();
      }
      _petFoodList = null;
    }
    ProductModel? productModel = await categoryServiceInterface.getCategoryProductList(categoryID, offset, type);
    if (productModel != null) {
      if (offset == 1) {
        _petFoodList = [];
      }
      _petFoodList!.addAll(productModel.products!);
      _pageSize = productModel.totalSize;
      _isLoading = false;
    }
    update();
  }


  ProductModel? _productModel;
  ProductModel? get productModel => _productModel;

  Future<void> getAllProductList(int offset, bool reload,type) async {
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


  List<Product>? _uncookedModel;
  List<Product>? get uncookedModel => _uncookedModel;
  Future<void>  getAllUncookedProducts(int offset, type) async {
    print('type====> ${type}');
    _offset = offset;
    if(offset == 1) {
      _uncookedModel = null;
    }
    ProductModel? productModel = await categoryServiceInterface.getAllProductList(1,type);
    if(productModel != null) {
      if (offset == 1) {
        _uncookedModel = [];
      }
      _uncookedModel!.addAll(productModel.products!);
      _pageSize = productModel.totalSize;
      _isLoading = false;
    }
    update();
  }

  List<Product>? _cookedModel;
  List<Product>? get cookedModel => _cookedModel;
  Future<void>  getAllCookedProducts(int offset, type) async {
    _offset = offset;
    if(offset == 1) {
      _cookedModel = null;
    }
    ProductModel? productModel = await categoryServiceInterface.getAllProductList(1,type);
    if(productModel != null) {
      if (offset == 1) {
        _cookedModel = [];
      }
      _cookedModel!.addAll(productModel.products!);
      print("CHECK LENGHT ============>>>>>>>>>>");
      print(_cookedModel!.length);
      _pageSize = productModel.totalSize;
      _isLoading = false;
    }
    update();
  }













  Future<void> getCookedProductList(int offset, bool reload,type) async {
    if(reload) {
      _productModel = null;
    }
    ProductModel? productModel = await categoryServiceInterface.getCAllProductList(offset,type);
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

  /// --------------------------------------------------------------------------

  List<Restaurant>? _uncookedRestaurantList;
  List<Restaurant>? get uncookedRestaurantList => _uncookedRestaurantList;


  int? _unCookedPageSize;
  int? get unCookedPageSize => _unCookedPageSize;
  int? _uncookedoffSet;
  int? get uncookedoffSet => _uncookedoffSet;





  void getUncookedRestaurantList( int offset, String type, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      if(_type == type) {
        _isSearching = false;
      }
      _type = type;
      if(notify) {
        update();
      }
      _uncookedRestaurantList = null;
    }
    RestaurantModel? restaurantModel = await categoryServiceInterface.getFilterRestaurantList(offset, type);
    if(restaurantModel != null) {
      if (offset == 1) {
        _uncookedRestaurantList = restaurantModel.restaurants;
      } else {
        uncookedRestaurantList!.addAll(restaurantModel.restaurants!);
        _unCookedPageSize = restaurantModel.totalSize;
        _uncookedoffSet = restaurantModel.offset;
      }
    }
    _isLoading = false;
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




  int? selectedCategoryId;

  void selectCategory(int categoryId) {
    selectedCategoryId = categoryId;
    update();
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


  void getFilterRestaurantList( int offset, String type, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      if(_type == type) {
        _isSearching = false;
      }
      _type = type;
      if (notify) {
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



  void clearSubCategoryList() {
    selectedCookedCategoryId = null;
    _subCategoryList = null;
    _subCategoryIndex = 0;
    _categoryProductList = null;
    _isRestaurant = false;
    _categoryRestaurantList = null;
    // update(); // call update to notify listeners
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
    }
    ProductModel? productModel = await categoryServiceInterface.getUnCookedAllProductList(offset, type);
    if(productModel != null) {
      if (offset == 1) {
        _categoryProductList = [];
      }
      _categoryProductList!.addAll(productModel.products!);
      _pageSize = productModel.totalSize;
      _isLoading = false;
    }
    update();
  }


  String _categoryName = '';
  String _categoryId = '';

  String get categoryName => _categoryName;
  String get categoryId => _categoryId;

  set categoryName(String name) {
    _categoryName = name;
    update();
  }

  set categoryId(String id) {
    _categoryId = id;
    update();
  }


  ProductModel? _uncookedProducts;
  ProductModel? get uncookedProducts => _uncookedProducts;

  Future<void> getPopularUncookedTypeProducts(int offset, bool reload,type) async {
    if(reload) {
      _uncookedProducts = null;
      update();
    }
    ProductModel? productModel = await categoryServiceInterface.getPopularTypeProducts(offset,type);
    if (productModel != null) {
      if (offset == 1) {
        _uncookedProducts = productModel;
      }else {
        _uncookedProducts!.totalSize = productModel.totalSize;
        _uncookedProducts!.offset = productModel.offset;
        _uncookedProducts!.products!.addAll(productModel.products!);
      }
      update();
    }
  }

  ProductModel? _cookedProducts;
  ProductModel? get cookedProducts => _cookedProducts;

  Future<void> getPopularCookedTypeProducts(int offset, bool reload,type) async {
    if(reload) {
      _cookedProducts = null;
      update();
    }
    ProductModel? productModel = await categoryServiceInterface.getPopularTypeProducts(offset,type);
    if (productModel != null) {
      if (offset == 1) {
        _cookedProducts = productModel;
      } else {
        _cookedProducts!.totalSize = productModel.totalSize;
        _cookedProducts!.offset = productModel.offset;
        _cookedProducts!.products!.addAll(productModel.products!);
      }
      update();
    }
  }
}