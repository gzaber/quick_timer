import 'package:flutter/material.dart';

import '../colors/colors.dart';

class DeleteItemDialog extends StatelessWidget {
  const DeleteItemDialog({
    Key? key,
    required this.title,
    required this.contentText,
    required this.confirmButtonText,
    required this.declineButtonText,
  }) : super(key: key);

  final String title;
  final String contentText;
  final String confirmButtonText;
  final String declineButtonText;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String contentText,
    required String confirmButtonText,
    required String declineButtonText,
  }) {
    return showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (_) => DeleteItemDialog(
        title: title,
        contentText: contentText,
        confirmButtonText: confirmButtonText,
        declineButtonText: declineButtonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.lightBlue,
      content: Text(
        contentText,
        style: const TextStyle(color: Colors.white),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            declineButtonText,
            style: const TextStyle(color: AppColors.pink, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmButtonText,
            style: const TextStyle(color: AppColors.pink, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
