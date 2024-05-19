import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:hw_dashboard/course_search/view/manage_courses_page.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/user_search/user_search.dart';

class AdminSection extends StatelessWidget {
  const AdminSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      children: [
        ListTile(
          title: Text(l10n.linkLabel_ManageUsers),
          onTap: () => context.nav.push(ManageUsersPage.route()),
        ),
        ListTile(
          title: Text(l10n.linkLabel_ManageCourses),
          onTap: () => context.nav.push(ManageCoursesPage.route()),
        )
      ],
    );
  }
}
