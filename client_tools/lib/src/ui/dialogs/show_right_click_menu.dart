// SHOWS A RIGHT CLICK MENU
import 'package:flutter/material.dart';

void showRightClickMenu(BuildContext context, TapDownDetails details, List<PopupMenuEntry<void>> items) {
  final position = details.globalPosition;
  final menuPosition = RelativeRect.fromRect(
    Rect.fromPoints(position, position),
    Offset.zero & Size.infinite,
  );

  showMenu<void>(
    popUpAnimationStyle: AnimationStyle.noAnimation,
    context: context,
    useRootNavigator: true,
    position: menuPosition,
    items: items,
  );
}
