import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/nurse/list_my_history.dart';
import 'package:frontend/nurse/list_my_tasks.dart';
import 'package:frontend/pateint/list_my_history.dart';
import 'package:frontend/user/list_other_demands.dart';
import 'package:frontend/pateint/patient_profile.dart';
import 'package:frontend/nurse/settings.dart';
import 'package:http/http.dart';
import '../models/user.dart';
import '../user/about.dart';
import '../user/login.dart';
import '../user/support_user.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:frontend/user/create_demand_others.dart';

class NurseHome extends StatefulWidget {
  NurseHome({super.key});

  @override
  State<NurseHome> createState() => _NurseHomeState();
}

class _NurseHomeState extends State<NurseHome> {
  int _selectedIndex = 0;
  List<String> _titles = ['HOME', 'TASKS', 'CAREGIVING'];
  static List<Widget> _widgetsOptions = [
    _NurseHomeContainer(),
    MyTasksContainer(),
    CareGiving(),
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
            onPressed: () {},
            icon: Icon(Icons.notifications_none_sharp),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(LineIcons.rocketChat),
          ),
        ],
      ),
      drawer: NurseDrawer(),
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
                  icon: LineIcons.calendarAlt,
                  text: 'Tasks',
                ),
                GButton(
                  icon: LineIcons.heart,
                  text: 'Caregiving',
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
}

class _NurseHomeContainer extends StatelessWidget {
  const _NurseHomeContainer({super.key});

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
                              Image.asset(
                                  'assets/images/patient_home_folder.png'),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Demands',
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
                                builder: ((context) => ListOthersDemands())));
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
                                  'assets/images/patient_home_history.png'),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'History',
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
                                builder: ((context) => ListMyHistoryTasks())));
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

class MyTasksContainer extends StatelessWidget {
  const MyTasksContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListMyTasksContainer(),
    );
  }
}

class CareGiving extends StatelessWidget {
  const CareGiving({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListCareGiving(),
    );
  }
}

class ListCareGiving extends StatefulWidget {
  const ListCareGiving({super.key});

  @override
  State<ListCareGiving> createState() => _ListCareGivingState();
}

class _ListCareGivingState extends State<ListCareGiving> {
  List<User> users = [];
  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  void fetchUsers() async {
    var url = Uri.parse('http://${server}:8000/users/i_care_about/');
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
    return buildCareGiving(users);
  }
}

class NurseDrawer extends StatelessWidget {
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
                    'http://$server:8000/users/profile_picture/${myProfile!.id}/?fake=$random_fake_paramater',
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
            leading: Icon(Icons.task),
            title: Text('Demands'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ListOthersDemands())));
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ListMyHistoryTasks())));
            },
          ),
          Divider(),
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

Widget buildCareGiving(List<User> users) => ListView.builder(
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
                // image: DecorationImage(
                //    image: AssetImage('assets/images/background.jpg'))
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
                  Row(
                    children: [
                      InkWell(
                        child: Icon(LineIcons.checkCircle, color: Colors.blue),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      CreateOhtersDemand(id: user.id!))));
                        },
                      ),
                      SizedBox(width: 6)
                    ],
                  ),
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
