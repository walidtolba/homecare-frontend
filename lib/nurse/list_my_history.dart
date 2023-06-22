import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/task.dart';
import 'package:http/http.dart';
import '../globals.dart';
import 'package:line_icons/line_icons.dart';

import '../models/task.dart';
import '../models/user.dart';
import 'list_my_tasks.dart';

class ListMyHistoryTasks extends StatelessWidget {
  const ListMyHistoryTasks({super.key});

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
          child: ListMyHistoryTasksContainer(),
        ));
  }
}

class ListMyHistoryTasksContainer extends StatefulWidget {
  const ListMyHistoryTasksContainer({super.key});

  @override
  State<ListMyHistoryTasksContainer> createState() =>
      _ListMyHistoryTasksContainerState();
}

class _ListMyHistoryTasksContainerState
    extends State<ListMyHistoryTasksContainer> {
  List<Task> tasks = [];
  @override
  void initState() {
    fetchTasks();
    super.initState();
  }

  void fetchTasks() async {
    var url = Uri.parse('http://${server}:8000/tasks/my_old_tasks/');
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
      for (Map<String, dynamic> task in data) {
        tasks.add(Task.fromJson(task));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildTasks(tasks);
  }
}

Widget _buildTasks(List<Task> tasks) => ListView.builder(
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
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(10),
              color: _itemColorInside(task.state!),
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
                              return showProfile(user);
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
                      Text('Patient: ${task.patientName}'),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Order: ${task.order}'),
                    ],
                  ),
                ]),
              ],
            )),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return detailMyTask(task);
              });
        },
      );
    });

Color _itemColorInside(String state) {
  if (state == 'C')
    return Color.fromARGB(10, 255, 0, 0);
  else if (state == 'F') return Color.fromARGB(10, 0, 255, 0);
  return Color.fromARGB(0, 0, 0, 0);
}
