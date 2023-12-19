import 'package:flutter/material.dart';

void showToast(
  context, {
  required String message,
  bool status = false,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final messenger = ScaffoldMessenger.of(context);

  messenger.showSnackBar(
    SnackBar(
      closeIconColor: Colors.white,
      dismissDirection: DismissDirection.horizontal,
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      backgroundColor: status ? colorScheme.primary : colorScheme.error,
      content: Text(message),
    ),
  );
}
