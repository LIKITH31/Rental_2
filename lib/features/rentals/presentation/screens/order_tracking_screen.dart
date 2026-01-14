import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/items_provider.dart';
import '../../../../core/models/order_model.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final OrderModel order;
  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Order ${order.id}')),
      body: FutureBuilder(
        future: ref.read(firestoreServiceProvider).getItemById(order.itemId),
        builder: (context, snapshot) {
          final item = snapshot.data;
          final title = item?.title ?? 'Unknown Item';
          final pricePerDay = item?.rentalPricePerDay ?? 0;
          
          final days = order.endDate.difference(order.startDate).inDays;
          final totalAmount = (days > 0 ? days : 1) * pricePerDay;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 60, height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        if (pricePerDay > 0)
                          Text('Total: \$${totalAmount.toStringAsFixed(0)}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                const Text('Delivery Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),

                _buildTimeline(order.rentalStatus),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildTimeline(String currentStatus) {
    // Define the full flow
    final steps = ['Requested', 'Confirmed', 'Picked Up', 'In Use', 'Returned', 'Completed'];
    
    // Find current index
    int currentIndex = steps.map((e) => e.toLowerCase()).toList().indexOf(currentStatus.toLowerCase());
    if (currentIndex == -1) currentIndex = 0; // Default

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isCompleted = index <= currentIndex;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? Colors.green : Colors.grey[300],
                  ),
                  child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
                if (!isLast)
                  Container(
                    width: 2, height: 40,
                    color: isCompleted && index < currentIndex ? Colors.green : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step, style: TextStyle(
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? Colors.black : Colors.grey,
                  )),
                  const SizedBox(height: 48), // Spacing matching the line height
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
