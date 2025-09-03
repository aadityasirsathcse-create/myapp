
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class CheckoutPage extends StatelessWidget {
  final double price;
  final int quantity;

  const CheckoutPage({
    super.key,
    required this.price,
    this.quantity = 1,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = price * quantity;
    final shippingFee = 3.00 * quantity;
    final total = subtotal + shippingFee;
    final now = DateTime.now();
    final formatter = DateFormat('d MMM y, HH:mm');
    final formattedDate = formatter.format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('$formattedDate • Credit / Debit Card'),
            const SizedBox(height: 16),
            _buildPriceRow('Subtotal', subtotal),
            _buildPriceRow('Shipping Fee', shippingFee),
            const Divider(),
            _buildPriceRow('Total', total, isTotal: true),
            const SizedBox(height: 32),
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAddressCard('22 Baker Street\nLondon MG91 9AF'),
            const SizedBox(height: 32),
            const Text(
              'Billing Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAddressCard('22 Baker Street\nLondon MG91 9AF'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/shippingPayment');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Check Out', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 33),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'USD ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(String address) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(address),
            TextButton(
              onPressed: () {},
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}
