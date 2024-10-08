import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/dimensions.dart';


class OrderTrackingScreen extends StatefulWidget {
  final String? orderID;
  final String? contactNumber;

  const OrderTrackingScreen({super.key, required this.orderID, this.contactNumber});

  @override
  OrderTrackingScreenState createState() => OrderTrackingScreenState();
}

class OrderTrackingScreenState extends State<OrderTrackingScreen> with WidgetsBindingObserver {
  late InAppWebViewController _webViewController; // Use InAppWebViewController

  void _loadData() async {
    await Get.find<OrderController>().trackOrder(widget.orderID, null, true, contactNumber: widget.contactNumber);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    Get.find<OrderController>().cancelTimer();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'order_tracking'.tr),
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<OrderController>(builder: (orderController) {
        OrderModel? track;
        if (orderController.trackModel != null) {
          track = orderController.trackModel;
        }

        return track != null
            ? Center(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Stack(
              children: [
                track.brozohistory != null && track.brozohistory!.fromTrackingUrl != null
                    ? InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(track.brozohistory!.fromTrackingUrl.toString()), // Use WebUri
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController webViewController) {
                    _webViewController = webViewController;
                  },
                )
                    : Center(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Images.animateDeliveryMan),
                      SizedBox(height: Dimensions.paddingSizeDefault,),
                      Text(
                        'Order Not confirmed yet', // Display this message if the URL is null
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                // Positioned(
                //   bottom: Dimensions.paddingSizeSmall,
                //   left: Dimensions.paddingSizeSmall,
                //   right: Dimensions.paddingSizeSmall,
                //   child: Column(
                //     children: [
                //       // Check if fromTrackingUrl is not null before launching
                //       GestureDetector(
                //         onTap: () async {
                //           final url = track!.brozohistory?.fromTrackingUrl; // Use safe access
                //           if (url != null && await canLaunch(url)) {
                //             await launch(url);
                //           } else {
                //             // Handle the case where URL is null or cannot be launched
                //             showDialog(
                //               context: context,
                //               builder: (context) => AlertDialog(
                //                 title: const Text('Error'),
                //                 content: const Text('Could not launch the URL.'),
                //                 actions: [
                //                   TextButton(
                //                     onPressed: () => Navigator.of(context).pop(),
                //                     child: const Text('OK'),
                //                   ),
                //                 ],
                //               ),
                //             );
                //           }
                //         },
                //         child: Text(
                //           track.brozohistory?.fromTrackingUrl ?? '', // Safely access
                //           style: TextStyle(
                //             color: Colors.blue,
                //             decoration: TextDecoration.underline,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        )
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}



// import 'dart:async';
// import 'dart:collection';
// import 'dart:ui';
// import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
// import 'package:stackfood_multivendor/features/notification/domain/models/notification_body_model.dart';
// import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
// import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
// import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
// import 'package:stackfood_multivendor/features/chat/domain/models/conversation_model.dart';
// import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
// import 'package:stackfood_multivendor/features/order/widgets/track_details_view.dart';
// import 'package:stackfood_multivendor/features/order/widgets/tracking_stepper_widget.dart';
// import 'package:stackfood_multivendor/helper/address_helper.dart';
// import 'package:stackfood_multivendor/helper/responsive_helper.dart';
// import 'package:stackfood_multivendor/helper/route_helper.dart';
// import 'package:stackfood_multivendor/util/dimensions.dart';
// import 'package:stackfood_multivendor/util/images.dart';
// import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
// import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
// import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
// import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
// import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
// import 'package:stackfood_multivendor/util/dimensions.dart';
//
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter/webview_flutter.dart';


//
// class OrderTrackingScreen extends StatefulWidget {
//   final String? orderID;
//   final String? contactNumber;
//   const OrderTrackingScreen({super.key, required this.orderID, this.contactNumber});
//
//   @override
//   OrderTrackingScreenState createState() => OrderTrackingScreenState();
// }
//
// class OrderTrackingScreenState extends State<OrderTrackingScreen> with WidgetsBindingObserver {
//   GoogleMapController? _controller;
//   bool _isLoading = true;
//   Set<Marker> _markers = HashSet<Marker>();
//
//   void _loadData() async {
//
//     await Get.find<LocationController>().getCurrentLocation(true, notify: false, defaultLatLng: LatLng(
//       double.parse(AddressHelper.getAddressFromSharedPref()!.latitude!),
//       double.parse(AddressHelper.getAddressFromSharedPref()!.longitude!),
//     ));
//     Get.find<OrderController>().trackOrder(widget.orderID, null, true, contactNumber: widget.contactNumber);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     print('track order ap running');
//     // Get.find<OrderController>().trackBorzoOrder(widget.orderID);
//     print('track order ap running');
//
//     _loadData();
//     // Get.find<OrderController>().callTrackOrderApi(orderModel: Get.find<OrderController>().trackModel, orderId: widget.orderID.toString());
//   }
//
//   @override
//   void didChangeAppLifecycleState(final AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       Get.find<OrderController>().callTrackOrderApi(orderModel: Get.find<OrderController>().trackModel!, orderId: widget.orderID.toString(), contactNumber: widget.contactNumber);
//     }else if(state == AppLifecycleState.paused){
//       Get.find<OrderController>().cancelTimer();
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller?.dispose();
//     Get.find<OrderController>().cancelTimer();
//     WidgetsBinding.instance.removeObserver(this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: CustomAppBarWidget(title: 'order_tracking'.tr),
//       endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
//       body: GetBuilder<OrderController>(builder: (orderController) {
//         OrderModel? track;
//         if(orderController.trackModel != null) {
//           track = orderController.trackModel;
//           print('check brozohistory => ${track!.brozohistory!.fromTrackingUrl.toString()}');
//         }
//         return track != null ? Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Stack(children: [
//           WebView(
//             initialUrl: url,
//             javascriptMode: JavascriptMode.unrestricted,
//           ),
//           Positioned(
//             bottom: Dimensions.paddingSizeSmall,
//             left: Dimensions.paddingSizeSmall,
//             right: Dimensions.paddingSizeSmall,
//             child: Column(
//               children: [
//                 // TrackDetailsView(
//                 //   track: track,
//                 //   callback: () async {
//                 //     bool takeAway = track?.orderType == 'take_away';
//                 //     orderController.cancelTimer();
//                 //     await Get.toNamed(RouteHelper.getChatRoute(
//                 //       notificationBody: takeAway
//                 //           ? NotificationBodyModel(
//                 //           restaurantId: track!.restaurant!.id,
//                 //           orderId: int.parse(widget.orderID!))
//                 //           : NotificationBodyModel(
//                 //           deliverymanId: track!.deliveryMan!.id,
//                 //           orderId: int.parse(widget.orderID!)),
//                 //       user: User(
//                 //         id: takeAway ? track.restaurant!.id : track.deliveryMan!.id,
//                 //         fName: takeAway ? track.restaurant!.name : track.deliveryMan!.fName,
//                 //         lName: takeAway ? '' : track.deliveryMan!.lName,
//                 //         image: takeAway ? track.restaurant!.logo : track.deliveryMan!.image,
//                 //       ),
//                 //     ));
//                 //     orderController.callTrackOrderApi(
//                 //         orderModel: track,
//                 //         orderId: track.id.toString(),
//                 //         contactNumber: widget.contactNumber);
//                 //   },
//                 // ),
//                 GestureDetector(
//                   onTap: () async {
//                     final url = track?.brozohistory!.fromTrackingUrl.toString();
//                     if (await canLaunch(url!)) {
//                       await launch(url);
//                     } else {
//                       throw 'Could not launch $url';
//                     }
//                   },
//                   child: Text(
//                     track.brozohistory!.fromTrackingUrl.toString(),
//                     style: TextStyle(
//                       color: Colors.blue,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//           // GoogleMap(
//           //   initialCameraPosition: CameraPosition(target: LatLng(
//           //     double.parse(track.deliveryAddress!.latitude!), double.parse(track.deliveryAddress!.longitude!),
//           //   ), zoom: 16),
//           //   minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
//           //   zoomControlsEnabled: true,
//           //   markers: _markers,
//           //   onMapCreated: (GoogleMapController controller) {
//           //     _controller = controller;
//           //     _isLoading = false;
//           //     setMarker(
//           //       track!.restaurant, track.deliveryMan,
//           //       track.orderType == 'take_away' ? Get.find<LocationController>().position.latitude == 0 ? track.deliveryAddress : AddressModel(
//           //         latitude: Get.find<LocationController>().position.latitude.toString(),
//           //         longitude: Get.find<LocationController>().position.longitude.toString(),
//           //         address: Get.find<LocationController>().address,
//           //       ) : track.deliveryAddress,
//           //       track.orderType == 'take_away',
//           //     );
//           //   },
//           // ),
//           //
//           // _isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),
//           //
//           // Positioned(
//           //   top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
//           //   child: TrackingStepperWidget(status: track.orderStatus, takeAway: track.orderType == 'take_away'),
//           // ),
//           //
//           // Positioned(
//           //   bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
//           //   child: Column(
//           //     children: [
//           //       TrackDetailsView(track: track, callback: () async {
//           //         bool takeAway = track?.orderType == 'take_away';
//           //         orderController.cancelTimer();
//           //         await Get.toNamed(RouteHelper.getChatRoute(
//           //           notificationBody: takeAway ? NotificationBodyModel(restaurantId: track!.restaurant!.id, orderId: int.parse(widget.orderID!))
//           //            : NotificationBodyModel(deliverymanId: track!.deliveryMan!.id, orderId: int.parse(widget.orderID!)),
//           //           user: User(
//           //             id: takeAway ? track.restaurant!.id : track.deliveryMan!.id,
//           //             fName: takeAway ? track.restaurant!.name : track.deliveryMan!.fName,
//           //             lName: takeAway ? '' : track.deliveryMan!.lName,
//           //             image: takeAway ? track.restaurant!.logo : track.deliveryMan!.image,
//           //           ),
//           //         ));
//           //         orderController.callTrackOrderApi(orderModel: track, orderId: track.id.toString(), contactNumber: widget.contactNumber);
//           //       }),
//           //      Text(track.brozohistory!.fromTrackingUrl.toString()),
//           //
//           //     ],
//           //   ),
//           // ),
//         ]))) : const Center(child: CircularProgressIndicator());
//       }),
//     );
//   }
// // void setMarker(Restaurant? restaurant, DeliveryMan? deliveryMan, AddressModel? addressModel, bool takeAway) async {
// //   try {
// //     Uint8List restaurantImageData = await convertAssetToUnit8List(Images.restaurantMarker, width: 100);
// //     Uint8List deliveryBoyImageData = await convertAssetToUnit8List(Images.deliveryManMarker, width: 100);
// //     Uint8List destinationImageData = await convertAssetToUnit8List(
// //       takeAway ? Images.myLocationMarker : Images.userMarker,
// //       width: takeAway ? 50 : 100,
// //     );
// //
// //     // Animate to coordinate
// //     LatLngBounds? bounds;
// //     double rotation = 0;
// //     if(_controller != null) {
// //       if (double.parse(addressModel!.latitude!) < double.parse(restaurant!.latitude!)) {
// //         bounds = LatLngBounds(
// //           southwest: LatLng(double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)),
// //           northeast: LatLng(double.parse(restaurant.latitude!), double.parse(restaurant.longitude!)),
// //         );
// //         rotation = 0;
// //       }else {
// //         bounds = LatLngBounds(
// //           southwest: LatLng(double.parse(restaurant.latitude!), double.parse(restaurant.longitude!)),
// //           northeast: LatLng(double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)),
// //         );
// //         rotation = 180;
// //       }
// //     }
// //     LatLng centerBounds = LatLng(
// //       (bounds!.northeast.latitude + bounds.southwest.latitude)/2,
// //       (bounds.northeast.longitude + bounds.southwest.longitude)/2,
// //     );
// //
// //     _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: centerBounds, zoom: GetPlatform.isWeb ? 10 : 17)));
// //     if(!ResponsiveHelper.isWeb()) {
// //       zoomToFit(_controller, bounds, centerBounds, padding: 1.5);
// //     }
// //
// //     // Marker
// //     _markers = HashSet<Marker>();
// //     addressModel != null ? _markers.add(Marker(
// //       markerId: const MarkerId('destination'),
// //       position: LatLng(double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)),
// //       infoWindow: InfoWindow(
// //         title: 'Destination',
// //         snippet: addressModel.address,
// //       ),
// //       icon: GetPlatform.isWeb ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(destinationImageData),
// //     )) : const SizedBox();
// //
// //     restaurant != null ? _markers.add(Marker(
// //       markerId: const MarkerId('restaurant'),
// //       position: LatLng(double.parse(restaurant.latitude!), double.parse(restaurant.longitude!)),
// //       infoWindow: InfoWindow(
// //         title: 'restaurant'.tr,
// //         snippet: restaurant.address,
// //       ),
// //       icon: GetPlatform.isWeb ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(restaurantImageData),
// //     )) : const SizedBox();
// //
// //     deliveryMan != null ? _markers.add(Marker(
// //       markerId: const MarkerId('delivery_boy'),
// //       position: LatLng(double.parse(deliveryMan.lat ?? '0'), double.parse(deliveryMan.lng ?? '0')),
// //       infoWindow: InfoWindow(
// //         title: 'delivery_man'.tr,
// //         snippet: deliveryMan.location,
// //       ),
// //       rotation: rotation,
// //       icon: GetPlatform.isWeb ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(deliveryBoyImageData),
// //     )) : const SizedBox();
// //   }catch(_) {}
// //   setState(() {});
// // }
// //
// // Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds, {double padding = 0.5}) async {
// //   bool keepZoomingOut = true;
// //
// //   while(keepZoomingOut) {
// //     final LatLngBounds screenBounds = await controller!.getVisibleRegion();
// //     if(fits(bounds!, screenBounds)){
// //       keepZoomingOut = false;
// //       final double zoomLevel = await controller.getZoomLevel() - padding;
// //       controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
// //         target: centerBounds,
// //         zoom: zoomLevel,
// //       )));
// //       break;
// //     }
// //     else {
// //       // Zooming out by 0.1 zoom level per iteration
// //       final double zoomLevel = await controller.getZoomLevel() - 0.1;
// //       controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
// //         target: centerBounds,
// //         zoom: zoomLevel,
// //       )));
// //     }
// //   }
// // }
// //
// // bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
// //   final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
// //   final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;
// //
// //   final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
// //   final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;
// //
// //   return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
// // }
// //
// // Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
// //   ByteData data = await rootBundle.load(imagePath);
// //   Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
// //   FrameInfo fi = await codec.getNextFrame();
// //   return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
// // }
// }



