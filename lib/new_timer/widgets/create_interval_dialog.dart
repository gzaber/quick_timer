import 'package:flutter/material.dart';

class CreateIntervalDialog extends StatefulWidget {
  const CreateIntervalDialog({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  static Future<int?> show(BuildContext context, {required String title}) {
    return showDialog<int>(
      context: context,
      useRootNavigator: false,
      builder: (_) => CreateIntervalDialog(title: title),
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
      title: Text(widget.title),
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
                width: 50,
                color: activeIndex == index ? Colors.teal : Colors.pink,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(child: Text('${index + 1}')),
              ),
            );
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, activeIndex + 1),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
