import 'package:non_veg_city/features/dashboard/domain/services/dashboard_service_interface.dart';

class DashboardService implements DashboardServiceInterface {

  @override
  bool checkDistanceForAddressPopup(double? distance) {
    if(distance! > 1){
      return true;
    }else{
      return false;
    }
  }
}