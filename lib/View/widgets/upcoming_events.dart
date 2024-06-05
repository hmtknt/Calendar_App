import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/event_scheduale_provider.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UpcomingEventSchedule extends StatelessWidget {
  const UpcomingEventSchedule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About Event",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
              //height: MediaQuery.of(context).size.height * 0.54,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Consumer<EventScheduleProvider>(builder: (context, eventProvider, _) {
                if (eventProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: LightColor.primary,
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: eventProvider.upcomingEventSchedule.length,
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final eventData = eventProvider.upcomingEventSchedule;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
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
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  eventData[index].eventTitle.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(eventData[index].eventDescription.toString()),
                                trailing: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(eventData[index].photoUrl.toString()),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(
                                  thickness: 1,
                                  height: 20,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        eventData[index].eventDate.toString(),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_filled,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        eventData[index].eventTime.toString(),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        eventProvider.cancelSchedule(eventData[index].eventId);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F6FA),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Consumer<EventScheduleProvider>(builder: (context, eventProvider, _) {
                                    return Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          DateTime currentDate = DateTime.now();

                                          String formattedDate = '${currentDate.month.toString().padLeft(2, '0')}/'
                                              '${currentDate.day.toString().padLeft(2, '0')}/'
                                              '${currentDate.year.toString()}';
                                          TimeOfDay currentTime = TimeOfDay.now();
                                          String formattedTime = '${currentTime.hourOfPeriod.toString().padLeft(2, '0')}:'
                                              '${currentTime.minute.toString().padLeft(2, '0')} '
                                              '${currentTime.period == DayPeriod.am ? 'AM' : 'PM'}';
                                          print("Date $formattedDate Time $formattedTime");
                                          eventProvider.completeTheSchedule(
                                              eventData[index].eventId, formattedDate.toString(), formattedTime.toString());
                                        },
                                        child: Container(
                                          // width: 100,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: eventProvider.isReSchedule
                                                ? const SpinKitThreeBounce(
                                                    color: LightColor.white,
                                                    size: 30.0,
                                                  )
                                                : const Text(
                                                    "Complete",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    });
              }),
            ),
          ),
        ],
      ),
    );
  }
}
