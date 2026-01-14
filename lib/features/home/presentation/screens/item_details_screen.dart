import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/models/order_model.dart';
import '../../../booking/presentation/booking_screen.dart';
import '../../../booking/presentation/payment_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ItemDetailsScreen extends StatelessWidget {
  final ItemModel item;

  const ItemDetailsScreen({super.key, required this.item});

  void _handleAction(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to continue')),
      );
      return;
    }

    // Always Rent Flow
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = '₹';
    // Prioritize Rental Price display since we are forcing Rent Now
    final price = '$currency${item.rentalPricePerDay} / day';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(item.title),
              background: Container(
                color: Colors.grey.shade900,
                child: item.images.isNotEmpty 
                  ? Image.network(
                      item.images.first, 
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image, size: 100, color: Colors.white54)),
                    )
                  : const Center(
                      child: Icon(Icons.image, size: 100, color: Colors.white54),
                    ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        price,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  // Always show rental rates since we are renting
                  _buildDetailRow(context, 'Security Deposit', '$currency${item.securityDeposit ?? 0}'),
                  const SizedBox(height: 12),
                  _buildDetailRow(context, 'Weekly Rate', item.rentalPricePerWeek != null ? '$currency${item.rentalPricePerWeek}' : '-'),
                  const SizedBox(height: 12),
                  _buildDetailRow(context, 'Monthly Rate', item.rentalPricePerMonth != null ? '$currency${item.rentalPricePerMonth}' : '-'),
                  const SizedBox(height: 12),
                  if (item.originalPrice != null) ...[
                    _buildDetailRow(context, 'Original Price (MRP)', '$currency${item.originalPrice}'),
                    const SizedBox(height: 12),
                  ],
                  if (item.dimensions != null) ...[
                    _buildDetailRow(context, 'Dimensions / Specs', item.dimensions!),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 24),
                  
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.store)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rented by ${item.ownerName}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            'Verified Seller',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _handleAction(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF781C2E), // Primary Color
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'RENT NOW',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
