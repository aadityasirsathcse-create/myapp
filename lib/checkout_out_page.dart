import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/address_page.dart';

class CheckoutPage extends StatefulWidget {
  final double price;
  final int quantity;
  final double discountPercentage;

  const CheckoutPage({
    super.key,
    required this.price,
    this.quantity = 1,
    required this.discountPercentage,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Address _shippingAddress = Address(
    street: '22 Baker Street',
    city: 'London',
    state: 'MG91',
    zipCode: '9AF',
  );
  Address _billingAddress = Address(
    street: '22 Baker Street',
    city: 'London',
    state: 'MG91',
    zipCode: '9AF',
  );

  void _navigateAndEditAddress(
    BuildContext context,
    Address currentAddress,
    Function(Address) onAddressChanged,
  ) async {
    final newAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressPage(address: currentAddress),
      ),
    );

    if (newAddress != null) {
      onAddressChanged(newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.price * widget.quantity;
    final semitotal = subtotal * widget.discountPercentage / 100;
    final shippingFee = 3.00 * widget.quantity;
    final total = subtotal - semitotal + shippingFee;
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
            _buildPriceRow('Discount', semitotal),
            const Divider(),
            _buildPriceRow('Total', total, isTotal: true),
            const SizedBox(height: 32),
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAddressCard(
              '${_shippingAddress.street}\n${_shippingAddress.city} ${_shippingAddress.state} ${_shippingAddress.zipCode}',
              () => _navigateAndEditAddress(context, _shippingAddress, (
                newAddress,
              ) {
                setState(() {
                  _shippingAddress = newAddress;
                });
              }),
            ),
            const SizedBox(height: 32),
            const Text(
              'Billing Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAddressCard(
              '${_billingAddress.street}\n${_billingAddress.city} ${_billingAddress.state} ${_billingAddress.zipCode}',
              () => _navigateAndEditAddress(context, _billingAddress, (
                newAddress,
              ) {
                setState(() {
                  _billingAddress = newAddress;
                });
              }),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5B74FF), Color(0xFF2DE6AF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      '/shippingPayment',
                      extra: {
                        'shippingAddress': _shippingAddress,
                        'billingAddress': _billingAddress,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    backgroundColor: Colors.transparent, // 👈 transparent bg
                    shadowColor: Colors.transparent, // 👈 remove shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // match container radius
                    ),
                  ),
                  child: const Text(
                    'Check Out',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ), // white text
                  ),
                ),
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

  Widget _buildAddressCard(String address, VoidCallback onChange) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(address),
            TextButton(onPressed: onChange, child: const Text('Change')),
          ],
        ),
      ),
    );
  }
}
