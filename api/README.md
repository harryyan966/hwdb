A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

踩坑记录

1. errorhandler
errorhandler不能直接
```dart
try {
    return handler(context);
} catch (e) {
    // do something
}
```
需要await
```dart
try {
    return await handler(context);
} catch (e) {
    // do something
}
```
2. formdata
如果直接jsondecode会出现{"name": "\"Harry\""}这样双引号也包括在map里的情况