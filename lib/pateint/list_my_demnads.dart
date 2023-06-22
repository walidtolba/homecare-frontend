import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import '../globals.dart';
import 'package:line_icons/line_icons.dart';
import '../models/demand.dart';

class ListMyDemandsContainer extends StatefulWidget {
  const ListMyDemandsContainer({super.key});
  @override
  State<ListMyDemandsContainer> createState() => _ListMyDemandsContainerState();
}

class _ListMyDemandsContainerState extends State<ListMyDemandsContainer> {
  List<Demand> demands = [];
  @override
  void initState() {
    fetchDemands();
    super.initState();
  }

  void fetchDemands() async {
    var url = Uri.parse('http://${server}:8000/tasks/my_demands/');
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
                  border: Border.all(color: Color.fromARGB(255, 200, 200, 200)),
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(255, 250, 250, 250),
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
                            'DEMAND ' + (index + 1).toString(),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          child: Icon(LineIcons.trash, color: Colors.red),
                          onTap: () async {
                            try {
                              var url = Uri.parse(
                                  'http://${server}:8000/tasks/my_demands/');
                              final response = await delete(url,
                                  headers: {
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    'Authorization': 'Token ${token}'
                                  },
                                  body: jsonEncode({
                                    "id": demand.id,
                                  }));
                              print(response.body);
                              if (response.statusCode == 200) {
                                setState(() {
                                  demands.remove(demand);
                                });
                              }
                            } catch (e) {
                              if (e is ClientException) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return errorMessage(
                                          context, 'There is no connection!!');
                                    });
                              } else if (e is TimeoutException) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return errorMessage(context,
                                          'Timeout Error, try again!!');
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return errorMessage(context,
                                          'Unknown Error has been occured');
                                    });
                              }
                            }
                          },
                        ),
                      ],
                    )
                  ],
                )),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return detailMyDemand(demand);
                  });
            });
      });
}

Widget detailMyDemand(Demand demand) {
  HashSet<Marker> markers = HashSet();
  Marker marker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(demand.latitude!, demand.longitude!));
  markers.add(marker);
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 400,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'DEMAND',
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text('Type: ${demand.type}'),
            Text(
                'Date: ${demand.creationDate!.year}-${demand.creationDate!.month}-${demand.creationDate!.day} ${demand.creationDate!.hour}:${demand.creationDate!.minute}'),
            Text('State: ${stateToString(demand.state)}'),
            Text('Is Urgance? : ${demand.isUrgent! ? 'yes' : 'no'}'),
            SizedBox(
              height: 4,
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(border: Border.all()),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(demand.latitude!, demand.longitude!),
                    zoom: 10),
                markers: markers,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text('Creator: ${demand.creator ?? 'Self'}'),
          ],
        )),
  );
}
