import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/event_scheduale_provider.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:provider/provider.dart';

class completedEventSchedule extends StatelessWidget {
  const completedEventSchedule({
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
                    itemCount: eventProvider.completedEventSchedule.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final userData = eventProvider.completedEventSchedule;
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
                                  userData[index].eventTitle.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(userData[index].eventDescription.toString()),
                                trailing: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(userData[index].photoUrl.toString()),
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
                                        userData[index].eventDate.toString(),
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
                                        userData[index].eventTime.toString(),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
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
