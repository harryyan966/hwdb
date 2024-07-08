import 'dart:io';

import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:hw_dashboard/env.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:path_provider/path_provider.dart';

const apiHost = '62.234.71.227';
const apiPort = 8080;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SET HYDRATED BLOC STORAGE
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // SET SHARED PREFERENCE CACHE
  await EncryptedSharedPreferences.initialize(Env.secureStorageKey);
  final sharedPreferences = EncryptedSharedPreferences.getInstance();

  // ACCEPT SELF-SIGNED SSL CERTIFICATE (FOR HTTPS SUPPORT)
  HttpOverrides.global = HWDBHttpOverrides();

  // SET UP HTTP(S) CLIENT
  final httpClient = HwdbHttpClient(
    localCache: sharedPreferences,
    apiUrl: '$apiHost:$apiPort',
    useHttps: true,
  );

  runApp(App(httpClient: httpClient));
}

class HWDBHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return host == apiHost && port == apiPort;
      };
  }
}
