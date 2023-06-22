import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/demand.dart';
import 'package:http/http.dart';
import '../globals.dart';
import 'package:line_icons/line_icons.dart';

import '../pateint/list_my_demnads.dart';

class ListOthersDemands extends StatelessWidget {
  const ListOthersDemands({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('DEMANDS', style: TextStyle(letterSpacing: 3)),
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
          child: ListOthersDemandsContainer(),
        ));
  }
}

class ListOthersDemandsContainer extends StatefulWidget {
  const ListOthersDemandsContainer({super.key});

  @override
  State<ListOthersDemandsContainer> createState() =>
      _ListOthersDemandsContainerState();
}

class _ListOthersDemandsContainerState
    extends State<ListOthersDemandsContainer> {
  List<Demand> demands = [];
  @override
  void initState() {
    fetchDemands();
    super.initState();
  }

  void fetchDemands() async {
    var url = Uri.parse('http://${server}:8000/tasks/others_demands/');
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
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(5),
              color: _itemColorInside(demand.state!),
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
                return detailOthersDemand(demand);
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
  return Colors.white;
}
