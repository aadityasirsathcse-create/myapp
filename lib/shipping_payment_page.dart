import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class ShippingPaymentPage extends StatefulWidget {
  const ShippingPaymentPage({super.key});

  @override
  State<ShippingPaymentPage> createState() => _ShippingPaymentPageState();
}

class _ShippingPaymentPageState extends State<ShippingPaymentPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  int _selectedAddress = 1;
  int _selectedPayment = 1;

  Future<void> _authenticate() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to complete your purchase',
      );
      if (authenticated) {
        // You can add logic here to proceed with the payment
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping & Payment'),
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
            _buildSectionHeader('Shipping Address', 'Edit'),
            _buildAddressCard(
              'Waterway Residences\nLondon MG91 9AF',
              0,
            ),
            const SizedBox(height: 16),
            _buildAddressCard(
              '22 Baker Street\nLondon MG91 9AF',
              1,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Payment Method', 'Add Card'),
            _buildPaymentCard('**** **** **** 0309', 0, isVisa: true),
            const SizedBox(height: 16),
            _buildPaymentCard('**** **** **** 0633', 1, isVisa: true),
            const SizedBox(height: 16),
            _buildPaymentCard('**** **** **** 0608', 2, isVisa: true),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  const Icon(Icons.fingerprint, size: 64, color: Colors.blue),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _authenticate,
                    child: const Text(
                      'Confirm with Touch ID',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: Text(actionText),
        ),
      ],
    );
  }

  Widget _buildAddressCard(String address, int index) {
    final isSelected = _selectedAddress == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedAddress = index),
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(address),
              if (isSelected)
                const Icon(Icons.check, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(String cardNumber, int index, {bool isVisa = false}) {
    final isSelected = _selectedPayment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (isVisa)
                    const Text(
                      'VISA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  const SizedBox(width: 16),
                  Text(cardNumber),
                ],
              ),
              if (isSelected)
                const Icon(Icons.check, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
