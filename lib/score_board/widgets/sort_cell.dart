import 'package:flutter/material.dart';

class SortControllerCell extends StatelessWidget {
  const SortControllerCell({
    required this.onPressed,
    required this.activated,
    required this.reverse,
    required this.child,
    this.iconColor,
    super.key,
  });

  final void Function() onPressed;
  final bool activated;
  final bool reverse;
  final Color? iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: onPressed,
            constraints: const BoxConstraints(),
            color: iconColor,
            icon: Icon(
              activated
                  ? reverse
                      ? Icons.trending_down
                      : Icons.trending_up
                  : Icons.trending_flat,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
