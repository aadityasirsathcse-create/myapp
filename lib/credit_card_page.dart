
import 'package:flutter/material.dart';

class CreditCard {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final String cardType;

  CreditCard({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    required this.cardType,
  });
}

class CreditCardPage extends StatefulWidget {
  final CreditCard? card;

  const CreditCardPage({super.key, this.card});

  @override
  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cardNumberController;
  late TextEditingController _cardHolderNameController;
  late TextEditingController _expiryDateController;
  late TextEditingController _cvvController;
  String _cardType = 'VISA';

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController(text: widget.card?.cardNumber);
    _cardHolderNameController =
        TextEditingController(text: widget.card?.cardHolderName);
    _expiryDateController = TextEditingController(text: widget.card?.expiryDate);
    _cvvController = TextEditingController(text: widget.card?.cvv);
    _cardType = widget.card?.cardType ?? 'VISA';
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card == null ? 'Add Card' : 'Edit Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 16) {
                    return 'Please enter a valid card number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cardHolderNameController,
                decoration: const InputDecoration(labelText: 'Card Holder Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the card holder name';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: const InputDecoration(labelText: 'MM/YY'),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$')
                                .hasMatch(value)) {
                          return 'Enter a valid date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(labelText: 'CVV'),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 3) {
                          return 'Enter a valid CVV';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newCard = CreditCard(
                      cardNumber: _cardNumberController.text,
                      cardHolderName: _cardHolderNameController.text,
                      expiryDate: _expiryDateController.text,
                      cvv: _cvvController.text,
                      cardType:
                          _cardType, // This could be determined from card number
                    );
                    Navigator.pop(context, newCard);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
