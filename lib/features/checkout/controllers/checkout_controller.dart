import 'package:country_code_picker/country_code_picker.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/address/widgets/address_card_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/offline_method_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/timeslote_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/services/checkout_service_interface.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/order_successfull_dialog_widget.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/partial_pay_dialog.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/loyalty/controllers/loyalty_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dropdown_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;
import 'dart:convert';
class CheckoutController extends GetxController implements GetxService {
  final CheckoutServiceInterface checkoutServiceInterface;
  CheckoutController({required this.checkoutServiceInterface});

  List<DropdownItem<int>> _addressList = [];
  List<DropdownItem<int>> get addressList => _addressList;

  List<AddressModel> _address = [];
  List<AddressModel> get address => _address;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  String _preferableTime = '';
  String get preferableTime => _preferableTime;

  List<OfflineMethodModel>? _offlineMethodList;
  List<OfflineMethodModel>? get offlineMethodList => _offlineMethodList;

  int _selectedOfflineBankIndex = 0;
  int get selectedOfflineBankIndex => _selectedOfflineBankIndex;

  bool _isPartialPay = false;
  bool get isPartialPay => _isPartialPay;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _selectedTips = 0;
  int get selectedTips => _selectedTips;

  double _tips = 0.0;
  double get tips => _tips;

  final TextEditingController couponController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController tipController = TextEditingController(text: '0');
  final TextEditingController streetNumberController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final FocusNode streetNode = FocusNode();
  final FocusNode houseNode = FocusNode();
  final FocusNode floorNode = FocusNode();

  bool _customDateRestaurantClose = false;
  bool get customDateRestaurantClose => _customDateRestaurantClose;

  DateTime? _selectedCustomDate;
  DateTime? get selectedCustomDate => _selectedCustomDate;

  int? _mostDmTipAmount;
  int? get mostDmTipAmount => _mostDmTipAmount;

  String _orderType = 'delivery';
  String get orderType => _orderType;

  bool _subscriptionOrder = false;
  bool get subscriptionOrder => _subscriptionOrder;

  DateTimeRange? _subscriptionRange;
  DateTimeRange? get subscriptionRange => _subscriptionRange;

  String? _subscriptionType = 'daily';
  String? get subscriptionType => _subscriptionType;

  int _subscriptionTypeIndex = 0;
  int get subscriptionTypeIndex => _subscriptionTypeIndex;

  List<DateTime?> _selectedDays = [null];
  List<DateTime?> get selectedDays => _selectedDays;

  double? _distance;
  double? get distance => _distance;

  double? _extraCharge;
  double? get extraCharge => _extraCharge;

  double _viewTotalPrice = 0;
  double? get viewTotalPrice => _viewTotalPrice;

  int _paymentMethodIndex = -1;
  int get paymentMethodIndex => _paymentMethodIndex;

  List<TextEditingController> informationControllerList = [];
  // List<TextEditingController> get informationControllerList => _informationControllerList;

  List<FocusNode> informationFocusList = [];
  // List<FocusNode> get informationFocusList => _informationFocusList;

  List<TimeSlotModel>? _timeSlots;
  List<TimeSlotModel>? get timeSlots => _timeSlots;

  List<TimeSlotModel>? _allTimeSlots;
  List<TimeSlotModel>? get allTimeSlots => _allTimeSlots;

  List<int>? _slotIndexList;
  List<int>? get slotIndexList => _slotIndexList;

  int _selectedDateSlot = 0;
  int get selectedDateSlot => _selectedDateSlot;

  int? _selectedTimeSlot = 0;
  int? get selectedTimeSlot => _selectedTimeSlot;

  AddressModel? _guestAddress;
  AddressModel? get guestAddress => _guestAddress;

  int _addressIndex = 0;
  int get addressIndex => _addressIndex;

  bool _isDmTipSave = false;
  bool get isDmTipSave => _isDmTipSave;

  String? _digitalPaymentName;
  String? get digitalPaymentName => _digitalPaymentName;

  String? countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
      : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode ?? Get.find<LocalizationController>().locale.countryCode;

  int _selectedInstruction = -1;
  int get selectedInstruction => _selectedInstruction;

  bool _canShowTimeSlot = false;
  bool get canShowTimeSlot => _canShowTimeSlot;

  bool _canShowTipsField = false;
  bool get canShowTipsField => _canShowTipsField;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  bool _isLoadingUpdate = false;
  bool get isLoadingUpdate => _isLoadingUpdate;

  void showTipsField(){
    _canShowTipsField = !_canShowTipsField;
    update();
  }

  void showHideTimeSlot(){
    _canShowTimeSlot = !_canShowTimeSlot;
    update();
  }

  void setInstruction(int index){
    _selectedInstruction = checkoutServiceInterface.selectInstruction(index, _selectedInstruction);
    update();
  }

  void setAddressIndex(int index, {bool canUpdate = true} ) {
    _addressIndex = index;
    if(canUpdate) {
      update();
    }
  }

  void setDateCloseRestaurant(bool status) {
    _customDateRestaurantClose = status;
    update();
  }

  void changeDigitalPaymentName(String name){
    _digitalPaymentName = name;
    update();
  }

  void _setGuestAddress(AddressModel? address) {
    _guestAddress = address;
    update();
  }

  Future<bool> saveOfflineInfo(String data) async {
    _isLoading = true;
    update();
    bool success = await checkoutServiceInterface.saveOfflineInfo(data);
    if (success) {
      _isLoading = false;
      _guestAddress = null;
    }
    update();
    return success;
  }

  void setGuestAddress(AddressModel? address) {
    _guestAddress = address;
    update();
  }

  void expandedUpdate(bool status){
    _isExpanded = status;
    update();
  }

  void setPaymentMethod(int index, {bool isUpdate = true}) {
    _paymentMethodIndex = index;
    if(isUpdate) {
      update();
    }
  }

  void selectOfflineBank(int index){
    _selectedOfflineBankIndex = index;
    update();
  }

  void changesMethod() {
    List<MethodInformations>? methodInformation = offlineMethodList![selectedOfflineBankIndex].methodInformations!;

    informationControllerList = checkoutServiceInterface.generateTextControllerList(methodInformation);
    informationFocusList = checkoutServiceInterface.generateFocusList(methodInformation);

    update();
  }

  Future<double?> getExtraCharge(double? distance) async {
    _extraCharge = await checkoutServiceInterface.getExtraCharge(distance);
    return _extraCharge;
  }

  void setTotalAmount(double amount){
    _viewTotalPrice = amount;
  }

  Future<void> setRestaurantDetails({int? restaurantId}) async {
    if(Get.find<RestaurantController>().restaurant == null) {
      await Get.find<RestaurantController>().getRestaurantDetails(Restaurant(id: restaurantId));
    }
    _restaurant = Get.find<RestaurantController>().restaurant;
    Future.delayed(const Duration(milliseconds: 600), () => update());
  }

  Future<void> initCheckoutData(int? restaurantID) async {
    Get.find<CouponController>().removeCouponData(false);
    clearPrevData();
    await Get.find<RestaurantController>().getRestaurantDetails(Restaurant(id: restaurantID));
    initializeTimeSlot(Get.find<RestaurantController>().restaurant!);
    insertAddresses(Get.context!, null);
  }

  bool isRestaurantClosed(DateTime dateTime, bool active, List<Schedules>? schedules, {int? customDateDuration}) {
    return Get.find<RestaurantController>().isRestaurantClosed(dateTime, active, schedules);
  }

  Future<void> getDmTipMostTapped() async {
    _mostDmTipAmount = await checkoutServiceInterface.getDmTipMostTapped();
    update();
  }

  void setPreferenceTimeForView(String time, bool instanceOrder, {bool isUpdate = true}){
    _preferableTime = checkoutServiceInterface.setPreferenceTimeForView(time, instanceOrder);
    if(isUpdate) {
      update();
    }
  }

  void setCustomDate(DateTime? date, bool instanceOrder, {bool canUpdate = true}) {
    _selectedCustomDate = date;
    _selectedTimeSlot = checkoutServiceInterface.selectTimeSlot(instanceOrder);

    if(canUpdate) {
      update();
    }
  }

  Future<void> getOfflineMethodList() async {
    _offlineMethodList = await checkoutServiceInterface.getOfflineMethodList();
    update();
  }

  void changePartialPayment({bool isUpdate = true}){
    _isPartialPay = !_isPartialPay;
    if(isUpdate) {
      update();
    }
  }

  void stopLoader({bool isUpdate = true}) {
    _isLoading = false;
    if(isUpdate) {
      update();
    }
  }

  void updateTimeSlot(int? index, bool instanceOrder, {bool notify = true}) {
    if(!instanceOrder) {
      if(index == 0) {
        if(notify) {
          showCustomSnackBar('instance_order_is_not_active'.tr, showToaster: true);
        }
      } else {
        _selectedTimeSlot = index;
      }
    } else {
      _selectedTimeSlot = index;
    }
    if(notify) {
      update();
    }
  }

  void updateTips(int index, {bool notify = true}) {
    _selectedTips = index;
    _tips = checkoutServiceInterface.updateTips(index, _selectedTips);

    if(notify) {
      update();
    }
  }

  Future<void> addTips(double tips, {bool notify = true}) async {
    _tips = tips;
    if(notify) {
      update();
    }
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if(notify) {
      update();
    }
  }

  void setSubscription(bool isSubscribed) {
    _subscriptionOrder = isSubscribed;
    _orderType = 'delivery';
    update();
  }

  void setSubscriptionRange(DateTimeRange range) {
    _subscriptionRange = range;
    update();
  }

  void setSubscriptionType(String? type, int index) {
    _subscriptionType = type;
    _selectedDays = [];
    for(int index=0; index < (type == 'weekly' ? 7 : type == 'monthly' ? 31 : 1); index++) {
      _selectedDays.add(null);
    }
    _subscriptionTypeIndex = index;
    update();
  }

  void addDay(int index, TimeOfDay? time) {
    if(time != null) {
      _selectedDays[index] = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, time.hour, time.minute);
    }else {
      _selectedDays[index] = null;
    }
    update();
  }

  Future<bool> checkBalanceStatus(double totalPrice, {double discount = 0, double extraCharge = 0}) async {
    totalPrice = (totalPrice - discount) + extraCharge;
    if(isPartialPay){
      changePartialPayment();
    }
    setPaymentMethod(-1);
    debugPrint('--total : $totalPrice , compare balance : ${Get.find<ProfileController>().userInfoModel!.walletBalance! < totalPrice}');
    if((Get.find<ProfileController>().userInfoModel!.walletBalance! < totalPrice) && (Get.find<ProfileController>().userInfoModel!.walletBalance! != 0.0)){
      Get.dialog(PartialPayDialog(isPartialPay: true, totalPrice: totalPrice), useSafeArea: false,);
    }else{
      Get.dialog(PartialPayDialog(isPartialPay: false, totalPrice: totalPrice), useSafeArea: false,);
    }

    update();
    return true;
  }

  void insertAddresses(BuildContext context, AddressModel? addressModel, {bool notify = false}) {
    _addressList = [];
    _address = [];

    _addressList.add(
        DropdownItem<int>(value: -1, child: SizedBox(
          width: context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth-50 : context.width-50,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(children: [
              const Expanded(child: SizedBox()),
              Text(
                'add_new_address'.tr,
                style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Icon(Icons.add_circle_outline_sharp, size: 20, color: Theme.of(context).primaryColor)
            ]),
          ),
        ))
    );

    _address.add(AddressHelper.getAddressFromSharedPref()!);
    _addressList.add(
        DropdownItem<int>(value: 0, child: SizedBox(
          width: context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth-50 : context.width-50,
          child: AddressCardWidget(
            address: AddressHelper.getAddressFromSharedPref(),
            fromAddress: false, fromCheckout: true,
          ),
        ))
    );

    if(Get.find<RestaurantController>().restaurant != null) {
      if(Get.find<AddressController>().addressList != null) {
        int i = 0;
        for(int index=0; index<Get.find<AddressController>().addressList!.length; index++) {
          if(Get.find<AddressController>().addressList![index].zoneIds!.contains(Get.find<RestaurantController>().restaurant!.zoneId)) {

            _address.add(Get.find<AddressController>().addressList![index]);
            _addressList.add(DropdownItem<int>(value: i + 1, child: SizedBox(
              width: context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth-50 : context.width-50,
              child: AddressCardWidget(
                address: Get.find<AddressController>().addressList![index],
                fromAddress: false, fromCheckout: true,
              ),
            )));
            i++;
          }
        }

      }

      if(addressModel != null) {
        _address.add(addressModel);
        _addressList.add(DropdownItem<int>(value: _address.length- 1, child: SizedBox(
          width: context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth-50 : context.width-50,
          child: AddressCardWidget(
            address: addressModel,
            fromAddress: false, fromCheckout: true,
          ),
        )));
        setAddressIndex(_address.length- 1);
      }

      _addressList.add(
          DropdownItem<int>(value: -2, child: SizedBox(
            width: context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth-50 : context.width-50,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Row(children: [
                const Expanded(child: SizedBox()),

                Icon(Icons.my_location_sharp, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Text(
                  'use_my_current_location'.tr,
                  style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                ),
                const Expanded(child: SizedBox()),

              ]),
            ),
          ))
      );
    }
    if(notify) {
      update();
    }
  }

  Future<void> initializeTimeSlot(Restaurant restaurant) async {
    _timeSlots = await checkoutServiceInterface.initializeTimeSlot(restaurant, Get.find<SplashController>().configModel!.scheduleOrderSlotDuration);
    _allTimeSlots = await checkoutServiceInterface.initializeTimeSlot(restaurant, Get.find<SplashController>().configModel!.scheduleOrderSlotDuration);

    _validateSlot(_allTimeSlots!, DateTime.now(), notify: false);
  }

  void updateDateSlot(int index, DateTime date, bool instanceOrder, {bool fromCustomDate = false}) {
    if(!fromCustomDate) {
      _selectedDateSlot = index;
    }
    if(instanceOrder) {
      _selectedTimeSlot = 0;
    } else {
      _selectedTimeSlot = 1;
    }
    if(_allTimeSlots != null) {
      _validateSlot(_allTimeSlots!, date);
    }
    update();
  }

  void _validateSlot(List<TimeSlotModel> slots, DateTime date, {bool notify = true}) {
    _timeSlots = checkoutServiceInterface.validateTimeSlot(slots, date);
    _slotIndexList = checkoutServiceInterface.validateSlotIndexes(slots, date);

    if(notify) {
      update();
    }
  }

  Future<double?> getDistanceInKM(LatLng originLatLng, LatLng destinationLatLng, {bool isDuration = false, bool isRiding = false, bool fromDashboard = false}) async {
    _distance = await checkoutServiceInterface.getDistanceInKM(originLatLng, destinationLatLng, isDuration: isDuration);

    if(!fromDashboard) {
      await getExtraCharge(_distance);
    }

    update();
    return _distance;
  }

  Future<String> placeOrder(PlaceOrderBodyModel placeOrderBody, int? zoneID, double amount, double? maximumCodOrderAmount, bool fromCart,
      bool isCashOnDeliveryActive, {bool isOfflinePay = false}) async {
    _isLoading = true;
    update();

    // Print the entire body
    print('Request couponDiscountAmount: ${placeOrderBody.couponDiscountAmount}');
    print('Request couponDiscountTitle: ${placeOrderBody.couponDiscountTitle}');
    print('Request orderAmount: ${placeOrderBody.orderAmount}');
    print('Request orderType: ${placeOrderBody.orderType}');
    print('Request paymentMethod: ${placeOrderBody.paymentMethod}');
    print('Request orderNote: ${placeOrderBody.orderNote}');
    print('Request couponCode: ${placeOrderBody.couponCode}');
    print('Request restaurantId: ${placeOrderBody.restaurantId}');
    print('Request distance: ${placeOrderBody.distance}');
    print('Request scheduleAt: ${placeOrderBody.scheduleAt}');
    print('Request discountAmount: ${placeOrderBody.discountAmount}');
    print('Request taxAmount: ${placeOrderBody.taxAmount}');
    print('Request address: ${placeOrderBody.address}');
    print('Request latitude: ${placeOrderBody.latitude}');
    print('Request longitude: ${placeOrderBody.longitude}');
    print('Request contactPersonName: ${placeOrderBody.contactPersonName}');
    print('Request contactPersonNumber: ${placeOrderBody.contactPersonNumber}');
    print('Request road: ${placeOrderBody.road}');
    print('Request house: ${placeOrderBody.house}');


    String orderID = '';
    Response response = await checkoutServiceInterface.placeOrder(placeOrderBody);
    _isLoading = false;
     print('1${amount}');
    if (response.statusCode == 200) {
      print(' Response Body =====================>>>>>>>> ${response.body}');
      String? message = response.body['message'];
      orderID = response.body['order_id'].toString();
      checkoutServiceInterface.sendNotificationRequest(orderID, Get.find<AuthController>().isLoggedIn() ? null : Get.find<AuthController>().getGuestId());
      if(!isOfflinePay) {
        _callback(true, message, orderID, zoneID, amount, maximumCodOrderAmount, fromCart, isCashOnDeliveryActive, placeOrderBody.contactPersonNumber!);
      } else {
        Get.find<CartController>().getCartDataOnline();
      }
      if (kDebugMode) {
        print('2 ${amount}');
        print('-------- Order placed successfully $orderID ----------');
      }
    } else {
      print('isOfflinePay');
      if(!isOfflinePay){
        _callback(false, response.statusText, '-1', zoneID, amount, maximumCodOrderAmount, fromCart, isCashOnDeliveryActive, placeOrderBody.contactPersonNumber!);
      }else{
        print('take away error');

        showCustomSnackBar(response.statusText);
      }
    }
    update();
    return orderID;
  }



  // Future<String> placeOrder(
  //     PlaceOrderBodyModel placeOrderBody,
  //     int? zoneID,
  //     double amount,
  //     double? maximumCodOrderAmount,
  //     bool fromCart,
  //     bool isCashOnDeliveryActive, {
  //       bool isOfflinePay = false,
  //     }) async {
  //   _isLoading = true;
  //   update();
  //
  //   // Print the entire body before sending
  //   print('Request couponDiscountAmount: ${placeOrderBody.couponDiscountAmount}');
  //   print('Request couponDiscountTitle: ${placeOrderBody.couponDiscountTitle}');
  //   print('Request orderAmount: ${placeOrderBody.orderAmount}');
  //   print('Request orderType: ${placeOrderBody.orderType}');
  //   print('Request paymentMethod: ${placeOrderBody.paymentMethod}');
  //   print('Request orderNote: ${placeOrderBody.orderNote}');
  //   print('Request couponCode: ${placeOrderBody.couponCode}');
  //   print('Request restaurantId: ${placeOrderBody.restaurantId}');
  //   print('Request distance: ${placeOrderBody.distance}');
  //   print('Request scheduleAt: ${placeOrderBody.scheduleAt}');
  //   print('Request discountAmount: ${placeOrderBody.discountAmount}');
  //   print('Request taxAmount: ${placeOrderBody.taxAmount}');
  //   print('Request address: ${placeOrderBody.address}');
  //   print('Request latitude: ${placeOrderBody.latitude}');
  //   print('Request longitude: ${placeOrderBody.longitude}');
  //   print('Request contactPersonName: ${placeOrderBody.contactPersonName}');
  //   print('Request contactPersonNumber: ${placeOrderBody.contactPersonNumber}');
  //   print('Request road: ${placeOrderBody.road}');
  //   print('Request house: ${placeOrderBody.house}');
  //
  //   String orderID = '';
  //   try {
  //
  //     var url = Uri.parse('${AppConstants.baseUrl}/api/v1/customer/order/place'); // Update with your endpoint
  //     var headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWIzOTBmNWM4NjdmMTA5NWIyMTE0MDI1ZWJhYjY3OWZmNDg4MjBhMDk0Y2NhY2NkYTY2YWJjOTZiNThlODA3Yjc1NTFkOGIzYzgzY2RmZmEiLCJpYXQiOjE3MzM4MjcwODIuNjcyODMxLCJuYmYiOjE3MzM4MjcwODIuNjcyODQsImV4cCI6MTc2NTM2MzA4Mi41NzkwMjIsInN1YiI6IjY5Iiwic2NvcGVzIjpbXX0.8AtQOWvE1POJLZQt9i5FEDDkYyVuOBGjZV1wiAdTuI4_GVOExgTMKFbPs56sNdU5JKNkP_ok5BjA5SMBdoZXZZi-14zZZqEZDZp_aZQYEg2PEKutyL0ZjnNcOXZEUuDiml2GMmbsI64Qvodv1zfyqQY6b_uRltzw7mDtuxYSHxU308GwBpbmkfXei2Wjh3Zwpv7gOgmjGSEzMY7PyTpv69sZCpSd_lBWk3V6fuS1PM5e2ulEE9SEHLmyfnB5BiO-9vR6t9jGXErxuSP8TAk5tuPCp_5g3xktiJ5yiDkXEDiFOsPciurAaGkwwG7ZxUo7qYiGN8jS-mSiCkkC5GkHfvjjKImx4PXGhR_q0Cuyw9LXjQpC1PRxrFUfO2lLiFBEyYOgQ1r-C58TpVsPcO2bo6zUJT1dL-Vr-YguvEcTnswI8kEtYzTiadVlTabv7EkdkiqMNmL1fSE-jV2GmJwhpx8vLmSnHQvxjgIsR6l9Zxl-wWduipLzWXg_PDbnLtLBd4CG68nfC4l_2yeILqfhTjyz-uK7aUH0e7ytktU-ZJtSxAzDpIJa_EPKssJii2fNUspu-k9ch8aB13Pe7SeB2ieztoMqwuoe9TaFMVDj6T0Va7pV0--PrzaiMwu9rv9lR91vLkEhE6Jn5QA5pUJ5JJ8FRPfWP45bGB6kF8T3Meo',
  //     };
  //
  //
  //     var response = await http.post(
  //       url,
  //       headers: headers,
  //       body: jsonEncode(placeOrderBody.toJson()), // Convert body to JSON
  //     );
  //     print(' print(placeOrderBody.toJson());');
  //     print(placeOrderBody.toJson());
  //     print('placeOrderBody.toJson()');
  //
  //     _isLoading = false;
  //     print('1 $amount');
  //
  //     if (response.statusCode == 200) {
  //       var responseBody = jsonDecode(response.body);
  //       print('Response Body =====================>>>>>>>> ${responseBody}');
  //
  //       String? message = responseBody['message'];
  //       orderID = responseBody['order_id'].toString();
  //
  //
  //       checkoutServiceInterface.sendNotificationRequest(
  //         orderID,
  //         Get.find<AuthController>().isLoggedIn()
  //             ? null
  //             : Get.find<AuthController>().getGuestId(),
  //       );
  //
  //       if (!isOfflinePay) {
  //         _callback(
  //           true,
  //           message,
  //           orderID,
  //           zoneID,
  //           amount,
  //           maximumCodOrderAmount,
  //           fromCart,
  //           isCashOnDeliveryActive,
  //           placeOrderBody.contactPersonNumber!,
  //         );
  //       } else {
  //         Get.find<CartController>().getCartDataOnline();
  //       }
  //
  //       if (kDebugMode) {
  //         print('2 $amount');
  //         print('-------- Order placed successfully $orderID ----------');
  //       }
  //     } else {
  //       print('isOfflinePay');
  //       if (!isOfflinePay) {
  //         _callback(
  //           false,
  //           response.reasonPhrase,
  //           '-1',
  //           zoneID,
  //           amount,
  //           maximumCodOrderAmount,
  //           fromCart,
  //           isCashOnDeliveryActive,
  //           placeOrderBody.contactPersonNumber!,
  //         );
  //       } else {
  //         print('take away error');
  //         showCustomSnackBar(response.reasonPhrase);
  //       }
  //     }
  //   } catch (e) {
  //     _isLoading = false;
  //     print('Error placing order: $e');
  //     showCustomSnackBar('Failed to place order. Please try again.');
  //   }
  //
  //   update();
  //   return orderID;
  // }



  void _callback(bool isSuccess, String? message, String orderID, int? zoneID, double amount,
      double? maximumCodOrderAmount, bool fromCart, bool isCashOnDeliveryActive, String? contactNumber) async {
    if(isSuccess) {
      // Get.find<OrderController>().getRunningOrders(1, notify: false);
      if(fromCart) {
        Get.find<CartController>().clearCartList();
      }
      _setGuestAddress(null);
      stopLoader();
      if(paymentMethodIndex == 0 || paymentMethodIndex == 1) {
        double total = ((amount / 100) * Get.find<SplashController>().configModel!.loyaltyPointItemPurchasePoint!);
        Get.find<LoyaltyController>().saveEarningPoint(total.toStringAsFixed(0));
        if(ResponsiveHelper.isDesktop(Get.context)) {
          Get.offNamed(RouteHelper.getInitialRoute());
          Future.delayed(const Duration(seconds: 2) , () => Get.dialog(Center(child: SizedBox(height: 350, width : 500, child: OrderSuccessfulDialogWidget(orderID: orderID, contactNumber: contactNumber)))));
        } else {
          Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'success', amount, contactNumber));
        }

      }else {
        if(GetPlatform.isWeb) {
          await Get.find<AuthController>().saveGuestNumber(contactNumber ?? '');
          String? hostname = html.window.location.hostname;
          String protocol = html.window.location.protocol;
          String selectedUrl = '${AppConstants.baseUrl}/payment-mobile?order_id=$orderID&customer_id=${Get.find<ProfileController>().userInfoModel?.id ?? Get.find<AuthController>().getGuestId()}'
              '&payment_method=$digitalPaymentName&payment_platform=web&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID&amount=$amount&status=';
          html.window.open(selectedUrl,"_self");
        } else{
          Get.offNamed(RouteHelper.getPaymentRoute(
            OrderModel(id: int.parse(orderID), userId: Get.find<ProfileController>().userInfoModel?.id ?? 0, orderAmount: amount, restaurant: Get.find<RestaurantController>().restaurant),
            digitalPaymentName, guestId: Get.find<AuthController>().getGuestId(), contactNumber: contactNumber,
          ),
          );
        }
      }
      clearPrevData();
      updateTips(0);
      Get.find<CouponController>().removeCouponData(false);
    }else {
      // print('take away error2');
      showCustomSnackBar(message);
    }
  }

  void clearPrevData() {
    _addressIndex = 0;
    _paymentMethodIndex = -1;
    _selectedDateSlot = 0;
    _selectedTimeSlot = 0;
    _distance = null;
    _subscriptionOrder = false;
    _selectedDays = [null];
    _subscriptionType = 'daily';
    _subscriptionRange = null;
    _isDmTipSave = false;
  }

  void toggleDmTipSave() {
    _isDmTipSave = !_isDmTipSave;
    update();
  }

  Future<bool> updateOfflineInfo(String data) async {
    _isLoadingUpdate = true;
    update();
    bool success = await checkoutServiceInterface.updateOfflineInfo(data);
    if (success) {
      _isLoadingUpdate = false;
    }
    update();
    return success;
  }
}