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
      listDays.add(DateTime.now().day);
      listMonths.add(DateTime.now().month);
      previouslyMarked = true;
    } else if (previouslyMarked) {
      listDays.removeLast();
      listMonths.removeLast();
      previouslyMarked = false;
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
    String strDt = "20210402";
    DateTime parseDt = DateTime.parse(strDt);
    return TableCalendar(
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, focusedDay) {
          if (listDays.contains(day.day) && listMonths.contains(day.month)) {
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
    var leitura;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.txt');
      await file.readAsBytes();
      leitura = await file.readAsString();
      leitura = leitura.toString().split("çç");
      listMonths = _stringToInt(leitura[0]);
      listDays = _stringToInt(leitura[1]);
      listHaCheck = _stringToInt(leitura[2]);
      habits = leitura[3];
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
    await file.writeAsString(listMonths.toString() + "çç");
    await file.writeAsString(listDays.toString() + "çç", mode: FileMode.append);
    await file.writeAsString(listHaCheck.toString() + "çç",
        mode: FileMode.append);
    await file.writeAsString(habits, mode: FileMode.append);
  }
}

List<int> _stringToInt(String string) {
  var slimpa = string.substring(1, string.length - 1);
  var lista = slimpa.split(",");
  List<int> retornar = <int>[];
  for (var element in lista) {
    retornar.add(int.parse(element));
  }
  return retornar;
}
