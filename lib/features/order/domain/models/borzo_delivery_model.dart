import 'dart:convert';

class BrozoModel {
  final int id;
  final String type;
  final int orderId;
  final int brozoOrderId;
  final String orderName;
  final DateTime createdDatetime;
  final String status;
  final String statusDescription;
  final String totalWeightKg;
  final String pickupAddress;
  final String dropAddress;
  final String paymentAmount;
  final String deliveryFeeAmount;
  final String weightFeeAmount;
  final String codFeeAmount;
  final String waitingFeeAmount;
  final String courier;
  final String paymentMethod;
  final String brozoDeliveryRecord;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String fromTrackingUrl;
  final String toTrackingUrl;

  BrozoModel({
    required this.id,
    required this.type,
    required this.orderId,
    required this.brozoOrderId,
    required this.orderName,
    required this.createdDatetime,
    required this.status,
    required this.statusDescription,
    required this.totalWeightKg,
    required this.pickupAddress,
    required this.dropAddress,
    required this.paymentAmount,
    required this.deliveryFeeAmount,
    required this.weightFeeAmount,
    required this.codFeeAmount,
    required this.waitingFeeAmount,
    required this.courier,
    required this.paymentMethod,
    required this.brozoDeliveryRecord,
    required this.createdAt,
    required this.updatedAt,
    required this.fromTrackingUrl,
    required this.toTrackingUrl,
  });

  factory BrozoModel.fromJson(Map<String, dynamic> json) {
    return BrozoModel(
      id: json['id'],
      type: json['type'],
      orderId: json['order_id'],
      brozoOrderId: json['brozo_order_id'],
      orderName: json['order_name'],
      createdDatetime: DateTime.parse(json['created_datetime']),
      status: json['status'],
      statusDescription: json['status_description'],
      totalWeightKg: json['total_weight_kg'],
      pickupAddress: json['pickup_address'],
      dropAddress: json['drop_address'],
      paymentAmount: json['payment_amount'],
      deliveryFeeAmount: json['delivery_fee_amount'],
      weightFeeAmount: json['weight_fee_amount'],
      codFeeAmount: json['cod_fee_amount'],
      waitingFeeAmount: json['waiting_fee_amount'],
      courier: json['courier'],
      paymentMethod: json['payment_method'],
      brozoDeliveryRecord: json['brozo_delivery_record'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      fromTrackingUrl: json['from_tracking_url'],
      toTrackingUrl: json['to_tracking_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'order_id': orderId,
      'brozo_order_id': brozoOrderId,
      'order_name': orderName,
      'created_datetime': createdDatetime.toIso8601String(),
      'status': status,
      'status_description': statusDescription,
      'total_weight_kg': totalWeightKg,
      'pickup_address': pickupAddress,
      'drop_address': dropAddress,
      'payment_amount': paymentAmount,
      'delivery_fee_amount': deliveryFeeAmount,
      'weight_fee_amount': weightFeeAmount,
      'cod_fee_amount': codFeeAmount,
      'waiting_fee_amount': waitingFeeAmount,
      'courier': courier,
      'payment_method': paymentMethod,
      'brozo_delivery_record': brozoDeliveryRecord,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'from_tracking_url': fromTrackingUrl,
      'to_tracking_url': toTrackingUrl,
    };
  }
}
