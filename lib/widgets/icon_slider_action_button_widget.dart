import 'package:FirebaseDemoApp/api/todo_api.dart';
import 'package:FirebaseDemoApp/model/todo_model.dart';
import 'package:FirebaseDemoApp/notifire/todo_notifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class IconSliderActionButtonWidget extends StatefulWidget {
  final data;
  final bool isUpdate;

  IconSliderActionButtonWidget({Key key, this.data, this.isUpdate})
      : super(key: key);

  @override
  _IconSliderActionButtonWidgetState createState() =>
      _IconSliderActionButtonWidgetState();
}

class _IconSliderActionButtonWidgetState
    extends State<IconSliderActionButtonWidget> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  Todo _currentTodo;
  TextEditingController _noteField = new TextEditingController();

  @override
  void initState() {
    super.initState();
    TodoNotifier todoNotifier =
        Provider.of<TodoNotifier>(context, listen: false);
    if (todoNotifier.currentTodo != null) {
      _currentTodo = todoNotifier.currentTodo;
    } else {
      _currentTodo = widget.data;
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
    TodoNotifier todoNotifier = Provider.of<TodoNotifier>(context);

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

    // TodoNotifier todoNotifier = Provider.of<TodoNotifier>(context);
    getTodo(todoNotifier);
    Future<void> _refreshList() async {
      getTodo(todoNotifier);
    }

    void _showSnackBar(BuildContext context, String text) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
    }

    _onTodoDeleted(Todo todo) {
      todoNotifier.deleteTodo(widget.data);
    }

    return IconSlideAction(
      caption: widget.isUpdate ? 'Edit' : 'Delete',
      color: widget.isUpdate ? Colors.blue : Colors.red,
      icon: widget.isUpdate ? Icons.archive : Icons.delete,
      onTap: () => {
        // _showSnackBar(context, 'Delete'),
        if (widget.isUpdate)
          {
            showAddNote(widget.isUpdate),
            _showSnackBar(context, 'Edited'),
          }
        else
          {
            deleteTodo(widget.data, _onTodoDeleted),
            _showSnackBar(context, 'Delete'),
          }
      },
    );
  }
}

// import 'package:FirebaseDemoApp/api/todo_api.dart';
// import 'package:FirebaseDemoApp/model/todo_model.dart';
// import 'package:FirebaseDemoApp/notifire/todo_notifire.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:provider/provider.dart';
//
// class IconSliderActionButtonWidget extends StatefulWidget {
//   final data;
//   final bool isUpdate;
//
//   IconSliderActionButtonWidget({Key key, this.data, this.isUpdate}) : super(key: key);
//
//   @override
//   _IconSliderActionButtonWidgetState createState() =>
//       _IconSliderActionButtonWidgetState();
// }
//
// class _IconSliderActionButtonWidgetState
//     extends State<IconSliderActionButtonWidget> {
//   //
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   TodoNotifier todoNotifier =
//   //   Provider.of<TodoNotifier>(context, listen: false);
//   //   if (todoNotifier.currentTodo != null) {
//   //     _currentTodo = widget.data;
//   //   } else {
//   //     _currentTodo = Todo();
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     TodoNotifier todoNotifier = Provider.of<TodoNotifier>(context);
//
//     void _showSnackBar(BuildContext context, String text) {
//       Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
//     }
//
//     _onTodoDeleted(Todo todo) {
//       todoNotifier.deleteTodo(widget.data);
//     }
//
//     return IconSlideAction(
//       caption: 'Delete',
//       color: Colors.red,
//       icon: Icons.delete,
//       onTap: () => {
//         _showSnackBar(context, 'Delete'),
//         if (widget.isUpdate == false){
//           deleteTodo(widget.data, _onTodoDeleted)
//         } else {
//
//         }
//       },
//     );
//   }
// }
