import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.green), home: TaskCheckList());
  }
}

class TaskCheckList extends StatefulWidget {
  @override
  TaskCheckListState createState() {
    return TaskCheckListState();
  }
}

class TaskCheckListState extends State<TaskCheckList> {
  var num = 6;
  var checked = false;

  Widget addhabit() {
    return IconButton(
      onPressed: () {
        setState(() {
          num++;
          (context as Element).reassemble();
        });
      },
      icon: Icon(Icons.add),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: num,
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        return _buildRow();
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.black, height: 20, thickness: 3, endIndent: 30),
    );
  }

  Widget _buildRow() {
    return TextField(
        decoration: InputDecoration(
            hintText: 'Enter a habit',
            // delete
            suffixIcon: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                num--;
                (context as Element).reassemble();
              },
            ),
            //check
            icon: IconButton(
                icon: Icon(
                  (checked) ? Icons.check_box : Icons.check_box_outline_blank,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    if (checked) {
                      checked = false;
                    } else
                      checked = true;
                  });
                  print(checked);
                  (context as Element).reassemble();
                })));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('BareBones Habit Tracker')),
      body: _buildList(),
      floatingActionButton: addhabit(),
    );
  }
}
