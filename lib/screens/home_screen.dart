import 'package:FirebaseDemoApp/api/todo_api.dart';
import 'package:FirebaseDemoApp/auth/firebase_auth.dart';
import 'package:FirebaseDemoApp/model/todo_model.dart';
import 'package:FirebaseDemoApp/notifire/todo_notifire.dart';
import 'package:FirebaseDemoApp/widgets/icon_slider_action_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  Todo _currentTodo;
  bool isUpdate = false;
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

  _saveTodo(context, bool isUpdate) {
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
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    void showAddNote(bool isUpdate) {
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
                      Navigator.pop(context);
                      _saveTodo(context, isUpdate);
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
          showAddNote(false);
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
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        title:
                            Text('${todoNotifier.todoList[index].description}'),
                      ),
                    ),
                    actions: <Widget>[
                      IconSliderActionButtonWidget(
                        data: todoNotifier.todoList[index],
                        isUpdate: true,
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSliderActionButtonWidget(
                        data: todoNotifier.todoList[index],
                        isUpdate: false,
                      )
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
