import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class CreatedUsersLabel extends StatelessWidget {
  const CreatedUsersLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(Spacing.l),
      child: Text(
        l10n.formLabel_CreatedUsers,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
