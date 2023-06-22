import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/demand.dart';
import 'package:http/http.dart';
import '../globals.dart';
import 'package:line_icons/line_icons.dart';

import 'list_my_demnads.dart';

class ListMyHistoryDemands extends StatelessWidget {
  const ListMyHistoryDemands({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('HISTORY', style: TextStyle(letterSpacing: 3)),
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
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListMyHistoryDemandsContainer(),
        ));
  }
}

class ListMyHistoryDemandsContainer extends StatefulWidget {
  const ListMyHistoryDemandsContainer({super.key});

  @override
  State<ListMyHistoryDemandsContainer> createState() =>
      _ListMyHistoryDemandsContainerState();
}

class _ListMyHistoryDemandsContainerState
    extends State<ListMyHistoryDemandsContainer> {
  List<Demand> demands = [];
  @override
  void initState() {
    fetchDemands();
    super.initState();
  }

  void fetchDemands() async {
    var url = Uri.parse('http://${server}:8000/tasks/my_old_demands/');
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
      for (Map<String, dynamic> demand in data) {
        demands.add(Demand.fromJson(demand));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildDemands(demands);
  }
}

Widget buildDemands(List<Demand> demands) => ListView.builder(
    itemCount: demands.length,
    itemBuilder: (context, index) {
      final demand = demands[index];
      return InkWell(
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(5),
              color: _itemColorInside(demand.state!),
              // image: DecorationImage(
              //    image: AssetImage('assets/images/background.jpg'))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  CircleAvatar(
                    backgroundImage: typeToImage(demand.type!),
                    radius: 40,
                  ),
                  SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DEMAND ' + index.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Type: ${demand.type}'),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                          'Date: ${demand.creationDate!.year}-${demand.creationDate!.month}-${demand.creationDate!.day} ${demand.creationDate!.hour}:${demand.creationDate!.minute}'),
                    ],
                  ),
                ]),
              ],
            )),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return detailMyDemand(demand);
              });
        },
      );
    });

Color _itemColorInside(String state) {
  if (state == 'T')
    return Color.fromARGB(10, 0, 0, 255);
  else if (state == 'C')
    return Color.fromARGB(10, 255, 0, 0);
  else if (state == 'F') return Color.fromARGB(10, 0, 255, 0);
  return Color.fromARGB(0, 0, 0, 0);
}
