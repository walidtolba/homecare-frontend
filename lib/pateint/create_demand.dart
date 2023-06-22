import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:line_icons/line_icons.dart';
import '../globals.dart';

class CreateDemand extends StatefulWidget {
  final String type;
  const CreateDemand(this.type, {super.key});

  @override
  State<CreateDemand> createState() => _CreateDemandState(type);
}

class _CreateDemandState extends State<CreateDemand> {
  final double? sizeBetweenElements = 10;
  final demandTypes = ['Medic', 'Nurse'];
  String? demandType;
  final titleController = TextEditingController();
  bool isUrgent = false;
  Marker marker = Marker(
    markerId: MarkerId('me'),
    position: LatLng(36.2437767, 6.5650888),
    infoWindow: InfoWindow(
      title: 'My Location',
    ),
  );
  Completer<GoogleMapController> _controller = Completer();
  _CreateDemandState(this.demandType);
  @override
  void initState() {
    getUserCurrentLocation().then((value) async {
      print(value.latitude.toString() + " " + value.longitude.toString());

      // marker added for current users location
      marker = Marker(
        markerId: MarkerId("marker"),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: 'My Location',
        ),
      );

      // specified current users location
      CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text('CREATE DEMAND', style: TextStyle(letterSpacing: 3)),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: demandTypes.map(buildMenuItem).toList(),
                        value: demandType,
                        hint: buildMenuItem('Type'),
                        onChanged: (value) =>
                            setState(() => demandType = value),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizeBetweenElements,
                  ),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(border: Border.all()),
                      child: GoogleMap(
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(36.2437767, 6.5650888), zoom: 10),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        markers: HashSet.from([marker]),
                        onTap: (value) {
                          marker = Marker(
                            markerId: MarkerId("marker"),
                            position: LatLng(value.latitude, value.longitude),
                            infoWindow: InfoWindow(
                              title: 'My Location',
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Checkbox(
                            value: isUrgent,
                            onChanged: (value) => setState(() {
                                  isUrgent = value ?? false;
                                })),
                        Text('is is urgant?')
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Map response = await CreateDemand();
                        if (response['type'] != null) {
                          titleController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('create'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<Map> CreateDemand() async {
    var url = Uri.parse('http://${server}:8000/tasks/my_demands/');
    final response = await post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${token}'
        },
        body: json.encode({
          'type': demandType,
          'title': titleController.text.trim(),
          'longitude': marker.position.longitude,
          'latitude': marker.position.latitude,
          'is_urgent': isUrgent,
        }));
    Map data = json.decode(response.body);
    print(data);
    return data;
  }
}
