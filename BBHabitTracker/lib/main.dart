import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
  var checkedDays = Map();
  List<bool> habitsCheck = <bool>[];

  Widget habitTools() {
    return ListView(
      children: [addHabit(), editHabits()],
    );
  }

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
    bool checked = false;
    if (habitsCheck.length < num) {
      habitsCheck.add(checked);
    }
    return CheckboxListTile(
        activeColor: Colors.black,
        controlAffinity: ListTileControlAffinity.leading,
        title: TextField(
          textInputAction: TextInputAction.done,
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
            markDay();
          });
        });
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
          if (checkedDays[day.day] == true) {
            return const Icon(Icons.check, color: Colors.green);
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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('BareBones Habit Tracker')),
      body: _buildList(),
      persistentFooterButtons:
          editable ? [addHabit(), removeHabit(), editHabits()] : [editHabits()],
      endDrawer: theChain(),
    );
  }

  void markDay() {
    print(habitsCheck);
    if (habitsCheck.contains(false) == false) {
      checkedDays[DateTime.now().day] = true;
    } else {
      checkedDays[DateTime.now().day] = false;
    }
  }
}
