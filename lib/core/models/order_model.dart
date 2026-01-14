import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String itemId;
  final String renterId;
  final String lenderId;
  final String rentalStatus; // Changed from status
  final DateTime startDate; // Changed from String
  final DateTime endDate;   // Changed from String
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.itemId,
    required this.renterId,
    required this.lenderId,
    required this.rentalStatus,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'itemId': itemId,
      'renterId': renterId,
      'lenderId': lenderId,
      'rentalStatus': rentalStatus,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: data['id'] ?? '',
      itemId: data['itemId'] ?? '',
      renterId: data['renterId'] ?? data['customerId'] ?? '',
      lenderId: data['lenderId'] ?? '',
      rentalStatus: data['rentalStatus'] ?? data['status'] ?? 'requested',
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
