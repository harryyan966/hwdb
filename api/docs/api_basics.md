# HWDB Api Basics

Every response is just `event` and `data`
- when there's auth, there's `token`
- when there's error, there's `error`

a typical successful response body look like this
```json
{
    "event": "gotUsers",
    "data": {
        "users": [
            {
                "id": "userid",
                "name": "username",
                "role": "admin",
                "profileImageUrl": "https://fastly.picsum.photos/id/50/4608/3072.jpg"
            },
            ...
        ],
        "hasMore": false
    }
}
```

a typical error response body look like this
```json
{
    "error": "permissionDenied"
}
```

a typical validation failure response body look like this
```json
{
    "error": "validationError",
    "data": {
        "name": {
            "code": "duplicated",
            "detail": "userName",
        },
        "password": {
            "code": "tooWeak",
        }
    }
}
```

Next section: [auth api](auth_api.md)