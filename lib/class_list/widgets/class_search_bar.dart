import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/class_list/class_list.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class ClassSearchBar extends StatefulWidget {
  const ClassSearchBar({super.key});

  @override
  State<ClassSearchBar> createState() => _ClassSearchBarState();
}

class _ClassSearchBarState extends State<ClassSearchBar> {
  String keyword = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(Spacing.m),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: l10n.searchBarLabel_SearchClasses,
              ),
              onChanged: (value) => keyword = value,
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: Spacing.m),
          ElevatedButton(
            onPressed: _submit,
            child: Text(l10n.buttonLabel_Search),
          ),
        ],
      ),
    );
  }

  // WHEN THE USER SUBMITS A KEYWORD
  void _submit() {
    context.read<ClassListCubit>().searchClasses(keyword);
  }
}
