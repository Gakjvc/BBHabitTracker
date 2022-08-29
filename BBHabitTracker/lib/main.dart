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
  int numOfHabits = 6;
  bool editable = false;
  bool previouslyMarked = false;
  String habits = "çç";
  bool notFirst = false;
  List<String> habitsSeparated = <String>[];
  List<TextEditingController> textControllers = <TextEditingController>[];
  List<bool> habitsCheck = <bool>[];
  List<int> listHaCheck = <int>[];
  List<int> _days = <int>[];
  List<int> _months = <int>[];
  List<int> _years = <int>[];

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
          numOfHabits++;
        });
      },
      icon: const Icon(Icons.add),
    );
  }

  Widget removeHabit() {
    return IconButton(
        onPressed: () {
          setState(() {
            if (numOfHabits > 0) numOfHabits--;
            habitsCheck.removeLast();
            _markDay();
          });
        },
        color: Colors.red,
        icon: const Icon(Icons.delete));
  }

  Widget _buildList() {
    return ListView(
      children:
          List<Widget>.generate(numOfHabits, (int index) => _buildRow(index)),
      padding: const EdgeInsets.all(8),
    );
  }

  Widget _buildRow(int indx) {
    if (habitsCheck.length < numOfHabits) {
      bool checked = false;
      habitsCheck.add(checked);
      textControllers.add(TextEditingController());
      habitsSeparated.add(textControllers[indx].text);
    }

    return CheckboxListTile(
        activeColor: Colors.black,
        controlAffinity: ListTileControlAffinity.leading,
        title: TextField(
          controller: textControllers[indx],
          textInputAction: TextInputAction.done,
          onTap: () {
            habitsSeparated[indx] = (textControllers[indx].text);
          },
          onChanged: (change) {
            habitsSeparated[indx] = change;
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            habitsSeparated[indx] = (textControllers[indx].text);
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
      _days.add(DateTime.now().day);
      _months.add(DateTime.now().month);
      _years.add(DateTime.now().year);
      previouslyMarked = true;
    } else if (previouslyMarked) {
      _days.removeLast();
      _months.removeLast();
      _years.removeLast();
      previouslyMarked = false;
    }
  }

  void _onDayChanged() {
    _markDay();
    _save();
    previouslyMarked = false;
    for (var item in habitsCheck) {
      item = false;
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
    return TableCalendar(
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, focusedDay) {
          if (_days.contains(day.day) &&
              _months.contains(day.month) &&
              _years.contains(day.year)) {
            return const Icon(Icons.check,
                color: Color.fromARGB(255, 4, 184, 4));
          } else {
            return null;
          }
        },
      ),
      focusedDay: DateTime.now(),
      firstDay: DateTime.parse("20210402"),
      lastDay: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('BareBones Habit Tracker')),
      body: _buildList(),
      persistentFooterButtons: editable
          ? [testSave(), testRead(), addHabit(), removeHabit(), editHabits()]
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
    var savedSplitData;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.txt');
      savedSplitData = await file.readAsString().toString().split("çç");
      _years = _stringToInt(savedSplitData[0]);
      _months = _stringToInt(savedSplitData[1]);
      _days = _stringToInt(savedSplitData[2]);
      numOfHabits = int.parse(savedSplitData[3]);
      listHaCheck = _stringToInt(savedSplitData[4]);
      habits = savedSplitData[5];
      habitsSeparated = habits.split("|");
      for (var item in habitsSeparated) {
        if (item != "") {
          textControllers[habitsSeparated.indexOf(item)].text = item;
        }
      }
      habitsCheck.clear();
      for (var item in listHaCheck) {
        if (item == 1) {
          habitsCheck.add(true);
        } else {
          habitsCheck.add(false);
        }
        if (habitsCheck.contains(false) == false) {
          previouslyMarked = true;
        }
        (context as Element).reassemble();
      }
    } catch (e) {
      print("Couldn't read file");
    }
  }

  _save() async {
    notFirst = false;
    habits = "çç";
    listHaCheck.clear();
    for (var item in habitsCheck) {
      if (item == true) {
        listHaCheck.add(1);
      } else {
        listHaCheck.add(0);
      }
    }
    for (var item in habitsSeparated) {
      if (habitsSeparated.indexOf(item) == 0 && !notFirst) {
        habits = item;
        notFirst = true;
      } else {
        habits = habits + "|" + item;
      }
    }
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');
    await file.writeAsString(_years.toString() + "çç");
    await file.writeAsString(_months.toString() + "çç", mode: FileMode.append);
    await file.writeAsString(_days.toString() + "çç", mode: FileMode.append);
    await file.writeAsString(numOfHabits.toString() + "çç",
        mode: FileMode.append);
    await file.writeAsString(listHaCheck.toString() + "çç",
        mode: FileMode.append);
    await file.writeAsString(habits, mode: FileMode.append);
  }
}

List<int> _stringToInt(String string) {
  if (string == "[]") {
    return <int>[];
  }
  var formatedStrings = string.substring(1, string.length - 1).split(",");
  List<int> stringAsIntList = <int>[];
  for (var element in formatedStrings) {
    stringAsIntList.add(int.parse(element));
  }
  return stringAsIntList;
}
