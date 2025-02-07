import 'package:non_veg_city/common/models/product_model.dart';
import 'package:non_veg_city/interface/repository_interface.dart';

abstract class ProductRepositoryInterface implements RepositoryInterface {

  @override
  Future<List<Product>?> getList({int? offset, String? type});
}