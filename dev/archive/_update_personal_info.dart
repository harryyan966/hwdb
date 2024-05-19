  // final newUser = await context.db.collection('users').findAndModify(
  //   query: {'_id': userId},
  //   update: {
  //     r'$set': {
  //       if (name != null) 'name': name,
  //       if (newPassword != null) 'password': newPassword,
  //       if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
  //     },
  //   },
  //   returnNew: true,
  //   fields: projections.user,
  // );
  // if (newUser == null) {
  //   throw Exception('Nothing is updated.');
  // }