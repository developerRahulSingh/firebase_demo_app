import 'package:FirebaseDemoApp/api/todo_api.dart';
import 'package:FirebaseDemoApp/auth/firebase_auth.dart';
import 'package:FirebaseDemoApp/model/todo_model.dart';
import 'package:FirebaseDemoApp/notifire/todo_notifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  Todo _currentTodo;
  bool isUpdate;
  TextEditingController _noteField = new TextEditingController();

  @override
  void initState() {
    super.initState();
    TodoNotifier todoNotifier =
        Provider.of<TodoNotifier>(context, listen: false);
    if (todoNotifier.currentTodo != null) {
      _currentTodo = todoNotifier.currentTodo;
    } else {
      _currentTodo = Todo();
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _noteField,
      decoration: InputDecoration(labelText: "description"),
      initialValue: _currentTodo.description,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentTodo.description = value;
      },
    );
  }

  _saveTodo(context) {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();
    uploadTodo(_currentTodo, isUpdate, _onTodoUploaded);
  }

  _onTodoUploaded(Todo todo) {
    TodoNotifier todoNotifier =
        Provider.of<TodoNotifier>(context, listen: false);
    todoNotifier.addTodo(todo);
    Navigator.pop(context);
  }

  _onTodoDeleted(Todo todo) {
    TodoNotifier todoNotifier = Provider.of<TodoNotifier>(context);
    print('todoNotifier ==>> $todoNotifier');
    todoNotifier.deleteTodo(todo);
    Navigator.pop(context);
    print('todoNotifier ==>> $todo');
  }

  @override
  Widget build(BuildContext context) {
    void showAddNote() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: SimpleDialog(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(
                    "Add Todo",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 25,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              children: [
                Form(
                  key: _formKey,
                  autovalidate: true,
                  child: _buildNameField(),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Add"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      _saveTodo(context);
                    },
                  ),
                )
              ],
            ),
          );
        },
      );
    }

    TodoNotifier todoNotifier = Provider.of<TodoNotifier>(context);
    getTodo(todoNotifier);
    Future<void> _refreshList() async {
      getTodo(todoNotifier);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Todo List'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: () {
                context.read<FirebaseAuthService>().signOut();
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print("Button Pressed");
          showAddNote();
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.4,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: todoNotifier.todoList.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 2.0,
                    ),
                    child: SwipeActionCell(
                      key: ObjectKey(todoNotifier.todoList[index].description),
                      trailingActions: <SwipeAction>[
                        SwipeAction(
                            title: "Edit",
                            onTap: (CompletionHandler handler) {
                              uploadTodo(
                                  todoNotifier.currentTodo, true,_onTodoUploaded);
                            },
                            color: Colors.red),
                      ],
                      leadingActions: <SwipeAction>[
                        SwipeAction(
                            title: "Delete",
                            onTap: (CompletionHandler handler) {
                              deleteTodo(
                                  todoNotifier.currentTodo, _onTodoDeleted);
                            },
                            color: Colors.red),
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              todoNotifier.todoList[index].description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                color: Colors.lightBlue,
                                child: MaterialButton(
                                  onPressed: () {
                                    print('Edit ==>> ');
                                    setState(() {
                                      isUpdate: true;
                                    });
                                    showAddNote();
                                  },
                                  child: Text(
                                    'Edit',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.red,
                                child: MaterialButton(
                                  onPressed: () {
                                    print(
                                        'Delete button pressed ==>> ${todoNotifier.currentTodo}');
                                    deleteTodo(todoNotifier.currentTodo,
                                        _onTodoDeleted);
                                  },
                                  child: Text(
                                    'Delete',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

//            Container(
//              height: MediaQuery.of(context).size.height / 1.4,
//              width: MediaQuery.of(context).size.width,
//              child: ListView(
//                children: todoNotifier.todoList.map((document) {
//                  return Padding(
//                    padding: EdgeInsets.only(
//                      left: 8.0,
//                      right: 8.0,
//                      bottom: 2.0,
//                    ),
//                    child: SwipeActionCell(
//                      key: ObjectKey(document.description),
//                      trailingActions: <SwipeAction>[
//                        SwipeAction(
//                            title: "Edit",
//                            onTap: (CompletionHandler handler) {
//                              deleteTodo(
//                                  todoNotifier.currentTodo, _onTodoDeleted);
//                            },
//                            color: Colors.red),
//                      ],
//                      leadingActions: <SwipeAction>[
//                        SwipeAction(
//                            title: "Delete",
//                            onTap: (CompletionHandler handler) {
//                              deleteTodo(
//                                  todoNotifier.currentTodo, _onTodoDeleted);
//                            },
//                            color: Colors.red),
//                      ],
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: [
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Text(
//                              document.description,
//                              maxLines: 2,
//                              overflow: TextOverflow.ellipsis,
//                            ),
//                          ),
////                          Row(
////                            children: [
////                              Container(
////                                color: Colors.lightBlue,
////                                child: MaterialButton(
////                                  onPressed: () {
////                                    print('Edit ==>> ');
////                                    deleteTodo(todoNotifier.currentTodo,
////                                        _onTodoDeleted);
////                                  },
////                                  child: Text(
////                                    'Edit',
////                                    overflow: TextOverflow.ellipsis,
////                                  ),
////                                ),
////                              ),
////                              Container(
////                                color: Colors.red,
////                                child: MaterialButton(
////                                  onPressed: () {
////                                    print('Delete ==>> ');
////                                    deleteTodo(todoNotifier.currentTodo,
////                                        _onTodoDeleted);
////                                  },
////                                  child: Text(
////                                    'Delete',
////                                    overflow: TextOverflow.ellipsis,
////                                  ),
////                                ),
////                              ),
////                            ],
////                          ),
//                        ],
//                      ),
//                    ),
//                  );
//                }).toList(),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}
