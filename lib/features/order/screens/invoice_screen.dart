import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/features/order/widgets/order_pricing_section.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:http/http.dart' as http;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePdfGenerator {
  final String restaurantLogoUrl;
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantPhone;
  final OrderController orderController;
  final double itemsPrice;
  final double addons;
  final double subtotal;
  final double couponDiscount;
  final double discount;
  final double tax;
  final double deliveryCharge;
  final double total;
  final int orderID;
  final OrderModel order;
  final String? userContactNo;

  InvoicePdfGenerator({
    required this.restaurantLogoUrl,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.restaurantPhone,
    required this.orderController,
    required this.itemsPrice,
    required this.addons,
    required this.subtotal,
    required this.couponDiscount,
    required this.discount,
    required this.tax,
    required this.deliveryCharge,
    required this.total,
    required this.orderID,
    required this.order,
    required this.userContactNo,
  });

  Future<Uint8List> _getLogoBytes() async {
    final response = await http.get(Uri.parse(restaurantLogoUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load restaurant logo');
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final logoBytes = await _getLogoBytes();

    final fontData = await rootBundle.load('assets/font/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Non Veg City Food Order: Summary and Receipt ',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 14),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 2),
                  pw.Row(
                    children: [
                      pw.Text(
                        'Order Id: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold,),
                      ),
                      pw.Text('$orderID'),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    children: [
                      pw.Text(
                        'Order Time: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text('${order.createdAt}'),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    children: [
                      pw.Text(
                        'Customer Number: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text('$userContactNo'),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row( crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Delivery Address: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          '${order.deliveryAddress!.address}',
                        ),
                      ),
                      // pw.Text('${order.deliveryAddress!.address}'),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    children: [
                      pw.Text(
                        'Restaurant Name: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text('${order.restaurant!.name}'),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    children: [
                      pw.Text(
                        'Phone: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(restaurantPhone),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Restaurant Address: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          '${order.restaurant!.address}',
                        ),
                      ),
                      // pw.Text('${order.restaurant!.address}'),
                    ],
                  ),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 16),
              // Header Row
              pw.Container(
                color: PdfColors.grey300, // Background color for the header row
                padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Expanded(flex: 3,
                      child: pw.Text("Items", style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),),
                    pw.Expanded(
                      flex: 1, child: pw.Text("Qty", style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center,),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "Unit Price",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "Total Price",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),

// Data Rows
              ...orderController.orderDetails!.asMap().entries.map((entry) {
                final item = entry.value;
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          item.foodDetails!.name!,
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          item.quantity.toString(),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          '₹ ${item.price.toString()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          '₹ $total',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [

                  pw.Text(
                    'Delivery Charge Subtotal',
                    style: pw.TextStyle(
                      font: ttf,
                    ),
                  ),
                  pw.Text(
                    '₹ $deliveryCharge',
                    style: pw.TextStyle(
                      font: ttf,
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Taxes',
                    style: pw.TextStyle(
                      font: ttf,
                    ),
                  ),
                  pw.Text(
                    '₹ $tax',
                    style: pw.TextStyle(
                      font: ttf,
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Discount',
                    style: pw.TextStyle(
                      font: ttf,
                    ),
                  ),
                  pw.Text(
                    '₹ - $discount',
                    style: pw.TextStyle(
                      font: ttf,
                    ),
                  ),
                ],
              ),
              pw.Divider(),
              pw.Container(
                color: PdfColors.grey300,
                padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Total Amount:",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.Text(total.toStringAsFixed(2),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        )),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'Refund and Cancellation Policy',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
              ),
              pw.SizedBox(height: 10),

              // Eligibility for Refunds Section
              pw.Text(
                'Eligibility for Refunds: You are entitled to a refund if:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Text('• ', style: pw.TextStyle(fontSize: 10,font: ttf)),
                      pw.Text(
                        'Your order was damaged or tampered with during delivery.',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('• ', style: pw.TextStyle(fontSize: 10,font: ttf)),
                      pw.Text(
                        'NVC cancels your order due to delivery zone issues or operational reasons.',
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('• ', style: pw.TextStyle(fontSize: 10,font: ttf)),
                      pw.Text(
                        'Items in your order are unavailable at the time of confirmation.',
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Refund Process and Timeline Section
              pw.Text(
                'Refund Process and Timeline: Refunds are processed back to the original payment method within a stipulated timeframe:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Text('• ', style: pw.TextStyle(fontSize: 10,font: ttf)),
                      pw.Text(
                        'Net Banking, Debit/Credit Cards: 5-7 business days.',
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('• ', style: pw.TextStyle(fontSize: 10,font: ttf)),
                      pw.Text(
                        'UPI Transactions: 3-4 business days.',
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('• ', style: pw.TextStyle(fontSize: 10,font: ttf)),
                      pw.Text(
                        'E-Wallets (Amazon Pay, PhonePe, Paytm, etc.): Timeframes vary from 1 hour to 5 business days, depending on the wallet provider.',
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Cancellation Fees Section
              pw.Text(
                'Cancellation Fees: A cancellation fee ranging from a minimum of INR 80 up to the full order value may be applied if you cancel your order after it has been confirmed.',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 5),

              // Exceptions to Cancellation Fees Section
              pw.Text(
                'Exceptions to Cancellation Fees: NVC may waive cancellation fees under circumstances where the cancellation is due to reasons attributable to NVC or its partners, including item unavailability or service errors.',
                style: pw.TextStyle(fontSize: 10),
              ),

          // pw.Text('Total Amount: ₹ ${total.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice_$orderID.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFilex.open(file.path);
  }
}

class InvoiceDialogWidget extends StatelessWidget {
  final String restaurantLogo;
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantPhone;
  final String restaurantGst;
  final OrderController orderController;
  final double itemsPrice;
  final double addons;
  final double subtotal;
  final double couponDiscount;
  final double discount;
  final double tax;
  final double deliveryCharge;
  final double total;
  final int orderID;
  final OrderModel order;

  const InvoiceDialogWidget({
    super.key,
    required this.restaurantLogo,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.restaurantPhone,
    required this.orderController,
    required this.itemsPrice,
    required this.addons,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.deliveryCharge,
    required this.total,
    required this.orderID,
    required this.couponDiscount,
    required this.order,
    required this.restaurantGst,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: SizedBox(
        width: Get.size.width,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomImageWidget(image: restaurantLogo, height: 50, width: 50),
              const Divider(thickness: 1, color: Colors.black),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(restaurantName, style: robotoBold),
              Text(
                'Address : $restaurantAddress',
                style: robotoRegular,
                textAlign: TextAlign.center,
              ),
              Text('Phone : $restaurantPhone', style: robotoRegular),
              restaurantGst.isEmpty
                  ? const SizedBox()
                  : Text('Gst : $restaurantGst', style: robotoRegular),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              const Divider(thickness: 1, color: Colors.black),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("S.No"),
                  SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(flex: 3, child: Text("Items")),
                  Expanded(child: Text("Qty")),
                  Expanded(child: Text("Price")),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Expanded(
                child: ListView.builder(
                  itemCount: orderController.orderDetails!.length,
                  itemBuilder: (context, index) {
                    final item = orderController.orderDetails![index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${index + 1}"),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          flex: 3,
                          child: Text(item.foodDetails!.name!,
                              maxLines: 4, overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(item.quantity.toString(),
                                  maxLines: 4, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(item.price.toString(),
                              maxLines: 4, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Divider(thickness: 1, color: Colors.black),
              OrderPricingSection(
                itemsPrice: itemsPrice,
                addOns: 0,
                order: order,
                subTotal: subtotal,
                discount: discount,
                couponDiscount: couponDiscount,
                tax: tax,
                dmTips: 0,
                deliveryCharge: deliveryCharge,
                total: total,
                orderController: orderController,
                orderId: orderID,
                contactNumber: 'widget.contactNumber',
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              CustomButtonWidget(
                buttonText: 'Download Invoice',
                onPressed: () {
                  final pdfGenerator = InvoicePdfGenerator(
                    restaurantName: restaurantName,
                    restaurantAddress: restaurantAddress,
                    restaurantPhone: restaurantPhone,
                    orderController: orderController,
                    itemsPrice: itemsPrice,
                    addons: addons,
                    subtotal: subtotal,
                    couponDiscount: couponDiscount,
                    discount: discount,
                    tax: tax,
                    deliveryCharge: deliveryCharge,
                    total: total,
                    orderID: orderID,
                    order: order,
                    restaurantLogoUrl: restaurantLogo,
                    userContactNo:
                        Get.find<ProfileController>().userInfoModel!.phone,
                  );
                  pdfGenerator.generatePdf();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
