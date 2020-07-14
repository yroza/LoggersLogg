import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loggers_logg/model/data.dart';
import 'dart:async';
import 'package:loggers_logg/services/auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> _todoList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StreamSubscription<Event> _onTodoAddedSubscription;

  Query _todoQuery;

  @override
  void initState() {
    super.initState();

    _todoList = new List();
    _todoQuery = _database.reference().child("todo").orderByChild("userId");
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    super.dispose();
  }

  onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget showTodoList() {
    if (_todoList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _todoList[index].key;
            // String subject = _todoList[index].subject;
            String userId = _todoList[index].userId;
            String signin = _todoList[index].signin;
            String signout = _todoList[index].signout;
            // bool completed = _todoList[index].completed;
            return Card(
                shadowColor: Colors.grey[350],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Text(
                        userId,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Text('signin - $signin'),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Text('signout - $signout ?? none'),
                    ),
                  ],
                ));
          });
    } else {
      return Center(
          child: Text(
        "Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('User'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: signOut)
        ],
      ),
      body: showTodoList(),
    );
  }
}
