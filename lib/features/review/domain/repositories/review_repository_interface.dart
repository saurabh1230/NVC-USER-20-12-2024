import 'package:non_veg_city/common/models/product_model.dart';
import 'package:non_veg_city/common/models/response_model.dart';
import 'package:non_veg_city/common/models/review_model.dart';
import 'package:non_veg_city/features/product/domain/models/review_body_model.dart';
import 'package:non_veg_city/interface/repository_interface.dart';

abstract class ReviewRepositoryInterface extends RepositoryInterface {
  @override
  Future<List<Product>?> getList({int? offset, String type});
  Future<ResponseModel> submitReview(ReviewBodyModel reviewBody, bool isProduct);
  Future<List<ReviewModel>?> getRestaurantReviewList(String? restaurantID);
}