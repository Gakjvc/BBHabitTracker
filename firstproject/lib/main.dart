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
  List glist = <bool>[];

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
          (context as Element).reassemble();
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
        return _buildRow(index);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.black, height: 20, thickness: 3, endIndent: 30),
    );
  }

  Widget _buildRow(int indx) {
    bool checked = false;
    glist.add(checked);
    return CheckboxListTile(
        activeColor: Color.fromARGB(255, 248, 17, 0),
        controlAffinity: ListTileControlAffinity.leading,
        title: TextField(
          maxLines: null,
          decoration: const InputDecoration(
            hintText: "Enter a habit...",
          ),
          enabled: editable,
        ),
        value: glist[indx],
        onChanged: (value) {
          setState(() {
            glist[indx] = value!;
            print(glist[indx]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('BareBones Habit Tracker')),
      body: _buildList(),
      floatingActionButton: edithabits(),
    );
  }
}
