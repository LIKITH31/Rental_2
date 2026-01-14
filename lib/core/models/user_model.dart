import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime createdAt;
  final int itemsListed;
  final int rentalsCount;
  final double rating;
  final List<String> favorites;
  
  // Subscription Fields
  final String subscriptionTier; // 'basic' or 'premium'
  final String subscriptionStatus; // 'active', 'expired', 'none'
  final DateTime? subscriptionExpiry;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    this.itemsListed = 0,
    this.rentalsCount = 0,
    this.rating = 0.0,
    this.favorites = const [],
    this.subscriptionTier = 'basic',
    this.subscriptionStatus = 'none',
    this.subscriptionExpiry,
  });

  bool get isPremium => ['renter_plus', 'lender_pro', 'pro_max'].contains(subscriptionTier);

  bool get hasReducedFees => ['renter_plus', 'lender_pro', 'pro_max'].contains(subscriptionTier);

  bool get hasUnlimitedListings => ['lender_pro', 'pro_max'].contains(subscriptionTier);

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'itemsListed': itemsListed,
      'rentalsCount': rentalsCount,
      'rating': rating,
      'favorites': favorites,
      'subscriptionTier': subscriptionTier,
      'subscriptionStatus': subscriptionStatus,
      'subscriptionExpiry': subscriptionExpiry != null ? Timestamp.fromDate(subscriptionExpiry!) : null,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? 'User',
      photoURL: data['photoURL'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      itemsListed: data['itemsListed'] ?? 0,
      rentalsCount: data['rentalsCount'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),
      favorites: List<String>.from(data['favorites'] ?? []),
      subscriptionTier: data['subscriptionTier'] ?? 'basic',
      subscriptionStatus: data['subscriptionStatus'] ?? 'none',
      subscriptionExpiry: (data['subscriptionExpiry'] as Timestamp?)?.toDate(),
    );
  }
}
