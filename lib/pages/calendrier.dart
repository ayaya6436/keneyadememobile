import 'package:flutter/material.dart';
import 'package:keneyadememobile/pages/event.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendrier extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalendrierState();
  }
}

class CalendrierState extends State<Calendrier> {
  List<String> date = [
    "1/01/2024",
    "16/06/2024",
    "10/09/2024",
  ];

  List<String> events = [
    "Vaccination contre le Paludisme",
    "Vaccination contre la Bilharziose",
    "Vaccination contre la Gale",
  ];

  DateTime today = DateTime.now();

  List<Event> eventDate = [];

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 40,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Image.asset(
                  "assets/images/calendrier.png",
                  width: 188,
                  height: 169,
                ),
              ),
            ],
          ),
          Container(
            child: TableCalendar(rowHeight: 40,
              headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, today),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: today,
              onDaySelected: _onDaySelected,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: date.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      date[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      events[index],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
