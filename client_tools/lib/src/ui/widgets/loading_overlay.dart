import 'package:flutter/material.dart';

void showLoadingOverLay(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.onInverseSurface,
      ),
    ),
  );
}
