import 'package:firebase_database/firebase_database.dart';

class Todo {
  String key;
  String userId;
  String signin;
  String signout;

  Todo(this.userId, this.signin, this.signout);

  Todo.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userId = snapshot.value["userId"],
        signin = snapshot.value["signin"] ?? '',
        signout = snapshot.value["signout"] ?? '';
  toJson() {
    return {
      "userId": userId,
      "signin": signin,
      "signout": signout,
    };
  }
}
