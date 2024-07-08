import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:hw_dashboard/env.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:path_provider/path_provider.dart';

const apiHost = '62.234.71.227';
const apiPort = 8888;

Future<void> main() async {
  print('RUNNING HWDB IN DEBUG MODE.');

  WidgetsFlutterBinding.ensureInitialized();

  // SET HYDRATED BLOC STORAGE
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // SET SHARED PREFERENCE CACHE
  await EncryptedSharedPreferences.initialize(Env.secureStorageKey);
  final sharedPreferences = EncryptedSharedPreferences.getInstance();

  final httpClient = HwdbHttpClient(
    localCache: sharedPreferences,
    apiUrl: '$apiHost:$apiPort',
    useHttps: false,
  );

  runApp(App(httpClient: httpClient));
}
