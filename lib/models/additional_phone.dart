class AdditionalPhone {
  final String id;
  final String phoneNumber;

  AdditionalPhone({
    required this.id,
    required this.phoneNumber,
  });

  factory AdditionalPhone.fromJson(Map<String, dynamic> json) {
    return AdditionalPhone(
      id: json['id'].toString(),
      phoneNumber: json['phone_number'],
    );
  }
}
