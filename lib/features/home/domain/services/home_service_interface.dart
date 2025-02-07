import 'package:non_veg_city/features/home/domain/models/banner_model.dart';

abstract class HomeServiceInterface {
  Future<BannerModel?> getBannerList();
}