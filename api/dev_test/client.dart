import 'client_helpers.dart';

Future<void> main() async {
  final client = HttpClient(
    apiUrl: 'localhost:8080',
    useHttps: false,
  );

  await client.post('auth/login', args: {
    'username': 'Harry',
    'password': '1234567890',
  });

  final courseId = '662f8c6378e4bf0258000000';
  final assignmentId = '6631f856ca4482946d000000';
  final r = await client.patch('courses/$courseId/assignments/$assignmentId', args: {
    'name': 'assignment1',
    'dueTime': '${DateTime.now().toIso8601String()}',
  });
  print(r);

  // res = await client.get('users');
  // print(res.pretty());

  // res = await client.get('users', {'name': 'Ma', 'limit': 1.toString()});
  // final id = res['data']['users'].first['id'];
  // res = await client.patch('users/$id', args: {
  //   'role': UserRole.admin.name,
  // });
  // res = await client.post('users', args: {
  //   'name': 'adm',
  //   'password': '12345678',
  //   'role': 'admin',
  // });
  // print(res.pretty());

  // res = await client.get('users', {});
}
