import 'package:flutter/material.dart';

import '../colors/colors.dart';

class CreateNameDialog extends StatefulWidget {
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
  State<CreateNameDialog> createState() => _CreateNameDialogState();
}

class _CreateNameDialogState extends State<CreateNameDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.lightBlue,
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name cannot be empty';
            }
            return null;
          },
          style: const TextStyle(color: Colors.white),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.pink, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, nameController.text);
            }
          },
          child: const Text(
            'Save',
            style: TextStyle(color: AppColors.pink, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
