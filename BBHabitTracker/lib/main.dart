import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
  var checkedDays = Map<int, int>();
  var habits;
  List<String> habitSeparated = <String>[];
  var textController = TextEditingController();
  List<bool> habitsCheck = <bool>[];
  List<int> listHaCheck = <int>[];
  List<int> listDays = <int>[];
  List<int> listMonths = <int>[];

  Widget editHabits() {
    return IconButton(
      onPressed: () {
        setState(() {
          editable = !editable;
        });
      },
      icon: const Icon(Icons.edit),
    );
  }

  Widget addHabit() {
    return IconButton(
      onPressed: () {
        setState(() {
          num++;
        });
      },
      icon: const Icon(Icons.add),
    );
  }

  Widget removeHabit() {
    return IconButton(
        onPressed: () {
          setState(() {
            if (num > 0) num--;
            habitsCheck.removeLast();
            _markDay();
          });
        },
        color: Colors.red,
        icon: const Icon(Icons.delete));
  }

  Widget _buildList() {
    return ListView(
      children: List<Widget>.generate(num, (int index) => _buildRow(index)),
      padding: const EdgeInsets.all(8),
    );
  }

  Widget _buildRow(int indx) {
    if (habitsCheck.length < num) {
      bool checked = false;
      habitsCheck.add(checked);
    }

    return CheckboxListTile(
        activeColor: Colors.black,
        controlAffinity: ListTileControlAffinity.leading,
        title: TextField(
          controller: textController,
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            habits = habits + textController.text;
            textController.dispose();
            textController = TextEditingController();
          },
          maxLines: null,
          decoration: const InputDecoration(
            hintText: "Enter a habit...",
          ),
          enabled: editable,
        ),
        value: habitsCheck[indx],
        onChanged: (value) {
          setState(() {
            habitsCheck[indx] = value!;
            _markDay();
          });
        });
  }

  void _markDay() {
    if (habitsCheck.contains(false) == false) {
      checkedDays[DateTime.now().day] = DateTime.now().month;
    } else {
      checkedDays.remove(DateTime.now().day);
    }
  }

  Widget theChain() {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('BareBones Habit Calendar')),
      body: cal(),
    );
  }

  Widget cal() {
    String strDt = "20220402";
    DateTime parseDt = DateTime.parse(strDt);
    return TableCalendar(
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, focusedDay) {
          if (checkedDays.keys.contains(day.day) &&
              day.month == checkedDays[day.day]) {
            return const Icon(Icons.check,
                color: Color.fromARGB(255, 4, 184, 4));
          } else {
            return null;
          }
        },
      ),
      focusedDay: DateTime.now(),
      firstDay: parseDt,
      lastDay: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => FocusScope.of(context).unfocus()),
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text('BareBones Habit Tracker')),
          body: _buildList(),
          persistentFooterButtons: editable
              ? [
                  testSave(),
                  testRead(),
                  addHabit(),
                  removeHabit(),
                  editHabits()
                ]
              : [editHabits()],
          endDrawer: theChain(),
        ));
  }

  Widget testSave() {
    return IconButton(onPressed: () => _save(), icon: const Icon(Icons.save));
  }

  Widget testRead() {
    return IconButton(
        onPressed: () => _read(), icon: const Icon(Icons.read_more));
  }

  _read() async {
    int i = 0;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.txt');
      await file.readAsBytes();
      for (var item in listDays) {
        checkedDays[item] = listMonths[i];
        i++;
      }
      habitsCheck.clear();
      for (var item in listHaCheck) {
        if (item == 1) {
          habitsCheck.add(true);
        } else {
          habitsCheck.add(false);
        }
        (context as Element).reassemble();
      }
    } catch (e) {
      print("Couldn't read file");
    }
  }

  _save() async {
    listHaCheck.clear();
    for (var item in habitsCheck) {
      if (item == true) {
        listHaCheck.add(1);
      } else {
        listHaCheck.add(0);
      }
    }
    listMonths = List<int>.from(checkedDays.values);
    listDays = List<int>.from(checkedDays.keys);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');
    await file.writeAsBytes(listMonths);
    await file.writeAsBytes(listDays);
    await file.writeAsBytes(listHaCheck);
  }
}
