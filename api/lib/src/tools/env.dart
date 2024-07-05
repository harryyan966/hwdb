import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'TOKEN_SECRET')
  static const String tokenSecret = _Env.tokenSecret;
  @EnviedField(varName: 'PRIVATE_KEY_PASSWORD')
  static const String privateKeyPassword = _Env.privateKeyPassword;
}
