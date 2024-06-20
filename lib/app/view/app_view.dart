import 'package:client_tools/client_tools.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/login/login.dart';

class App extends StatelessWidget {
  const App({required this.httpClient, super.key});

  final HwdbHttpClient httpClient;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: httpClient),
      ],
      child: BlocProvider(
        create: (_) => AppCubit(),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select((AppCubit cubit) => cubit.state.themeMode);
    final language = context.select((AppCubit cubit) => cubit.state.language);
    final themeColor = context.select((AppCubit cubit) => cubit.state.themeColor);

    PlatformDispatcher.instance.onError = (error, st) {
      // SHOW DIALOG WHEN NETWORK FAILED
      // TODO: embed error detection in pages
      final l10n = rootNavigatorKey.currentContext!.l10n;

      if (error is NetworkFailure) {
        showSimpleDialog(
          rootNavigatorKey.currentContext!,
          dismissible: false,
          title: l10n.prompt_NetworkError,
          content: ElevatedButton(
            onPressed: () => rootNavigatorKey.currentContext!.nav.jump(LoginPage.route()),
            child: Text(l10n.buttonLabel_Ok),
          ),
        );
        return true;
      }

      // SHOW DIALOG IF SESSION EXPIRED
      if (error is SessionExpiredFailure) {
        showSimpleDialog(
          rootNavigatorKey.currentContext!,
          dismissible: false,
          title: l10n.prompt_SessionExpired,
          content: ElevatedButton(
            onPressed: () => rootNavigatorKey.currentContext!.nav.jump(LoginPage.route()),
            child: Text(l10n.buttonLabel_Ok),
          ),
        );

        return true;
      }

      // SHOW DIALOG IF SERVER FAILED
      if (error is ServerFailure) {
        showSimpleDialog(
          rootNavigatorKey.currentContext!,
          title: l10n.prompt_ServerFailure,
          content: ElevatedButton(
            onPressed: () => rootNavigatorKey.currentContext!.nav.jump(LoginPage.route()),
            child: Text(l10n.buttonLabel_Ok),
          ),
        );
      }

      showSimpleDialog(rootNavigatorKey.currentContext!,
          title: l10n.prompt_OtherFailure,
          content: Column(
            children: [
              Text(error.toString()),
              Text(st.toString()),
            ],
          ));
      return false;
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: rootNavigatorKey,
      themeMode: themeMode,
      theme: appLightTheme(themeColor),
      darkTheme: appDarkTheme(themeColor),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale.fromSubtags(languageCode: language.name),
      home: const LoginPage(),
      // home: const TestPage(child: EditPersonalInfoPlainForm()),
    );
  }
}
