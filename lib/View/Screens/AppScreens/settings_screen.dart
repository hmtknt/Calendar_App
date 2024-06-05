import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/about_screen.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/edit_profile_screen.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/event_trip_screen.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/help_screen.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/privacy_screen.dart';
import 'package:flutter_events_2023/View/Utils/next_screen.dart';
import 'package:flutter_events_2023/View/theme/extention.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:flutter_events_2023/View/theme/text_styles.dart';
import 'package:flutter_events_2023/View/widgets/listTile_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    final sp = context.read<AuthProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Settings",
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: LightColor.primary,
                    radius: 45,
                    child: CircleAvatar(
                      radius: 41,
                      backgroundImage:
                          sp.imageUrl != "" ? NetworkImage("${sp.imageUrl}") as ImageProvider : const AssetImage("assets/Images/person.png"),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    sp.name.toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        nextScreen(context, const EditProfileScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Edit Profile", style: GoogleFonts.poppins(color: const Color(0xff103BC7))),
                      ),
                    )),
                const Divider(height: 30),
                // CustomListTile(
                //     leadingIcon: CupertinoIcons.person,
                //     title: "Profile",
                //     onTap: () {},
                //     trailingIcon: Icons.arrow_forward_ios_rounded,
                //     boxColor: Colors.blue.shade100,
                //     iconColor: Colors.blue),
                // const SizedBox(height: 10),
                // CustomListTile(
                //     leadingIcon: Icons.notifications_none_outlined,
                //     title: "Notification",
                //     onTap: () {},
                //     trailingIcon: Icons.arrow_forward_ios_rounded,
                //     boxColor: Colors.purple.shade100,
                //     iconColor: Colors.purple),
                // const SizedBox(height: 10),
                CustomListTile(
                    leadingIcon: Icons.tips_and_updates,
                    title: "Events Tips",
                    onTap: () {
                      nextScreen(context, const EventTipsScreen());
                    },
                    trailingIcon: Icons.arrow_forward_ios_rounded,
                    boxColor: Colors.greenAccent.shade100,
                    iconColor: Colors.green),
                // const SizedBox(height: 10),
                // CustomListTile(
                //     leadingIcon: Icons.settings_suggest_outlined,
                //     title: "General Settings",
                //     onTap: () {},
                //     trailingIcon: Icons.arrow_forward_ios_rounded,
                //     boxColor: Colors.orange.shade100,
                //     iconColor: Colors.orange),
                const SizedBox(height: 10),
                CustomListTile(
                    leadingIcon: Icons.lock_clock_outlined,
                    title: "Privacy Policy",
                    onTap: () {
                      nextScreen(context, const PrivacyScreen());
                    },
                    trailingIcon: Icons.arrow_forward_ios_rounded,
                    boxColor: Colors.purple.shade100,
                    iconColor: Colors.purple),
                const SizedBox(height: 10),
                CustomListTile(
                    leadingIcon: Icons.info_outline_rounded,
                    title: "About Us",
                    onTap: () {
                      nextScreen(context, const AboutUsScreen());
                    },
                    trailingIcon: Icons.arrow_forward_ios_rounded,
                    boxColor: Colors.cyanAccent.shade100,
                    iconColor: Colors.cyan),
                const SizedBox(height: 10),
                CustomListTile(
                    leadingIcon: Icons.help_outline,
                    title: "Help",
                    onTap: () {
                      nextScreen(context, const HelpScreen());
                    },
                    trailingIcon: Icons.arrow_forward_ios_rounded,
                    boxColor: Colors.orange.shade100,
                    iconColor: Colors.orange),
                const Divider(height: 20),

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: LightColor.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  child: sp.loading
                      ? const SpinKitThreeBounce(
                          color: LightColor.black,
                          size: 45,
                        )
                      : ListTile(
                          onTap: () async {
                            await sp.userSignOut().whenComplete(() {
                              nextScreenRemoveUntil(
                                context,
                                '/signIn',
                              );
                            });
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                          title: const Text(
                            "Log Out",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
