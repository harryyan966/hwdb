// import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';

void showSimpleDialog(
  BuildContext context, {
  required String title,
  Widget? content,
  bool dismissible = true,
}) {
  showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => AlertDialog.adaptive(
            title: Text(title),
            content: content,
          ));
  // showDialog(
  //   context: context,
  //   barrierDismissible: dismissible,
  //   builder: (context) => Dialog(
  //     child: Padding(
  //       padding: const EdgeInsets.all(Spacing.xl),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             title,
  //             style: Theme.of(context).textTheme.titleLarge,
  //           ),
  //           if (content != null) SizedBox(height: Spacing.xl),
  //           if (content != null) content,
  //         ],
  //       ),
  //     ),
  //   ),
  // );
}
