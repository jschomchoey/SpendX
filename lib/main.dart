import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpendX',
      theme: ThemeData(
        primarySwatch: Colors.orange,
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
      "2024-02-01": [
        {"eventAmount": "5000", "eventDescp": "Dormitory rent"},
        {"eventAmount": "100", "eventDescp": "Gasoline"},
        {"eventAmount": "120", "eventDescp": "Food"}
      ],
      "2024-02-03": [
        {"eventAmount": "150", "eventDescp": "Food"},
        {"eventAmount": "250", "eventDescp": "Internet"},
        {"eventAmount": "100", "eventDescp": "Netflix"}
      ],
      "2024-02-04": [
        {"eventAmount": "150", "eventDescp": "Food"},
        {"eventAmount": "45", "eventDescp": "Tea"}
      ],
      "2024-02-05": [
        {"eventAmount": "100", "eventDescp": "Food"},
        {"eventAmount": "300", "eventDescp": "Hangout"}
      ],
      "2024-02-07": [
        {"eventAmount": "105", "eventDescp": "Food"},
        {"eventAmount": "50", "eventDescp": "Tea"}
      ],
      "2024-02-08": [
        {"eventAmount": "90", "eventDescp": "Food"},
        {"eventAmount": "20", "eventDescp": "Snacks"},
        {"eventAmount": "250", "eventDescp": "Clothes"},
      ],
      "2024-02-09": [
        {"eventAmount": "120", "eventDescp": "Food"},
        {"eventAmount": "45", "eventDescp": "Water pack"}
      ],
      "2024-02-10": [
        {"eventAmount": "135", "eventDescp": "Food"},
        {"eventAmount": "100", "eventDescp": "Gasoline"},
        {"eventAmount": "42", "eventDescp": "Pepsi"},
      ],
      "2024-02-12": [
        {"eventAmount": "150", "eventDescp": "Food"},
      ],
      "2024-02-13": [
        {"eventAmount": "115", "eventDescp": "Food"},
        {"eventAmount": "30", "eventDescp": "Bubble Tea"},
      ],
      "2024-02-14": [
        {"eventAmount": "145", "eventDescp": "Food"},
        {"eventAmount": "45", "eventDescp": "Coffee"},
      ],
      "2024-02-15": [
        {"eventAmount": "140", "eventDescp": "Food"},
        {"eventAmount": "45", "eventDescp": "Coffee"},
      ],
      "2024-02-18": [
        {"eventAmount": "150", "eventDescp": "Food"},
        {"eventAmount": "40", "eventDescp": "Coffee"},
      ],
      "2024-02-20": [
        {"eventAmount": "120", "eventDescp": "Food"},
        {"eventAmount": "40", "eventDescp": "Bubble Tea"},
      ],
      "2024-02-21": [
        {"eventAmount": "90", "eventDescp": "Food"},
        {"eventAmount": "30", "eventDescp": "Tea"},
      ],
      "2024-02-22": [
        {"eventAmount": "95", "eventDescp": "Food"},
        {"eventAmount": "50", "eventDescp": "Coffee"},
      ],
      "2024-02-23": [
        {"eventAmount": "95", "eventDescp": "Food"},
        {"eventAmount": "50", "eventDescp": "Snacks"},
      ],
      "2024-02-24": [
        {"eventAmount": "95", "eventDescp": "Food"},
        {"eventAmount": "30", "eventDescp": "Bubble Tea"},
      ],
      "2024-02-25": [
        {"eventAmount": "95", "eventDescp": "Food"},
        {"eventAmount": "50", "eventDescp": "Snacks"},
      ],
      "2024-02-26": [
        {"eventAmount": "95", "eventDescp": "Food"},
        {"eventAmount": "50", "eventDescp": "Snacks"},
        {"eventAmount": "45", "eventDescp": "Water pack"}
      ],
      "2024-02-29": [
        {"eventAmount": "95", "eventDescp": "Food"},
        {"eventAmount": "50", "eventDescp": "Snacks"},
      ],
      "2024-03-01": [
        {"eventAmount": "5000", "eventDescp": "Dormitory rent"},
        {"eventAmount": "100", "eventDescp": "Gasoline"},
        {"eventAmount": "150", "eventDescp": "Food"}
      ],
      "2024-03-03": [
        {"eventAmount": "120", "eventDescp": "Food"},
        {"eventAmount": "40", "eventDescp": "Tea"},
        {"eventAmount": "250", "eventDescp": "Internet"},
        {"eventAmount": "100", "eventDescp": "Netflix"}
      ],
      "2024-03-04": [
        {"eventAmount": "150", "eventDescp": "Food"},
        {"eventAmount": "45", "eventDescp": "Tea"}
      ],
      "2024-03-05": [
        {"eventAmount": "100", "eventDescp": "Food"},
        {"eventAmount": "45", "eventDescp": "Water pack"}
      ],
      "2024-03-06": [
        {"eventAmount": "150", "eventDescp": "Food"},
        {"eventAmount": "30", "eventDescp": "Snacks"},
      ],
      "2024-03-08": [
        {"eventAmount": "90", "eventDescp": "Food"},
        {"eventAmount": "20", "eventDescp": "Snacks"},
      ],
      "2024-03-09": [
        {"eventAmount": "120", "eventDescp": "Food"},
      ],
      "2024-03-11": [
        {"eventAmount": "150", "eventDescp": "Food"},
        {"eventAmount": "199", "eventDescp": "Shabu"},
      ],
      "2024-03-13": [
        {"eventAmount": "115", "eventDescp": "Food"},
        {"eventAmount": "30", "eventDescp": "Bubble Tea"},
      ],
      "2024-03-14": [
        {"eventAmount": "145", "eventDescp": "Food"},
        {"eventAmount": "45", "eventDescp": "Coffee"},
      ],
      "2024-03-15": [
        {"eventAmount": "140", "eventDescp": "Food"},
        {"eventAmount": "45", "eventDescp": "Coffee"},
      ],
      "2024-03-16": [
        {"eventAmount": "100", "eventDescp": "Food"},
        {"eventAmount": "250", "eventDescp": "Clothes"},
        {"eventAmount": "300", "eventDescp": "Birthday Party"},
      ],
      "2024-03-17": [
        {"eventAmount": "120", "eventDescp": "Food"},
        {"eventAmount": "40", "eventDescp": "Tea"},
      ],
      "2024-03-19": [
        {"eventAmount": "130", "eventDescp": "Food"},
        {"eventAmount": "40", "eventDescp": "Coffee"},
        {"eventAmount": "50", "eventDescp": "Snacks"},
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
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text("Spend"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.money_off_csred_rounded,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: despController,
              decoration: InputDecoration(
                labelText: "Description",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                prefixIcon: const Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    Icons.list_alt_rounded,
                  ),
                ),
              ),
            )
          ],
        ),
        actions: [
          SizedBox(
            height: 50,
            width: 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
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
            ),
          )
        ],
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
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text("Edit Event"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: "Amount",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                prefixIcon: const Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    Icons.money_off_csred_rounded,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: despController,
              decoration: InputDecoration(
                labelText: "Description",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                prefixIcon: const Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    Icons.list_alt_rounded,
                  ),
                ),
              ),
            )
          ],
        ),
        actions: [
          SizedBox(
            height: 50,
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    surfaceTintColor: Colors.white,
                    backgroundColor: Colors.white,
                    title: const Text('Confirm Delete'),
                    content:
                        const Text('Are you sure you want to delete this?'),
                    actions: [
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('No'),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            setState(() {
                              dayExpendTotal -=
                                  int.parse(myEvent['eventAmount']!);
                              _listOfDayEvents(_selectedDay!).remove(myEvent);
                            });
                            Navigator.pop(
                                context); // Close confirm delete dialog
                            Navigator.pop(context); // Close edit dialog
                          },
                          child: const Text('Yes'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Delete"),
            ),
          ),
          SizedBox(
            height: 50,
            width: 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
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
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
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
                "SpendX",
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
                              color: dayLimit == 0
                                  ? Colors.black
                                  : dayExpendTotal > dayLimit
                                      ? Colors.red
                                      : null,
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
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            title: const Text('Set Day Limit'),
                            content: TextField(
                              decoration: InputDecoration(
                                labelText: "Day Limit",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                prefixIcon: const Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                    Icons.money_off_csred_rounded,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  dayLimit = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                            actions: [
                              SizedBox(
                                height: 50,
                                width: 100,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    side: const BorderSide(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                width: 100,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    side: const BorderSide(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Set'),
                                ),
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
                              "Day Limit                    ",
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
