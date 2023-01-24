import 'package:flutter/material.dart';

import '../colors/colors.dart';

class CreateIntervalDialog extends StatefulWidget {
  const CreateIntervalDialog({
    Key? key,
    required this.title,
    required this.confirmButtonText,
    required this.declineButtonText,
  }) : super(key: key);

  final String title;
  final String confirmButtonText;
  final String declineButtonText;

  static Future<int?> show(
    BuildContext context, {
    required String title,
    required String confirmButtonText,
    required String declineButtonText,
  }) {
    return showDialog<int>(
      context: context,
      useRootNavigator: false,
      builder: (_) => CreateIntervalDialog(
        title: title,
        confirmButtonText: confirmButtonText,
        declineButtonText: declineButtonText,
      ),
    );
  }

  @override
  State<CreateIntervalDialog> createState() => _CreateIntervalDialogState();
}

class _CreateIntervalDialogState extends State<CreateIntervalDialog> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF343D58),
      content: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 60,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  activeIndex = index;
                });
              },
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  color: activeIndex == index
                      ? AppColors.pink
                      : AppColors.lightBlue,
                  border: Border.all(
                    color: activeIndex == index ? AppColors.pink : Colors.white,
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(
            widget.declineButtonText,
            style: const TextStyle(color: AppColors.pink, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, activeIndex + 1),
          child: Text(
            widget.confirmButtonText,
            style: const TextStyle(color: AppColors.pink, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
