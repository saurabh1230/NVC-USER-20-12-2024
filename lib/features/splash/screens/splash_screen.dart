import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/no_internet_screen_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/notification/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/deep_link_body.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/images.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBodyModel? notificationBody;
  final DeepLinkBody? linkBody;

  const SplashScreen({
    Key? key,
    required this.notificationBody,
    required this.linkBody,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (!firstTime) {
          bool isNotConnected = result != ConnectivityResult.wifi &&
              result != ConnectivityResult.mobile;
          isNotConnected
              ? const SizedBox()
              : ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: isNotConnected ? Colors.red : Colors.green,
              duration: Duration(seconds: isNotConnected ? 6000 : 3),
              content: Text(
                isNotConnected ? 'no_connection'.tr : 'connected'.tr,
                textAlign: TextAlign.center,
              ),
            ),
          );
          if (!isNotConnected) {
            _route();
          }
        }
        firstTime = false;
      },
    );

    Get.find<SplashController>().initSharedData();
    if (AddressHelper.getAddressFromSharedPref() != null &&
        (AddressHelper.getAddressFromSharedPref()!.zoneIds == null ||
            AddressHelper.getAddressFromSharedPref()!.zoneData == null)) {
      AddressHelper.clearAddressFromSharedPref();
    }
    if (Get.find<AuthController>().isGuestLoggedIn() ||
        Get.find<AuthController>().isLoggedIn()) {
      Get.find<CartController>().getCartDataOnline();
    }
    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() {
    print('one');
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      print('two');
      print(isSuccess);
      if (isSuccess) {
        print('three');
        Timer(const Duration(milliseconds: 400), () async {
          double? minimumVersion = 0;
          if (GetPlatform.isAndroid) {
            minimumVersion = Get.find<SplashController>()
                .configModel!
                .appMinimumVersionAndroid;
          } else if (GetPlatform.isIOS) {
            minimumVersion =
                Get.find<SplashController>().configModel!.appMinimumVersionIos;
          }
          if (AppConstants.appVersion < minimumVersion! ||
              Get.find<SplashController>().configModel!.maintenanceMode!) {
            Get.offNamed(RouteHelper.getUpdateRoute(
                AppConstants.appVersion < minimumVersion));
          } else {
            print('four');
            if (widget.notificationBody != null && widget.linkBody == null) {
              _forNotificationRouteProcess();
              print('five');
            } else {
              if (Get.find<AuthController>().isLoggedIn()) {
                print('six');
                _forLoggedInUserRouteProcess();
              } else {
                print('seven');
                if (Get.find<SplashController>().showIntro()!) {
                  print('eight');
                  _newlyRegisteredRouteProcess();
                } else {
                  print('nine');
                  if (Get.find<AuthController>().isGuestLoggedIn()) {
                    print('ten');
                    _forGuestUserRouteProcess();
                  } else {
                    print('eleven');
                    Get.offNamed(
                        RouteHelper.getSignInRoute(RouteHelper.splash));
                  }
                }
              }
            }
          }
        });
      }
    });
    print('twelve');
  }

  void _forNotificationRouteProcess() {
    if (widget.notificationBody!.notificationType == NotificationType.order) {
      Get.offNamed(
          RouteHelper.getOrderDetailsRoute(widget.notificationBody!.orderId));
    } else if (widget.notificationBody!.notificationType ==
        NotificationType.general) {
      Get.offNamed(RouteHelper.getNotificationRoute(fromNotification: true));
    } else {
      Get.offNamed(RouteHelper.getChatRoute(
        notificationBody: widget.notificationBody,
        conversationID: widget.notificationBody!.conversationId,
      ));
    }
  }

  Future<void> _forLoggedInUserRouteProcess() async {
    Get.find<AuthController>().updateToken();
    await Get.find<FavouriteController>().getFavouriteList();
    if (AddressHelper.getAddressFromSharedPref() != null) {
      Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
    } else {
      Get.offNamed(RouteHelper.getAccessLocationRoute('splash'));
    }
  }

  void _newlyRegisteredRouteProcess() {
    Get.offNamed(RouteHelper.getOnBoardingRoute());
  }

  void _forGuestUserRouteProcess() {
    if (AddressHelper.getAddressFromSharedPref() != null) {
      Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
    } else {
      Get.find<SplashController>()
          .navigateToLocationScreen('splash', offNamed: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashController>(
        builder: (splashController) {
          return Center(
            child: splashController.hasConnection
                ? Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Images.splash),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      AnimatedLogoDrop(),
                    ],
                  )
                : NoInternetScreen(
                    child: SplashScreen(
                      notificationBody: widget.notificationBody,
                      linkBody: widget.linkBody,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class AnimatedLogoDrop extends StatefulWidget {
  @override
  _AnimatedLogoDropState createState() => _AnimatedLogoDropState();
}

class _AnimatedLogoDropState extends State<AnimatedLogoDrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // _positionAnimation = Tween<double>(begin: 350, end: 350).animate(
    //   CurvedAnimation(
    //     parent: _controller,
    //     curve: Curves.easeInOut,
    //   ),
    // );

    _scaleAnimation = Tween<double>(begin: 1.7, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Image.asset(
              Images.logo,
              width: 140,
              // adjust width as needed
            ),
          ),
        );
      },
    );
  }
}
