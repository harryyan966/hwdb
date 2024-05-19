import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';

void showSimpleDialog(
  BuildContext context, {
  required String title,
  Widget? content,
}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (content != null) SizedBox(height: Spacing.m),
            if (content != null) content,
          ],
        ),
      ),
    ),
  );
}
