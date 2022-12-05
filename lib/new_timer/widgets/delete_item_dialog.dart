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
      title: const Text('Delete'),
      content: Text('Delete $itemName?'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop<bool>(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop<bool>(context, true),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
