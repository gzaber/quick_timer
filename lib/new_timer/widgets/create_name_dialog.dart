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
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF343D58),
      content: TextField(
        controller: nameController,
        style: const TextStyle(color: Colors.white),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, nameController.text),
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
