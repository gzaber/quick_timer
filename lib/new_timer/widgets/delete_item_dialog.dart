import 'package:flutter/material.dart';

class DeleteItemDialog extends StatelessWidget {
  const DeleteItemDialog({
    Key? key,
    required this.itemName,
  }) : super(key: key);

  final String itemName;

  static Future<bool?> show(BuildContext context, {required String itemName}) {
    return showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (_) => DeleteItemDialog(itemName: itemName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF343D58),
      content: Text(
        'Delete $itemName?',
        style: const TextStyle(color: Colors.white),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop<bool>(context, false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop<bool>(context, true),
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
