
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/address_page.dart';

class ShippingPaymentPage extends StatefulWidget {
  final Address shippingAddress;
  final Address billingAddress;

  const ShippingPaymentPage({
    super.key,
    required this.shippingAddress,
    required this.billingAddress,
  });

  @override
  State<ShippingPaymentPage> createState() => _ShippingPaymentPageState();
}

class _ShippingPaymentPageState extends State<ShippingPaymentPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  late Address _selectedShippingAddress;
  late Address _selectedBillingAddress;
  int _selectedPayment = 1;

  @override
  void initState() {
    super.initState();
    _selectedShippingAddress = widget.shippingAddress;
    _selectedBillingAddress = widget.billingAddress;
  }

  void _navigateAndEditAddress(BuildContext context, Address currentAddress, Function(Address) onAddressChanged) async {
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
            _buildSectionHeader('Shipping Address', () {
              _navigateAndEditAddress(context, _selectedShippingAddress, (newAddress) {
                setState(() {
                  _selectedShippingAddress = newAddress;
                });
              });
            }),
            _buildAddressCard(
              '${_selectedShippingAddress.street}\n${_selectedShippingAddress.city} ${_selectedShippingAddress.state} ${_selectedShippingAddress.zipCode}',
              _selectedShippingAddress,
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Billing Address', () {
              _navigateAndEditAddress(context, _selectedBillingAddress, (newAddress) {
                setState(() {
                  _selectedBillingAddress = newAddress;
                });
              });
            }),
            _buildAddressCard(
              '${_selectedBillingAddress.street}\n${_selectedBillingAddress.city} ${_selectedBillingAddress.state} ${_selectedBillingAddress.zipCode}',
              _selectedBillingAddress,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Payment Method', () {}),
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

  Widget _buildSectionHeader(String title, VoidCallback onEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onEdit,
          child: const Text('Edit'),
        ),
      ],
    );
  }

  Widget _buildAddressCard(String address, Address currentAddress) {
    final isSelected = _selectedShippingAddress == currentAddress || _selectedBillingAddress == currentAddress;
    return GestureDetector(
      onTap: () => setState(() {
        if (currentAddress == _selectedShippingAddress) {
          // Handle shipping address selection
        } else {
          // Handle billing address selection
        }
      }),
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
