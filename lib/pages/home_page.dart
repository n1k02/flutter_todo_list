import 'package:flutter/material.dart';
import 'package:flutter_application_1/storage/db.dart';
import 'package:flutter_application_1/util/dialog_box.dart';
import 'package:flutter_application_1/util/todo_tile.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive 
  final _box = Hive.box('box');
  ToDoDB db = ToDoDB();

  @override
  void initState() {

    // if this is the 1st  time ever opening the app, then create default data
    if(_box.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.getData();
    }

    super.initState();
  }


  // text controller
  final _controller = TextEditingController();

  //checkbox func
  void checkboxHandle(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDB();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDB();
  }

  // create a new task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  // delete task
  void deleteTask (int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text('TO DO'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: createNewTask, child: Icon(Icons.add)),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
              taskName: db.toDoList[index][0],
              isTaskCompleted: db.toDoList[index][1],
              onChanged: ((value) => checkboxHandle(value, index)),
              deleteTask: (context) => deleteTask(index),
              );
        },
      ),
    );
  }
}
