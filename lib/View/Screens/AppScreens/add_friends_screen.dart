import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/user_provider.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/add_event.dart';
import 'package:flutter_events_2023/View/Utils/snack_bar.dart';
import 'package:flutter_events_2023/View/theme/extention.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:flutter_events_2023/View/theme/text_styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final sp = context.read<AuthProvider>();
    final up = context.read<UserProvider>();
    up.getAllUsers(sp.uid.toString());
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Friends",
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
        child: Consumer<UserProvider>(builder: (context, userProvider, _) {
          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(10.0, 20.0, 3.0, 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 30.0,
                      shadowColor: Colors.greenAccent,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.greenAccent, Colors.green, Colors.blueGrey],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Following',
                              //overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Text(
                              'Last 7 days',
                              style: TextStyle(color: Colors.white, fontSize: 10.0),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('users').doc(sp.uid).collection('following').snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Show loading indicator
                                }
                                if (snapshot.hasError) {
                                  return const Text(
                                    '0',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                                  );
                                  // Show error message
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return const Text(
                                    '0',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                                  );
                                  // Handle case when no followers
                                }
                                // Get the length of the followers collection
                                int followersCount = snapshot.data!.docs.length;
                                return Text(
                                  '$followersCount',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                                ); // Display followers count
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Todo: Randomise Profile pics
                  // Todo: Randomise Network images
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(8.0, 20.0, 10.0, 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 30.0,
                      shadowColor: Colors.blue,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.purple, Colors.deepPurple, LightColor.primary],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Followers',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Text(
                              'Last 7 days',
                              style: TextStyle(color: Colors.white, fontSize: 10.0),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('users').doc(sp.uid.toString()).collection('followers').snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Show loading indicator
                                }
                                if (snapshot.hasError) {
                                  return const Text(
                                    '0',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                                  );
                                  // Show error message
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return const Text(
                                    '0',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                                  );
                                  // Handle case when no followers
                                }
                                // Get the length of the followers collection
                                int followersCount = snapshot.data!.docs.length;
                                return Text(
                                  '$followersCount',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                                ); // Display followers count
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<List<DocumentSnapshot>>(
                stream: userProvider.usersStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final users = snapshot.data!;
                    // user['name']
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index].data() as Map<String, dynamic>;
                          userProvider.fetchFollowers(user['uid']);
                          return ListTile(
                            leading: user['image_url'] == ""
                                ? const CircleAvatar(
                                    radius: 28.0,
                                    child: Icon(
                                      FontAwesomeIcons.user,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(user['image_url']),
                                    radius: 28.0,
                                  ),
                            title: Text(
                              user['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            subtitle: Text(
                              user['email'],
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            trailing: StreamBuilder<DocumentSnapshot>(
                              stream: userProvider.followersStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return IconButton(
                                    icon: const FaIcon(
                                      FontAwesomeIcons.userPlus,
                                      color: Colors.blueAccent,
                                      size: 19.0,
                                    ),
                                    onPressed: () {},
                                  );
                                } else if (snapshot.hasError) {
                                  return IconButton(
                                    icon: const FaIcon(
                                      FontAwesomeIcons.userPlus,
                                      color: Colors.blueAccent,
                                      size: 19.0,
                                    ),
                                    onPressed: () {},
                                  );
                                } else if (snapshot.data == null || !snapshot.data!.exists) {
                                  return IconButton(
                                    icon: const FaIcon(
                                      FontAwesomeIcons.userPlus,
                                      color: Colors.blueAccent,
                                      size: 19.0,
                                    ),
                                    onPressed: () {
                                      userProvider.followUser(user['uid']);
                                    },
                                  );
                                } else {
                                  final followerData = snapshot.data?.data() as Map<String, dynamic>;
                                  final follower = followerData['userId'] ?? "";

                                  return follower == sp.uid.toString()
                                      ? IconButton(
                                          icon: const FaIcon(
                                            FontAwesomeIcons.userMinus,
                                            color: Colors.blueAccent,
                                            size: 19.0,
                                          ),
                                          onPressed: () {
                                            // Call the followUser method with the appropriate parameters
                                            userProvider.unfollowUser(user['uid']);
                                          },
                                        )
                                      : IconButton(
                                          icon: const FaIcon(
                                            FontAwesomeIcons.userPlus,
                                            color: Colors.blueAccent,
                                            size: 19.0,
                                          ),
                                          onPressed: () {
                                            // Call the followUser method with the appropriate parameters
                                            userProvider.followUser(user['uid']);
                                          },
                                        );
                                }
                              },
                            ),
                            onTap: userProvider.isFriend
                                ? () {
                                    Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddEvent(
                                          firstDate: _firstDay,
                                          lastDate: _lastDay,
                                          selectedDate: _selectedDay,
                                        ),
                                      ),
                                    );
                                  }
                                : () {
                                    openSnackBar(
                                        context, "To schedule event with this user you should add user to your friendList first!", Colors.green);
                                  },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
