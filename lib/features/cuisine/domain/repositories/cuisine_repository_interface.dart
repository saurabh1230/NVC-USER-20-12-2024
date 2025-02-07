import 'package:non_veg_city/features/cuisine/domain/models/cuisine_restaurants_model.dart';
import 'package:non_veg_city/interface/repository_interface.dart';

abstract class CuisineRepositoryInterface extends RepositoryInterface{
  Future<CuisineRestaurantModel?> getRestaurantList(int offset, int cuisineId);
}