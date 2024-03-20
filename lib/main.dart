import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spend',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<String, List> mySelectedEvents = {};

  final amountController = TextEditingController();
  final despController = TextEditingController();

  late int dayExpendNow;
  int dayExpendTotal = 0;
  int dayLimit = 1000000;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    loadPreviouseEvents();
  }

  // For Preview
  loadPreviouseEvents() {
    mySelectedEvents = {
      "2024-03-02": [
        {"eventAmount": "4500", "eventDescp": "Change iPhone Battery"},
        {"eventAmount": "3600", "eventDescp": "Little Hangout"},
        {"eventAmount": "2760", "eventDescp": "Dinner"}
      ],
      "2024-03-13": [
        {"eventAmount": "11200", "eventDescp": "Omakase"},
        {"eventAmount": "5600", "eventDescp": "Cat Baht"}
      ],
      "2024-03-19": [
        {"eventAmount": "7600", "eventDescp": "Dinner"}
      ],
    };
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        dayExpendTotal = _calculateDayExpenses(selectedDay);
      });
    }
  }

  void _spendDialog() async {
    await showDialog(
      context: context,
      builder: (context) => Container(
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Spend"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
              TextField(
                controller: despController,
                decoration: const InputDecoration(labelText: "Description"),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
              onPressed: () {
                if (amountController.text.isEmpty &&
                    despController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Require Amount and Description"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                } else {
                  setState(() {
                    int dayExpendNow = int.parse(amountController.text);
                    dayExpendTotal += dayExpendNow;
                    if (mySelectedEvents[
                            DateFormat('yyyy-MM-dd').format(_selectedDay!)] !=
                        null) {
                      mySelectedEvents[
                              DateFormat('yyyy-MM-dd').format(_focusedDay)]
                          ?.add({
                        "eventAmount": amountController.text,
                        "eventDescp": despController.text,
                      });
                    } else {
                      mySelectedEvents[
                          DateFormat('yyyy-MM-dd').format(_selectedDay!)] = [
                        {
                          "eventAmount": amountController.text,
                          "eventDescp": despController.text,
                        }
                      ];
                    }
                  });

                  amountController.clear();
                  despController.clear();
                  Navigator.pop(context);
                  return;
                }
              },
              child: const Text("OK"),
            )
          ],
        ),
      ),
    );
  }

  int _calculateDayExpenses(DateTime selectedDay) {
    int total = 0;
    List events = _listOfDayEvents(selectedDay);
    for (var event in events) {
      total += int.parse(event['eventAmount']);
    }
    return total;
  }

  int _calculateMonthExpenses(DateTime selectedMonth) {
    int total = 0;
    mySelectedEvents.forEach((key, value) {
      DateTime date = DateFormat('yyyy-MM-dd').parse(key);
      if (date.month == selectedMonth.month &&
          date.year == selectedMonth.year) {
        for (var event in value) {
          total += int.parse(event['eventAmount']);
        }
      }
    });
    return total;
  }

  void _editDialog(Map<String, String> myEvent) {
    despController.text = myEvent['eventDescp']!;
    amountController.text = myEvent['eventAmount']!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Event"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            TextField(
              controller: despController,
              decoration: const InputDecoration(labelText: "Description"),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content:
                      const Text('Are you sure you want to delete this event?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          dayExpendTotal -= int.parse(myEvent['eventAmount']!);
                          _listOfDayEvents(_selectedDay!).remove(myEvent);
                        });
                        Navigator.pop(context); // Close confirm delete dialog
                        Navigator.pop(context); // Close edit dialog
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            },
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text("Delete"),
          ),
          TextButton(
            onPressed: () {
              if (amountController.text.isEmpty &&
                  despController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Require Amount and Description"),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else {
                setState(() {
                  int dayExpendNow = int.parse(amountController.text);
                  dayExpendTotal +=
                      dayExpendNow - int.parse(myEvent['eventAmount']!);

                  myEvent['eventAmount'] = amountController.text;
                  myEvent['eventDescp'] = despController.text;
                });

                amountController.clear();
                despController.clear();
                Navigator.pop(context);
                return;
              }
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(10),
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage("assets/images/logo.jpg"),
            backgroundColor: Colors.transparent,
          ),
        ),
        titleSpacing: 0,
        title: const Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Spend",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/images/profile.jpg"),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all()),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Overview",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Mount Expenses"),
                          Text(
                            "${_calculateMonthExpenses(DateTime(_focusedDay.year, _focusedDay.month, 1))}",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Day Expenses"),
                          Text(
                            '$dayExpendTotal',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color:
                                  dayExpendTotal > dayLimit ? Colors.red : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20)),
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(0),
                child: TableCalendar(
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    headerMargin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(color: Colors.black),
                    titleTextStyle: TextStyle(color: Colors.white),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                  rowHeight: 55,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay, //
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  onDaySelected: _onDaySelected,

                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 132, 132, 132),
                        shape: BoxShape.circle),
                  ),

                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _listOfDayEvents,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 162, 166, 245),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Set Day Limit'),
                            content: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Enter Day Limit',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  dayLimit = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Set'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        height: 120,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.remove_circle_outline_rounded,
                              color: Colors.black,
                              size: 30.0,
                            ),
                            Text(
                              "Set Day Limit              ",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 144, 144),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: (_spendDialog),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        height: 120,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.arrow_circle_up_rounded,
                              color: Colors.black,
                              size: 30.0,
                            ),
                            Text(
                              "Spend                          ",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ..._listOfDayEvents(_selectedDay!).map(
                (myEvents) => Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all()),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '- ${myEvents['eventAmount']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Note ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${myEvents['eventDescp']}',
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editDialog(myEvents),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
