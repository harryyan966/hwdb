import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SET HYDRATED BLOC STORAGE
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // SET SHARED PREFERENCE CACHE
  // TODO: REPLACE WITH HYDRATED BLOC OR HIVE CACHE??
  final sharedPreferences = await SharedPreferences.getInstance();

  final httpClient = HwdbHttpClient(
    localCache: sharedPreferences,
    apiUrl: '62.234.71.227:8080',
    useHttps: false,
  );

  runApp(App(httpClient: httpClient));
}
