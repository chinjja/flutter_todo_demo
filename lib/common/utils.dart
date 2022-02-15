import 'package:flutter/material.dart';

void showSnackbar(
  BuildContext context,
  String content, {
  SnackBarAction? action,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger != null) {
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(content),
        action: action,
      ),
    );
  }
}
