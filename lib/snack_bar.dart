import 'package:flutter/material.dart';

void showSnackBar({
  required final String text,
  required BuildContext context,
}) {
  final messenger = ScaffoldMessenger.of(context);

  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        text,
      ),
      backgroundColor: Colors.red,
    ),
  );
}
