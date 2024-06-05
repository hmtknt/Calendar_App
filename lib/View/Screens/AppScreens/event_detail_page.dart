import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/event_scheduale_provider.dart';
import 'package:flutter_events_2023/View/Components/build_buttons.dart';
import 'package:flutter_events_2023/View/theme/extention.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:flutter_events_2023/View/theme/text_styles.dart';
import 'package:flutter_events_2023/View/theme/theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailPage extends StatefulWidget {
  final dynamic eventData;
  const EventDetailPage({
    super.key,
    required this.eventData,
  });

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _appbar() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BackButton(color: Theme.of(context).primaryColor),
          // IconButton(
          //     icon: Icon(
          //       user!.isfavourite ? Icons.favorite : Icons.favorite_border,
          //       color: user!.isfavourite ? Colors.red : LightColor.grey,
          //     ),
          //     onPressed: () {
          //       setState(() {
          //         user!.isfavourite = !user!.isfavourite;
          //       });
          //     })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<AuthProvider>();
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 22).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 20).bold;
    }

    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.43,
            width: MediaQuery.of(context).size.width,
            child: widget.eventData["userImage"] == ""
                ? Image.asset(
                    "assets/Images/person.png",
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    widget.eventData['userImage'].toString(),
                    fit: BoxFit.cover,
                  ),
          ),
          DraggableScrollableSheet(
            maxChildSize: .6,
            initialChildSize: .6,
            minChildSize: .6,
            builder: (context, scrollController) {
              String formattedDateTime = DateTimeFormatter.formatFirebaseTimestamp(widget.eventData['date']);
              return Container(
                height: AppTheme.fullHeight(context) * .5,
                padding: const EdgeInsets.only(left: 19, right: 19, top: 16), //symmetric(horizontal: 19, vertical: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          widget.eventData['title'].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: titleStyle,
                        ),
                        subtitle: Text(
                          formattedDateTime.toString(),
                          style: TextStyles.bodySm.subTitleColor.bold,
                        ),
                      ),
                      const Divider(
                        thickness: .3,
                        color: LightColor.grey,
                      ),
                      Text("Contact", style: titleStyle).vP16,
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            color: LightColor.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.eventData['phone'].toString(),
                            style: TextStyles.body.subTitleColor,
                          ),
                        ],
                      ),
                      Text("About", style: titleStyle).vP16,
                      Text(
                        widget.eventData['description'].toString(),
                        style: TextStyles.body.subTitleColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<EventScheduleProvider>(builder: (context, eventProvider, _) {
                        return SizedBox(
                          height: 55,
                          width: double.infinity,
                          child: buildRegisterButton(() {
                            DateTime currentDate = DateTime.now();

                            String formattedDate = '${currentDate.month.toString().padLeft(2, '0')}/'
                                '${currentDate.day.toString().padLeft(2, '0')}/'
                                '${currentDate.year.toString()}';
                            TimeOfDay currentTime = TimeOfDay.now();
                            String formattedTime = '${currentTime.hourOfPeriod.toString().padLeft(2, '0')}:'
                                '${currentTime.minute.toString().padLeft(2, '0')} '
                                '${currentTime.period == DayPeriod.am ? 'AM' : 'PM'}';
                            print("Date $formattedDate Time $formattedTime");
                            eventProvider.addSchedule(
                              context: context,
                              userId: sp.uid.toString(),
                              eventHolderId: widget.eventData['userId'].toString(),
                              userName: widget.eventData['userName'].toString(),
                              eventTitle: widget.eventData['title'].toString(),
                              photoUrl: widget.eventData['userImage'].toString(),
                              eventDescription: widget.eventData['description'].toString(),
                              eventDate: formattedDate,
                              eventTime: formattedTime,
                              phone: widget.eventData['phone'].toString(),
                            );
                          },
                              eventProvider.isLoading
                                  ? const SpinKitThreeBounce(
                                      color: LightColor.white,
                                      size: 30.0,
                                    )
                                  : const Text("Schedule Event",
                                      style: TextStyle(color: LightColor.white, fontWeight: FontWeight.bold, fontSize: 15))),
                        );
                      }).vP16
                    ],
                  ),
                ),
              );
            },
          ),
          _appbar(),
        ],
      ),
    );
  }
}

class DateTimeFormatter {
  static String formatFirebaseTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDateTime = DateFormat('MMMM d, yyyy').format(dateTime);
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return '$formattedDateTime at $formattedTime';
  }
}
