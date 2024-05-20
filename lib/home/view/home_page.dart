import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/account/view/account_section.dart';
import 'package:hw_dashboard/admin/admin.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/college_casino/view/college_casino_page.dart';
import 'package:hw_dashboard/course_search/course_search.dart';
import 'package:hw_dashboard/home/home.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabIndex = context.select((HomeCubit cubit) => cubit.state.tabIndex);
    final userRole = context.select((AppCubit cubit) => cubit.state.user.role);

    final l10n = context.l10n;

    final coursePage = _PageInfo(
      page: const CourseSearchSection(),
      pageTitle: l10n.pageTitle_Courses,
      navIcon: const Icon(Icons.abc),
      navActiveIcon: const Icon(Icons.abc_outlined),
      navLabel: l10n.navBarLabel_Courses,
    );
    final accountPage = _PageInfo(
      page: const AccountSection(),
      pageTitle: l10n.pageTitle_Account,
      navIcon: const Icon(Icons.account_box),
      navActiveIcon: const Icon(Icons.account_box_outlined),
      navLabel: l10n.navBarLabel_Account,
    );
    final adminPage = _PageInfo(
      page: const AdminSection(),
      pageTitle: l10n.pageTitle_Admin,
      navIcon: const Icon(Icons.settings),
      navActiveIcon: const Icon(Icons.settings_outlined),
      navLabel: l10n.navBarLabel_Admin,
    );
    final collegeCasinoPage = _PageInfo(
      page: const CollegeCasinoSection(),
      pageTitle: l10n.pageTitle_CollegeCasino,
      navIcon: const Icon(Icons.casino),
      navActiveIcon: const Icon(Icons.casino_outlined),
      navLabel: l10n.navBarLabel_CollegeCasino,
    );

    final pages = switch (userRole) {
      UserRole.none => throw Exception('EMPTY USERS SHOULD NOT BE HERE'),
      UserRole.student => [coursePage, collegeCasinoPage, accountPage],
      UserRole.teacher => [coursePage, accountPage],
      UserRole.admin => [coursePage, accountPage, adminPage],
    };

    final page = pages[tabIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(page.pageTitle),
        actions: [Assets.images.appLogo.image()],
      ),
      body: IndexedStack(
        index: tabIndex,
        children: pages.map((e) => e.page).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        onTap: (tabIndex) => context.read<HomeCubit>().setTab(tabIndex),
        items: [
          for (final page in pages)
            BottomNavigationBarItem(
              icon: page.navIcon,
              activeIcon: page.navActiveIcon,
              label: page.navLabel,
            ),
        ],
      ),
    );
  }
}

// Bundle object for page configurations
class _PageInfo {
  const _PageInfo({
    required this.page,
    required this.pageTitle,
    required this.navIcon,
    required this.navActiveIcon,
    required this.navLabel,
  });

  final Widget page;
  final String pageTitle;
  final Icon navIcon;
  final Icon navActiveIcon;
  final String navLabel;
}
