import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:photo_view/photo_view.dart';
import '../globals.dart';
import '../models/user.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:frontend/models/reports.dart';
import 'package:frontend/models/records.dart';

User? _user;

class MedicalFolderOthers extends StatefulWidget {
  MedicalFolderOthers(user, {super.key}) {
    _user = user;
  }

  @override
  State<MedicalFolderOthers> createState() => _MedicalFolderOthersState();
}

class _MedicalFolderOthersState extends State<MedicalFolderOthers> {
  int _selectedIndex = 0;
  List<String> _titles = ['REPORTS', 'RECORDS'];
  static List<Widget> _widgetsOptions = [
    Reports(),
    Records(),
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
                  text: 'Medical Reports',
                ),
                GButton(
                  icon: LineIcons.newspaper,
                  text: 'Medical Records',
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

class Records extends StatelessWidget {
  const Records({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListRecords(),
    );
  }
}

class ListRecords extends StatefulWidget {
  const ListRecords({super.key});

  @override
  State<ListRecords> createState() => _ListRecordsState();
}

class _ListRecordsState extends State<ListRecords> {
  List<Record> records = [];

  @override
  void initState() {
    fetchRecords();
    super.initState();
  }

  void fetchRecords() async {
    var url =
        Uri.parse('http://${server}:8000/folder/others_records/${_user!.id}/');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      },
    );
    print(response.body);
    List<dynamic> data = json.decode(response.body);
    print(data);
    setState(() {
      for (Map<String, dynamic> record in data) {
        records.add(Record.fromJson(record));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildRecords(records);
  }

  Widget buildRecords(List<Record> records) => ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.all(6),
              width: double.infinity,
              height: 65,
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
                  Row(
                    children: [
                      SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${record.title}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${record.creationDate!.year}-${record.creationDate!.month}-${record.creationDate!.day}',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return detailMyRecord(context, record);
                  });
            },
          );
        },
      );
}

Widget detailMyRecord(BuildContext context, Record record) {
  return Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: Container(
      height: 500,
      child: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.transparent),
        imageProvider: NetworkImage(
            'http://$server:8000/folder/record_image/${record.id}/',
            headers: {'Authorization': 'Token $token'}),
        minScale: PhotoViewComputedScale.contained,
      ),
    ),
  );
}

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<Report> reports = [];

  @override
  void initState() {
    fetchReports();
    super.initState();
  }

  void fetchReports() async {
    var url =
        Uri.parse('http://${server}:8000/folder/others_reports/${_user!.id}/');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      },
    );
    print(response.body);
    List<dynamic> data = json.decode(response.body);
    print(data);
    setState(() {
      for (Map<String, dynamic> report in data) {
        reports.add(Report.fromJson(report));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: buildReports(reports),
    );
  }

  Widget buildReports(List<Report> reports) => ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.all(12),
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 200, 200, 200)),
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 250, 250, 250),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: Text(
                          report.content!,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                  SizedBox(width: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(report.email!,
                          style: TextStyle(color: Colors.black54)),
                      Text(
                          '${report.creationDate!.year}-${report.creationDate!.month}-${report.creationDate!.day}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  )
                ],
              ),
            ),
            onTap: () {},
          );
        },
      );
}
