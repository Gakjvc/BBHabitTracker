import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TaskCheckList());
  }
}

class TaskCheckList extends StatefulWidget {
  @override
  TaskCheckListState createState() {
    return TaskCheckListState();
  }
}

class TaskCheckListState extends State<TaskCheckList> {
  int num = 6;
  bool editable = false;
  bool checkeda = false;
  List<bool> habitscheck = <bool>[];
  var h;
  bool t = false;

  Widget habittools() {
    return ListView(
      children: [addhabit(), edithabits()],
    );
  }

  Widget edithabits() {
    return IconButton(
      onPressed: () {
        setState(() {
          editable = !editable;
        });
      },
      icon: Icon(Icons.edit),
    );
  }

  Widget addhabit() {
    return IconButton(
      onPressed: () {
        setState(() {
          num++;
        });
      },
      icon: const Icon(Icons.add),
    );
  }

  Widget removehabit(int index) {
    return IconButton(
        onPressed: () {
          setState(() {
            h.removeAt(index);
            habitscheck.removeAt(index);
            h = h;
            t = true;
          });
        },
        color: Colors.red,
        icon: const Icon(Icons.delete));
  }

  Widget _buildList() {
    if (t == false) {
      h = List<Widget>.generate(num, (int index) => _buildRow(index));
      print("VAI REMAR CONTRA A MARÉ");
    }
    return ListView(
      children: h,
      padding: const EdgeInsets.all(8),
    );
  }

  Widget _buildRow(int indx) {
    bool checked = false;
    habitscheck.add(checked);
    return CheckboxListTile(
        activeColor: Colors.black,
        controlAffinity: ListTileControlAffinity.leading,
        title: TextField(
          maxLines: null,
          decoration: const InputDecoration(
            hintText: "Enter a habit...",
          ),
          enabled: editable,
        ),
        value: habitscheck[indx],
        onChanged: (value) {
          setState(() {
            habitscheck[indx] = value!;
          });
        },
        secondary: editable ? removehabit(indx) : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('BareBones Habit Tracker')),
      body: _buildList(),
      persistentFooterButtons:
          editable ? [addhabit(), edithabits()] : [edithabits()],
    );
  }
}
