import 'package:FirebaseDemoApp/model/todo_model.dart';
import 'package:FirebaseDemoApp/notifire/todo_notifire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

getTodo(TodoNotifier todoNotifier) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Todos').get();

  List<Todo> _todoList = [];

  snapshot.docs.forEach((document) {
    Todo todo = Todo.fromMap(document.data());
    _todoList.add(todo);
  });

  todoNotifier.todoList = _todoList;
}

uploadTodo(
  Todo todo,
  bool isUpdating,
  Function todoUploaded,
) async {
  CollectionReference todoRef = FirebaseFirestore.instance.collection('Todos');
  if (isUpdating) {
    await todoRef.doc(todo.id).update(todo.toMap());
    todoUploaded(todo);
  } else {
    DocumentReference documentRef = await todoRef.add(todo.toMap());
    todo.id = documentRef.id;
    await documentRef.set(todo.toMap(), SetOptions(merge: true));
    todoUploaded(todo);
  }
}

deleteTodo(
  Todo todo,
  Function todoDeleted,
) async {
  await FirebaseFirestore.instance.collection('Todos').doc(todo.id).delete();
  todoDeleted(todo);
}
