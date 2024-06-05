import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/add_event_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/home_screen_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/user_provider.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/add_event.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/event_detail_page.dart';
import 'package:flutter_events_2023/View/Utils/next_screen.dart';
import 'package:flutter_events_2023/View/theme/extention.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:flutter_events_2023/View/theme/text_styles.dart';
import 'package:flutter_events_2023/model/event.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Event>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.followingSnapshot();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(fromFirestore: Event.fromFirestore, toFirestore: (event, options) => event.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
      final day = DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  List<Event> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<AuthProvider>();
    final homeProvider = context.read<HomeScreenProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () {
            homeProvider.changeTab(3);
          },
          child: Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: LightColor.primary,
              radius: 35,
              child: CircleAvatar(
                radius: 21,
                backgroundImage:
                    sp.imageUrl.toString() != "" ? NetworkImage("${sp.imageUrl}") as ImageProvider : const AssetImage("assets/Images/person.png"),
              ),
            ),
          ).p(8),
        ),
        title: Text(
          "Event Management App",
          style: TextStyles.bodySm.black.bold,
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.notifications_none,
              size: 30,
              color: LightColor.grey,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Consumer<AddEventProvider>(builder: (context, AddEventProvider event, _) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: LightColor.primaryExtraLight.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TableCalendar(
                  eventLoader: _getEventsForTheDay,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  focusedDay: _focusedDay,
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                    _loadFirestoreEvents();
                  },
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  onDaySelected: (selectedDay, focusedDay) {
                    print(_events[selectedDay]);
                    print("day selected $selectedDay $focusedDay");
                    event.fetchEvents(selectedDay, focusedDay);
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: GoogleFonts.poppins(
                      color: LightColor.primary,
                    ),
                    selectedDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: LightColor.primary,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    headerTitleBuilder: (context, day) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(day.toString()),
                      );
                    },
                  ),
                ),
              ),
              Consumer<AddEventProvider>(
                builder: (context, AddEventProvider eventProvider, _) {
                  if (eventProvider.loading) {
                    // Loading indicator
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    // Fetch events if not already fetched
                    if (eventProvider.eventsStream == null) {
                      eventProvider.fetchEvents(_firstDay, _lastDay);
                    }
                    // Return ListView builder with data
                    return Consumer<UserProvider>(builder: (context, userProvider, _) {
                      return StreamBuilder<List<DocumentSnapshot>>(
                        stream: eventProvider.eventsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Loading indicator while waiting for data
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            // If there is an error, display it
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              // If data is available, display ListView
                              final events = snapshot.data!;
                              // Filter events based on userIds
                              final filteredEvents =
                                  events.where((eventData) => userProvider.followedUserIds.contains(eventData['userId'].toString()));
                              print("object $filteredEvents");
                              return SizedBox(
                                child: ListView.builder(
                                  itemCount: filteredEvents.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    // Extract event data
                                    final eventData = filteredEvents.elementAt(index).data() as Map<String, dynamic>;

                                    // Return ListTile with event details
                                    return Container(
                                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            offset: const Offset(4, 4),
                                            blurRadius: 10,
                                            color: LightColor.grey.withOpacity(.2),
                                          ),
                                          BoxShadow(
                                            offset: const Offset(-3, 0),
                                            blurRadius: 15,
                                            color: LightColor.grey.withOpacity(.1),
                                          )
                                        ],
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(0),
                                          leading: ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(13)),
                                            child: Container(
                                              height: 55,
                                              width: 55,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: randomColor(),
                                              ),
                                              child: eventData["userImage"] == ""
                                                  ? Image.asset("assets/Images/person.png")
                                                  : Image.network(
                                                      eventData['userImage'].toString(),
                                                      fit: BoxFit.fill,
                                                    ),
                                            ),
                                          ),
                                          title: Text(eventData['title'].toString(), overflow: TextOverflow.ellipsis, style: TextStyles.title.bold),
                                          subtitle: Text(
                                            eventData['description'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles.bodySm.subTitleColor.bold,
                                          ),
                                          trailing: Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 30,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ).ripple(() {
                                        nextScreen(
                                            context,
                                            EventDetailPage(
                                              eventData: eventData,
                                            ));
                                      }, borderRadius: const BorderRadius.all(Radius.circular(20))),
                                    );
                                  },
                                ),
                              );
                            }
                          }
                        },
                      );
                    });
                  }
                },
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LightColor.primaryExtraLight,
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AddEvent(
                firstDate: _firstDay,
                lastDate: _lastDay,
                selectedDate: _selectedDay,
              ),
            ),
          );
          if (result ?? false) {
            _loadFirestoreEvents();
          }
        },
        child: const Icon(
          Icons.add,
          color: LightColor.primary,
        ),
      ),
    );
  }

  Color randomColor() {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      LightColor.orange,
      LightColor.green,
      LightColor.grey,
      LightColor.lightOrange,
      LightColor.skyBlue,
      LightColor.titleTextColor,
      Colors.red,
      Colors.brown,
      LightColor.primaryExtraLight,
      LightColor.skyBlue,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }
}
