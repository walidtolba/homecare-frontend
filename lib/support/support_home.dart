import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../globals.dart';
import 'package:line_icons/line_icons.dart';

import '../models/supportMessage.dart';
import '../nurse/settings.dart';
import '../pateint/patient_profile.dart';
import '../user/about.dart';
import '../user/login.dart';

class SupportHome extends StatefulWidget {
  const SupportHome({super.key});

  @override
  State<SupportHome> createState() => _SupportHomeState();
}

class _SupportHomeState extends State<SupportHome> {
  List<SupportMessage> messages = [];

  @override
  void initState() {
    fetchSupportMessages();
    super.initState();
  }

  void fetchSupportMessages() async {
    var url = Uri.parse('http://${server}:8000/supports/answer/');
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
      for (Map<String, dynamic> message in data) {
        messages.add(SupportMessage.fromJson(message));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('HOME', style: TextStyle(letterSpacing: 3)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                messages = [];
                fetchSupportMessages();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (route) => Login()));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: buildSupportMessages(messages),
      ),
      drawer: SupportDrawer(),
    );
  }

  Widget buildSupportMessages(List<SupportMessage> messages) =>
      ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.title!,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              message.content!,
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
                          InkWell(
                            child: Icon(
                              LineIcons.trash,
                              color: Colors.red,
                            ),
                            onTap: () async {
                              var url = Uri.parse(
                                  'http://${server}:8000/supports/answer/${message.id}/');
                              final response = await delete(url,
                                  headers: {
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    'Authorization': 'Token ${token}'
                                  },
                                  body: jsonEncode({
                                    "id": message.id,
                                  }));
                              print(response.body);
                              if (response.statusCode == 200) {
                                setState(() {
                                  messages.remove(message);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 6),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(message.email!,
                          style: TextStyle(color: Colors.black54)),
                      Text(
                          '${message.creationDate!.year}-${message.creationDate!.month}-${message.creationDate!.day}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  )
                ],
              ),
            ),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return answerMessage(context, message);
                  });
              setState(() {
                this.messages = [];
                fetchSupportMessages();
              });
            },
          );
        },
      );
}

Widget answerMessage(BuildContext context, SupportMessage message) {
  final contentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 310,
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Form(
          key: _formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ANSWER MESSAGE',
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  'Content',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ),
              TextFormField(
                controller: contentController,
                decoration: InputDecoration(),
                maxLines: null,
                minLines: 5,
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null; // Return null if the email is valid
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var url = Uri.parse(
                          'http://${server}:8000/supports/answer/${message.id}/');
                      final response = await post(url,
                          headers: {
                            'Content-Type': 'application/json; charset=UTF-8',
                            'Authorization': 'Token ${token}'
                          },
                          body: jsonEncode({
                            "content": contentController.text.trim(),
                          }));
                      print(response.body);
                      if (response.statusCode == 200) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
              )
            ],
          ),
        )),
  );
}

class SupportDrawer extends StatelessWidget {
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
