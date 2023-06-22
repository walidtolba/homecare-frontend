import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/user/list_other_demands.dart';
import 'package:http/http.dart';
import '../nurse/list_my_tasks.dart';
import '../user/create_demand_others.dart';
import 'create_demand.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:frontend/globals.dart';
import '../models/user.dart';

class CareGiving extends StatefulWidget {
  CareGiving({super.key});

  @override
  State<CareGiving> createState() => _CareGivingState();
}

class _CareGivingState extends State<CareGiving> {
  int _selectedIndex = 0;
  String _titles = 'CAREGIVING';
  static List<Widget> _widgetsOptions = [
    ICareAboutContainer(),
    CareAboutMe(),
    Padding(
      padding: const EdgeInsets.all(16),
      child: ListOthersDemandsContainer(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_titles, style: TextStyle(letterSpacing: 3)),
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
                  icon: LineIcons.doctor,
                  text: 'I Care About',
                ),
                GButton(
                  icon: LineIcons.newspaper,
                  text: 'Care About Me',
                ),
                GButton(
                  icon: LineIcons.newspaper,
                  text: 'Others Demands',
                ),
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

class ICareAboutContainer extends StatelessWidget {
  const ICareAboutContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListICareAboutContainer(),
    );
  }
}

class ListICareAboutContainer extends StatefulWidget {
  const ListICareAboutContainer({super.key});

  @override
  State<ListICareAboutContainer> createState() =>
      _ListICareAboutContainerState();
}

class _ListICareAboutContainerState extends State<ListICareAboutContainer> {
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
    return buildICareAbout(users);
  }
}

class ListCareAboutMe extends StatefulWidget {
  const ListCareAboutMe({super.key});

  @override
  State<ListCareAboutMe> createState() => _ListCareAboutMeState();
}

class _ListCareAboutMeState extends State<ListCareAboutMe> {
  List<User> users = [];
  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  void fetchUsers() async {
    var url = Uri.parse('http://${server}:8000/users/care_about_me/');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      },
    );
    List<dynamic> data = json.decode(response.body);
    print(data);
    setState(() {
      for (Map<String, dynamic> user in data) {
        users.add(User.fromJson(user));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildCareAboutMe(users);
  }

  Widget buildCareAboutMe(List<User> users) => ListView.builder(
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
                        IconButton(
                          icon: Icon(LineIcons.removeUser, color: Colors.red),
                          onPressed: () async {
                            var url = Uri.parse(
                                'http://${server}:8000/users/care_about_me/');
                            final response = await delete(url,
                                headers: {
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': 'Token ${token}'
                                },
                                body: jsonEncode({
                                  "id": user.id,
                                }));
                            if (response.statusCode == 200) {
                              setState(() {
                                users.remove(user);
                              });
                            }
                          },
                        ),
                        SizedBox(width: 2)
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
}

Widget buildICareAbout(List<User> users) => ListView.builder(
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

class CareAboutMe extends StatelessWidget {
  const CareAboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListCareAboutMe(),
    );
  }
}
