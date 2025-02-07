import 'package:non_veg_city/features/onboard/domain/models/onboarding_model.dart';
import 'package:non_veg_city/features/onboard/domain/repository/onboard_repository_interface.dart';
import 'package:non_veg_city/features/onboard/domain/service/onboard_service_interface.dart';

class OnboardService implements OnboardServiceInterface {
  final OnboardRepositoryInterface onboardRepositoryInterface;
  OnboardService({required this.onboardRepositoryInterface});

  @override
  Future<List<OnBoardingModel>> getOnBoardingList() async {
    return await onboardRepositoryInterface.getList();
  }
}