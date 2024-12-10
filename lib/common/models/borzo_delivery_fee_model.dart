class BorzoDeliveryFee {
  final String paymentAmount;
  final String deliveryFeeAmount;

  BorzoDeliveryFee({
    required this.paymentAmount,
    required this.deliveryFeeAmount,
  });

  // Factory method to create an instance from JSON
  factory BorzoDeliveryFee.fromJson(Map<String, dynamic> json) {
    return BorzoDeliveryFee(
      paymentAmount: json['payment_amount'] ?? '0.00',
      deliveryFeeAmount: json['delivery_fee_amount'] ?? '0.00',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'payment_amount': paymentAmount,
      'delivery_fee_amount': deliveryFeeAmount,
    };
  }
}
