import 'package:hive/hive.dart';

class ToDoDB {
  
  List toDoList = [
    
  ];

  // reference the box
  final _box = Hive.box('box');

  // run this method of this is the 1st time ever opening this app
  void createInitialData() {
    toDoList = [
      ['Learn Flutter', false],
      ['Practice English', false],
    ];
  }

  // get data from db
  void getData () {
    toDoList = _box.get('TODOLIST');
  }

  // update the DB
  void updateDB () {
    _box.put('TODOLIST', toDoList);
  }
}
