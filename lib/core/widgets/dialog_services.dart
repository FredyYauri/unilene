import 'package:flutter/material.dart';

enum DialogType { error, info, success, warning }

Future<void> showCustomDialog(BuildContext context, String message, DialogType type) {
  String title;
  Color titleColor;

  switch (type) {
    case DialogType.error:
      title = 'Error';
      titleColor = Colors.red;
      break;
    case DialogType.info:
      title = 'Información';
      titleColor = Colors.blue;
      break;
    case DialogType.success:
      title = 'Éxito';
      titleColor = Colors.green;
      break;
    case DialogType.warning:
      title = 'Advertencia';
      titleColor = Colors.orange;
      break;
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
