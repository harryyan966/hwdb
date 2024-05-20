# Bugs and the ways to solve them

## Not Solved

## in the previous scoreboard implementation, `TextField` is focused but the cursor is not showing and text is not being edited.

## delete course is not working

## THE STICKY TABLE TITLE AND CONTENT MAY GO OUT OF SYNC

## Solved

## `Localizations.of<AppLocalization>(context)` returns null
    - l10n cannot be called before building material app
        - SOL use `rootNavigatorKey.currentContext!` instead of `context` before `MaterialApp` is called

---

## courses don't show up, throws `'!_debugDuringDeviceUpdate': is not true` and Homepage Scaffold error
    - SOL? RESTART APP

---

## `Unhandled Exception: type 'int' is not a subtype of type 'Iterable<dynamic>'`
    - http query parameters must all be string
    - > or more technically, `Iterable<dynamic>`, but `String` is the most prominent kind of `Iterable<dynamic>` the query params take
        - SOL convert everything to string in the http client

---

## `Null is not subtype of Map<String, dynamic>` when getting course
    - teacher is not sent as teacher but instead sent as teacherId
        - SOL use an aggregation pipeline `$lookup`

    - teacher is not projected as proper user
        - SOL use a `pipeline` parameter in `$lookup`

---

## `Unrecognized pipeline stage name: '$unwind'`
    - there are invisible characters in the query
        - SOL retype the query

---

## `MongoDart Error: Received pipeline is "List<Map<String, Object?>>"`
    - aggregations must not contain ANY null stuff
        - SOL use `if (item != null) {r'$query': item}`

---

## `type '_Map<String, Object>' is not a subtype of type 'Map<String, int>' of 'function result'`
    - somehow using only ints in a projection could cause this error
        - SOL explicitly cast projections that have only ints as `<String, Object>{}`

---

## `Invalid $project :: caused by :: Cannot do exclusion on field _id in inclusion projection`
    - SOL? RESTART APP

---

## `Cannot modify an unmodifiable list` in scoreboard page
    - `sortedStudents` used `..sort` on `students`, which is unmodifyable as it is initialized as `const []`
        - SOL use `students.isEmpty ? [] : students..sort((a, b) => a.name.compareTo(b.name));`
        - > note that ..sort will modify the initial list as well

---

## `Incorrect use of ParentDataWidget.` in scoreboard page
    - these widgets must have a specific parent
        - SOL do not use `TableCell` widget outside a table widget

---

## loading overlay is not showing
    - if we do Cubit()..doSomething(), the first state will be emitted before the bloclistener is even built
        - SOL? didn't use loading overlay

---

## searching courses does not work
    - when searching courses the `start` param should not be the current course count but 0, as we want to search for all courses
        - SOL change `start` param to 0 in `searchCourses`

## `SubMenuButton` behaves weirdly, the menus don't hide
    - SOL used `PopupMenuButton` instead

## create assignment doesn't work
    - SOL? RELOAD APP

---

## validationErrorToString doesn't work
    - only `null` indicates an errorless state (empty string means there is an empty error)
        - SOL make it return `String?` instead of `String`
    - errors won't show up
        - SOL setState after receiving errors

---

## fonts cannot load
    - it looks like we cannot access fonts from another dart package (in this case `client_tools`)
        - SOL just put the font assets in the root package, don't play anything weird, just PLAIN, VANILLA, SIMPLE, STUPID

---

## student scoreboard not working
    - didn't configure the right route
    - assignmentids were not converted to string when we got data

---

## sometimes assignment names will duplicate
    - we ran the create assignment update ui function twice, once in the form page and once in the `push.then`
        - SOL remove the `createAssignment` update ui function in the form page
        - > this removed the need to pass the scoreboard cubit around too!

---

## delete assignment doesn't update ui
    - `context.select` only updates the variable only when the VARIABLE has changed.
        - SOL?? always create new lists instead of modifying old ones, performance doesn't matter

---

## admin user search doesn't work
    - cannot hit a render box with no size
        - SOL make rows in listtiles min size

## initial value not filled in text fields
    - `TextField` cannot do that without controllers
        - use `TextFormField.initialValue`

## year value always throws validation error even though it matches the conditions
    - the conditions were wrong in the server

## when appbar buttons have focus, you clicking on the editable scoreboard scores won't give it complete focus.
    - (?) construct a `FocusNode..requestFocus()` in every textfield

## `The following assertion was thrown while processing the key message handler:'package:flutter/src/rendering/editable.dart': Failed assertion: line 195 pos 12: 'isValid': is not true.`
    - (?) RELOAD APP

## Update Personal password is not working
    - the client is calling `updateUser` instead of `updatePersonalInfo`. The former requires one to be an admin.
    - merge `updateUser` and `updatePersonalInfo` into one function
    
## Exported excel is non-readable in dark mode
    - should set the text as `onSurface`

## git push doesn't work suddenly
    - don't know why but
    - `eval 'ssh-agent -s' && ssh-add ~/.ssh/id_ed25519`'