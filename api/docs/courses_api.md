# HWDB Courses Api

## `GET /courses`
gets courses

### Requires
```json
{
    "start": int?,
    "count": int?,
    "name": String?
}
```

### Returns
```json
{
    "courses": List<CourseInfo>,
    "hasMore": bool
}
```

## `POST /courses`
creates a course

### Requires
```json
{
    "name": String,
    "year": int,
    "teacherId": String,
    "studentIds": List<String>,
    "assignments": List<Assignment>,
    "score": Scores,
}
```

### Returns
```json
void
```

## `PATCH /courses/:id`
updates a course

### Requires
```json
{
    "name": String,
    "teacherId": String, 
    "grade": Grade,
    "year": int,
}
```

### Returns
```json
{
    "id": int,
}
```

## `DELETE /courses/:id`
deletes a specific course

### Requires
```json
{
    "id": String,
}
```

### Returns
```json
{
    "id": int,
}
```

## `GET /courses/:id/scores`
gets the scoreboard of a specific course

### Requires
```json
{
    "name": String,
    "year": int,
    "teacher": int?, 
}
```

### Returns
```json
{
    "scoreBoard": List<score>,
}
```

## `GET /courses/:id/scores/:studentId`
gets the score list of a specific student of a specific course

### Requires
```json
{}
```

### Returns
```json
{
    "scores": Map<String, double?>,
    "assignments": List<Assignment>,
}
```

## `PUT /courses/:id/scores`
replaces the scoreboard of a specific course

### Requires
```json
{
    "name": String, 
    "year": int?,
    "teacher": String,
    "scoreBoard": scoreBoard,
}
```

### Returns
```json
{
    "field": void
}
```

## `PATCH /courses/:id/scores`
updates a score of a course

### Requires
```json
{
    "studentId": String,
    "assignmentId": String,
    "score": double?
}
```

### Returns
```json
{
    "field": void
}
```

## `POST /courses/:id/assignments`
creates an assignment for a course

### Requires
```json
{
    "assignmentName": String,
    "dueTime": double,
    "assignmentScore": {"Student": double},
    "assignmentBoard": List<assignmentScore>,
    
}
```

### Returns
```json
{
    "assignmentId": int,
}
```

## `PATCH /courses/:id/assignments/:assignmentId`
updates an assignment

### Requires
```json
{
    "assignmentName": String,
    "type": String,
    "dueDate": int,
}
```

### Returns
```json
{
    "field": void,
}
```

## `DELETE /courses/:id/assignments/:assignmentId`
deletes an assignment

### Requires
```json
{
    "assignmentName": String,
    "dueTime": double?,
}
```

### Returns
```json
{
    "assignmentName": String,
}
```

## `GET /courses/:id/students`
get course students

### Requires
```json
{}
```

### Returns
```json
{
    "students": List<User>,
}
```


## `PUT /courses/:id/students`
update student list

### Requires
```json
{
    "studentIds": List<String>,
}
```

### Returns
```json
{
    "studentId": String,
}
```

## `POST /courses/:id/finalscores`
publish final score of course to the public (to be implemented after completion of homeroom module)

### Requires
```json
{
    "name": String,
    "year": int,
    "teacherId": String?,
    "id": int?,
}
```

### Returns
```json
{
    "scoreBoard": List<score>,
}
```

## `PATCH /courses/:id/finalscores`
calculates final score of course

### Requires
```json
{
    "finalScores": Map<String, double?>,
}
```

### Returns
```json
{
    "finalScore": double,
}
```

...more to do

Previous section: [users api](users_api.md)