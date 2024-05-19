// import 'package:client_tools/client_tools.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hw_dashboard/l10n/l10n.dart';
// import 'package:hw_dashboard/user_search/user_search.dart';
// import 'package:tools/tools.dart';

// class TeacherSearchBar extends StatefulWidget {
//   const TeacherSearchBar({super.key});

//   @override
//   State<TeacherSearchBar> createState() => _TeacherSearchBarState();
// }

// class _TeacherSearchBarState extends State<TeacherSearchBar> {
//   String keyword = '';

//   @override
//   Widget build(BuildContext context) {
//     final l10n = context.l10n;

//     return Padding(
//       padding: const EdgeInsets.all(Spacing.m),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: l10n.searchBarLabel_SearchUsers,
//               ),
//               onChanged: (value) => keyword = value,
//               onSubmitted: (_) => _submit(),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _submit,
//             child: Text(l10n.buttonLabel_Search),
//           ),
//         ],
//       ),
//     );
//   }

//   // WHEN THE USER SUBMITS A KEYWORD
//   void _submit() {
//     context.read<UserSearchCubit>().searchUsers(keyword, UserRole.teacher);
//   }
// }
