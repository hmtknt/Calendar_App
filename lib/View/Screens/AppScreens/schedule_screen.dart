import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/event_scheduale_provider.dart';
import 'package:flutter_events_2023/View/theme/extention.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:flutter_events_2023/View/theme/text_styles.dart';
import 'package:flutter_events_2023/View/widgets/canceled_events.dart';
import 'package:flutter_events_2023/View/widgets/completed_events.dart';
import 'package:flutter_events_2023/View/widgets/upcoming_events.dart';
import 'package:provider/provider.dart';

class ScheduleEventScreen extends StatefulWidget {
  const ScheduleEventScreen({super.key});

  @override
  State<ScheduleEventScreen> createState() => _ScheduleEventScreenState();
}

class _ScheduleEventScreenState extends State<ScheduleEventScreen> {
  int _buttonIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    final sp = context.read<AuthProvider>();
    final appointmentProvider = context.read<EventScheduleProvider>();
    appointmentProvider.fetchUpcomingEventSchedule(sp.uid.toString());
    appointmentProvider.fetchCanceledEventSchedule(sp.uid.toString());
    appointmentProvider.fetchCompletedEventSchedule(sp.uid.toString());
  }

  final _scheduleWidgets = [
    // Upcoming Widget
    const UpcomingEventSchedule(),

    // Completed Widget
    const completedEventSchedule(),

    // Canceled Widget
    const CanceledEventSchedule(),
  ];
  List<String> scheduleName = [
    'Upcoming',
    'Complete',
    'Canceled',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Schedule Events",
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                    itemCount: scheduleName.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _buttonIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: _buttonIndex == index ? LightColor.primary : LightColor.grey.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                offset: const Offset(4, 4),
                                blurRadius: 5,
                                color: LightColor.grey.withOpacity(.2),
                              ),
                              BoxShadow(
                                offset: const Offset(-3, 0),
                                blurRadius: 5,
                                color: LightColor.grey.withOpacity(.1),
                              )
                            ],
                          ),
                          child: Text(
                            scheduleName[index].toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _buttonIndex == index ? Colors.white : Colors.black38,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 30),
              Expanded(child: _scheduleWidgets[_buttonIndex]),
            ],
          ),
        ),
      ),
    );
  }
}
