// widgets/checkout_modal.dart
import 'package:flutter/material.dart';

class CheckoutModal extends StatefulWidget {
  final void Function(String address, String card) onConfirm;

  const CheckoutModal({super.key, required this.onConfirm});

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  final _addressController = TextEditingController();
  final _cardController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Введите данные'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Адрес доставки'),
          ),
          TextField(
            controller: _cardController,
            decoration: const InputDecoration(labelText: 'Номер карты'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm(
              _addressController.text.trim(),
              _cardController.text.trim(),
            );
            Navigator.pop(context);
          },
          child: const Text('Подтвердить'),
        )
      ],
    );
  }
}
