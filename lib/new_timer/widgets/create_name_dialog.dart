import 'package:flutter/material.dart';

class CreateNameDialog extends StatelessWidget {
  const CreateNameDialog({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  static Future<String?> show(BuildContext context, {required String title}) {
    return showDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (_) => CreateNameDialog(title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: nameController,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, nameController.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
