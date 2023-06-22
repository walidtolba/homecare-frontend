import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/nurse/list_others_medical_folder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import '../globals.dart';
import 'package:line_icons/line_icons.dart';
import '../models/task.dart';
import '../models/user.dart';

class ListMyTasksContainer extends StatefulWidget {
  const ListMyTasksContainer({super.key});
  @override
  State<ListMyTasksContainer> createState() => _ListMyTasksContainerState();
}

class _ListMyTasksContainerState extends State<ListMyTasksContainer> {
  List<Task> tasks = [];
  @override
  void initState() {
    fetchTasks();
    super.initState();
  }

  void fetchTasks() async {
    var url = Uri.parse('http://${server}:8000/tasks/onme_tasks/');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      },
    );
    List<dynamic> data = json.decode(response.body);
    setState(() {
      for (Map<String, dynamic> task in data) {
        tasks.add(Task.fromJson(task));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildTasks(tasks);
  }

  Widget buildTasks(List<Task> tasks) => ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
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
                      InkWell(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'http://$server:8000/users/profile_picture/${task.patient}/'),
                          radius: 40,
                        ),
                        onTap: () async {
                          User? user = await fetchProfile(task.patient!);
                          print(user);
                          if (user != null) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return (myProfile!.type == 'Medic')
                                      ? showProfileForMedic(user, context)
                                      : showProfile(user);
                                });
                          }
                        },
                      ),
                      SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TASK ' + (index + 1).toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text('Worker: ${task.patientName}'),
                          SizedBox(
                            height: 4,
                          ),
                          Text('Order: ${task.order}'),
                        ],
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'turn',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            '${task.turn}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),
                    )
                  ],
                )),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return detailMyTask(task);
                  });
            });
      });
}

Future<User?> fetchProfile(int id) async {
  var url = Uri.parse('http://${server}:8000/users/profile/$id/');
  final response = await get(url, headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token ${token}'
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return User.fromJson(data);
  }
}

Widget detailMyTask(Task task) {
  HashSet<Marker> markers = HashSet();
  Marker marker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(task.latitude!, task.longitude!));
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
                'TASK',
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text('Team: ${task.team}'),
            Text('Order: ${task.order}'),
            Text(
                'Date: ${task.creationDate!.year}-${task.creationDate!.month}-${task.creationDate!.day} ${task.creationDate!.hour}:${task.creationDate!.minute}'),
            Text('State: ${stateToString(task.state)}'),
            SizedBox(
              height: 4,
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(border: Border.all()),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(task.latitude!, task.longitude!), zoom: 10),
                markers: markers,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text('Worker: ${task.patientName}'),
          ],
        )),
  );
}

String stateToString(state) {
  Map<String, String> map = {
    'A': 'Active',
    'T': 'Tasksed',
    'C': 'Canceld',
    'F': 'Finished',
  };
  return map[state] ?? 'unknown';
}

Widget showProfile(User user) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      height: 420,
      width: 200,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/profile_background.jpg'))),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'http://$server:8000/users/profile_picture_png/${user.id}/'),
                  radius: 40,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('${user.firstName} ${user.lastName}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(
                  height: 4,
                ),
                Text(user.email!, style: TextStyle(color: Colors.white))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24, 16, 24, 8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(6)),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.calendar_month,
                    size: 35,
                  ),
                  title: Text('Brith Date'),
                  subtitle: Text(
                      '${user.birthDate!.year}-${user.birthDate!.month}-${user.birthDate!.day}'),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 35,
                  ),
                  title: Text('Gender'),
                  subtitle: Text(user.gender!),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 35,
                  ),
                  title: Text('Blood Type'),
                  subtitle: Text(user.bloodType!),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget showProfileForMedic(User user, context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      height: 470,
      width: 200,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/profile_background.jpg'))),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'http://$server:8000/users/profile_picture_png/${user.id}/'),
                  radius: 40,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('${user.firstName} ${user.lastName}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(
                  height: 4,
                ),
                Text(user.email!, style: TextStyle(color: Colors.white))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24, 16, 24, 8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(6)),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.calendar_month,
                    size: 35,
                  ),
                  title: Text('Brith Date'),
                  subtitle: Text(
                      '${user.birthDate!.year}-${user.birthDate!.month}-${user.birthDate!.day}'),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 35,
                  ),
                  title: Text('Gender'),
                  subtitle: Text(user.gender!),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 35,
                  ),
                  title: Text('Blood Type'),
                  subtitle: Text(user.bloodType!),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 26),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => MedicalFolderOthers(user))));
              },
              child: Text('Show Medical Folder'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(40),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget writeReport(BuildContext context, int patient) {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 410,
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WRITE REPORT',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Text('Press Submit to save the report, otherwise press Ignore.'),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: Text(
                'Title',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: Text(
                'Content',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(),
              maxLines: null,
              minLines: 5,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () async {
                      var url = Uri.parse(
                          'http://${server}:8000/folder/others_reports/');
                      final response = await post(url,
                          headers: {
                            'Content-Type': 'application/json; charset=UTF-8',
                            'Authorization': 'Token ${token}'
                          },
                          body: jsonEncode({
                            "title": titleController.text.trim(),
                            "content": titleController.text.trim(),
                            "to": patient,
                          }));
                      print(response.body);
                      if (response.statusCode == 200) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ignore'),
                  ),
                )
              ],
            )
          ],
        )),
  );
}
