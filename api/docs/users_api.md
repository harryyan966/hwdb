# HWDB Users Api

## `GET /users`
gets users

### Requires

```json
{
    "qargs": {
        "start": int?,
        "count": int?,
        "name": String?,
        "role": UserRole?
    }
}
```

### Returns
```json
{
    "event": "gotUsers",
    "data": {
        "users": [
            {
                "id": String,
                "name": String,
                "role": UserRole,
                "profileImageUrl": String?
            },
            ...
        ],
        "hasMore": bool
    }
}
```

## `POST /users`
creates a user

### Requires

```json
{
    "name": String,
    "role": UserRole,
    "password": String,
    "profileImage": File?
}
```

### Returns
```json
{
    "id": String,
    "name": String,
    "role": UserRole,
    "profileImageUrl": String?
}
```

## `GET /users/:id`
gets a specific user

## Requires
```json
{}
```

### Returns
```json
{
    "event": "gotUser",
    "data": {
        "id": String,
        "name": String,
        "role": UserRole,
        "profileImageUrl": String?
    }
}
```

## `PATCH /users/:id`
updates a user

### Requires

```json
{
     "body": {
        "name": String?,
        "role": UserRole?,
        "password": String?,
     },
    "files": {
        "profileImage": File?
    }
}
```

### Returns
```json
{
    "event": "updatedUser",
    "data": {
        "id": String,
        "name": String,
        "role": UserRole,
        "profileImageUrl": String?
    }
}
```

## `DELETE /users/:id`
deletes a user

### Requires

```json
{}
```

### Returns
```json
{
    "event": "deletedUser",
    "data": {
        "id": String,
        "name": String,
        "role": UserRole,
        "profileImageUrl": String?
    }
}
```

Previous section: [auth api](auth_api.md)

Next Section: [courses api](courses_api.md)