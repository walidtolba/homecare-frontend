import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/pateint/patient_profile.dart';
import 'package:frontend/nurse/settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../nurse/list_my_tasks.dart';
import '../user/about.dart';
import '../user/login.dart';
import '../user/support_user.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class DriverHome extends StatefulWidget {
  DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  List<NNotification> notifications = [];

  int _selectedIndex = 0;
  List<String> _titles = ['HOME', 'TEAM', 'DIRECTION'];
  static List<Widget> _widgetsOptions = [
    DriverHomeContainer(),
    TeamContainer(),
    DirectionContainer(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text(_titles[_selectedIndex], style: TextStyle(letterSpacing: 3)),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return showNotifications(context, notifications);
                  });
              deleteNotifications();
              setState(() {
                notifications = [];
              });
            },
            icon: Icon((notifications.isEmpty)
                ? Icons.notifications_none_sharp
                : Icons.notifications_active),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(LineIcons.rocketChat),
          ),
        ],
      ),
      drawer: DriverDrawer(),
      body: _widgetsOptions[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.car,
                  text: 'Team',
                ),
                GButton(
                  icon: LineIcons.map,
                  text: 'Direction',
                )
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  void fetchNotifications() async {
    var url = Uri.parse('http://${server}:8000/others/notifications/');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      },
    );
    print(response.body);
    List<dynamic> data = json.decode(response.body);
    setState(() {
      for (Map<String, dynamic> notification in data) {
        notifications.add(NNotification.fromJson(notification));
      }
    });
  }

  void deleteNotifications() async {
    var url = Uri.parse('http://${server}:8000/others/notifications/');
    await delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      },
    );
  }
}

class DriverHomeContainer extends StatelessWidget {
  const DriverHomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 80, 80, 90),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 42,
                          ),
                          Text(
                              'Hi ${myProfile!.firstName} ${myProfile!.lastName},',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              'Welcome to Our HomeCare App, Our goal is to serve you right on your home.',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    Image.asset('assets/images/black_background.jpg')
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Select Service',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                SizedBox(
                  width: 12,
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    height: 120,
                    width: 220,
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Suport',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Get Help',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ]),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ContanctSupportUser())));
                  },
                ),
                SizedBox(
                  width: 16,
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    height: 120,
                    width: 220,
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verify Account',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Trust Us',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ]),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SettingsNurse())));
                  },
                ),
                SizedBox(
                  width: 12,
                ),
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Other Options',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Container(
                        height: 130,
                        width: 165,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 80, 80, 90),
                                width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/driver_home_team.png'),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Team',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              )
                            ]),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: ((context) => ListOthersDemands())));
                      },
                    ),
                    InkWell(
                      child: Container(
                        height: 130,
                        width: 165,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 80, 80, 90),
                                width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  'assets/images/driver_home_direction.png'),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Directions',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              )
                            ]),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: ((context) => ListMyHistoryTasks())));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Container(
                        height: 130,
                        width: 165,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 80, 80, 90),
                                width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  'assets/images/patient_home_profile.png'),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Profile',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              )
                            ]),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ProfilePatinet())));
                      },
                    ),
                    InkWell(
                      child: Container(
                        height: 130,
                        width: 165,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 80, 80, 90),
                                width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  'assets/images/patient_home_settings.png'),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Settings',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              )
                            ]),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SettingsNurse())));
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'By Walid Tolba and Manel Abdelaziz.',
                    style: TextStyle(color: Colors.white),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class TeamContainer extends StatelessWidget {
  const TeamContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListTeam(),
    );
  }
}

class DirectionContainer extends StatefulWidget {
  DirectionContainer({super.key});

  @override
  State<DirectionContainer> createState() => _DirectionContainerState();
}

class _DirectionContainerState extends State<DirectionContainer> {
  var markers = HashSet<Marker>();
  final Completer<GoogleMapController> _controller = Completer();
  LatLng currentLocation = LatLng(36.2436564, 6.5650434);
  BitmapDescriptor finishedIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor activeIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor nextIcon = BitmapDescriptor.defaultMarker;
  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_source.png")
        .then(
      (icon) {
        activeIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_destination.png")
        .then(
      (icon) {
        finishedIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Badge.png")
        .then(
      (icon) {
        nextIcon = icon;
      },
    );
  }

  void getCurrentLocation() async {
    getUserCurrentLocation().then((value) async {
      print(value.latitude.toString() + " " + value.longitude.toString());

      CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  void launchGoogleMapsDrivingMode(LatLng value) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${value.latitude},${value.longitude}&travelmode=driving';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<List<Position>?> getDirections() async {
    var url = Uri.parse('http://${server}:8000/tasks/my_team_directions/');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      },
    );
    List<dynamic> data = json.decode(response.body);
    print(data.toString());

    setState(() {
      for (int i = 0; i < data.length; i++) {
        markers.add(Marker(
            markerId: MarkerId("$i"),
            position: LatLng(data[i]['latitude'], data[i]['longitude']),
            icon: (i != 0)
                ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
            onTap: () {
              launchGoogleMapsDrivingMode(
                  LatLng(data[i]['latitude'], data[i]['longitude']));
            }));
      }
    });
    print('marker: ' + (markers.toString()));
  }

  @override
  void initState() {
    // getPolyPoints();
    getCurrentLocation();
    getDirections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        trafficEnabled: true,
        mapToolbarEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 13.5,
        ),
        markers: markers,
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
    );
  }
}

class ListTeam extends StatefulWidget {
  const ListTeam({super.key});

  @override
  State<ListTeam> createState() => _ListDirectionContainerState();
}

class _ListDirectionContainerState extends State<ListTeam> {
  List<User> users = [];
  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  void fetchUsers() async {
    var url = Uri.parse('http://${server}:8000/tasks/my_team_members/');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      },
    );
    print(response.body);
    List<dynamic> data = json.decode(response.body);
    setState(() {
      for (Map<String, dynamic> user in data) {
        users.add(User.fromJson(user));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return buildDirectionContainer(users);
    return buildTeamMembers(users);
  }
}

Widget buildTeamMembers(List<User> users) => ListView.builder(
    itemCount: users.length,
    itemBuilder: (context, index) {
      final user = users[index];
      return InkWell(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.all(6),
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 200, 200, 200)),
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 250, 250, 250),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    CircleAvatar(
                      backgroundImage: typeToImage('Medic'),
                      radius: 40,
                    ),
                    SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(user.email!),
                      ],
                    ),
                  ]),
                ],
              )),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return showProfile(user);
                });
          });
    });

class DriverDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          InkWell(
            child: UserAccountsDrawerHeader(
              accountName:
                  Text('${myProfile!.firstName} ${myProfile!.lastName}'),
              accountEmail: Text(myProfile!.email!),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    'http://$server:8000/users/profile_picture/${myProfile!.id}/',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/profile_background.jpg')),
              ),
            ),
            onTap: () async {
              await fetchMyProfile();
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => ProfilePatinet())));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => SettingsNurse())));
            },
          ),
          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text('Support'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ContanctSupportUser())));
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('About'),
            onTap: () {
              Navigator.of(context).pop();

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return showAbout(context);
                  });
            },
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (route) => Login()));
            },
          ),
        ],
      ),
    );
  }
}
