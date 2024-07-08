import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'SECURE_STORAGE_KEY')
  static const String secureStorageKey = _Env.secureStorageKey;
}
