# HWDB Auth Api

## `POST /auth/login`
logs the user in

```dart
// request
final res = await client.post('auth/login', {
    'username': username,
    'password': password
});

// good result
if (Events.loggedIn.matches(res['event'])) {
    final data = res['data'];
    String id = data['id'];
    String name = data['name'];
    UserRole role = data['role'];
    String profileImageUrl = data['profileImageUrl'];
}

// bad result
if (Errors.invalidCredentials.matches(res['error'])) {
    final data = res['data'];
}
```

### Returns

```dart
"token" + 

String id
String name
UserRole role
String profileImageUrl
```

- The response contains a `token` field that contains the auth token.
- Auth tokens can help the server identify the user in subsequent requests
- Auth tokens will expire in 2 hours

## `POST /auth/logout`
logs the user out

### Requires

nothing

### Returns

nothing

- The client should remove the auth token cache when it receives the `auth.logged-out` event

Previous section: [api basics](api_basics.md)

Next section: [users api](users_api.md)