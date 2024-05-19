  // // Get the user to be deleted from the database.
  // final getUserRes = await context.db.collection('users').modernFindOne(
  //   filter: {'_id': id},
  //   projection: Projections.user,
  // );
  // final user = getUserRes;

  // if (user == null) {
  //   throw NotFound('user');
  // }