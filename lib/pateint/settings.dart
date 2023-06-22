import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/globals.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'package:frontend/user/change_profile_picture.dart';

class SettingsPatinet extends StatelessWidget {
  const SettingsPatinet({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SETTINGS', style: TextStyle(letterSpacing: 3)),
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
      body: SettingsContainer(),
    );
  }
}

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 170,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/profile_background.jpg'))),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'http://$server:8000/users/profile_picture/${myProfile!.id}/?fake=$random_fake_paramater'),
                radius: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text('${myProfile!.firstName} ${myProfile!.lastName}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(
                height: 4,
              ),
              Text('${myProfile!.email}', style: TextStyle(color: Colors.white))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: [
              ListTile(
                  leading: Icon(Icons.password),
                  title: Text('Change Password'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return changePassword(context);
                        });
                  }),
              Divider(
                height: 0,
              ),
              ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Change Profile Picture'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return changeProfilePicture(context);
                        });
                  }),
              Divider(
                height: 0,
              ),
              ListTile(
                leading: Icon(Icons.file_download),
                title: Text('Upload Medical Record'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return uploadMedicalRecord(context);
                      });
                },
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Add Caregiver'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return addCaregiver(context);
                        });
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

Widget addCaregiver(BuildContext context) {
  final emailController = TextEditingController();
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 240,
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ADD CAREGIVER',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Text('Enter the Caregiver email then press Submit to confirm'),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var url =
                    Uri.parse('http://${server}:8000/users/care_about_me/');
                final response = await post(url,
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': 'Token ${token}'
                    },
                    body: jsonEncode({
                      "email": emailController.text.trim(),
                    }));
                print(response.body);
                if (response.statusCode == 200) {
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            )
          ],
        )),
  );
}

Widget changePassword(BuildContext context) {
  final passwordController = TextEditingController();
  final cpasswordContrller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 340,
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Form(
          key: _formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CHANGE PASSWORD',
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Text('Enter the New Password twice then press Submit to confirm'),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(),
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null; // Return null if the email is valid
                },
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                obscureText: true,
                controller: cpasswordContrller,
                decoration: InputDecoration(),
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value != passwordController.text) {
                    return 'Please enter the same password';
                  }
                  return null; // Return null if the email is valid
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var url = Uri.parse(
                        'http://${server}:8000/users/reset_password/');
                    final response = await post(url,
                        headers: {
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization': 'Token ${token}'
                        },
                        body: jsonEncode({
                          "password": passwordController.text.trim(),
                          "cpassword": cpasswordContrller.text.trim(),
                        }));
                    print(response.body);
                    if (response.statusCode == 200) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Submit'),
              )
            ],
          ),
        )),
  );
}

Widget uploadMedicalRecord(BuildContext context) {
  final titleController = TextEditingController();
  XFile? image;
  final ImagePicker picker = ImagePicker();
  String file_name = 'Upload the record';

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
          height: 290,
          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ADD RECORD',
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Text('Enter the record title and the file then submit.'),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () async {
                    image = await picker.pickImage(source: ImageSource.gallery);
                    if (image == null) return;
                    setState(() {
                      file_name = image!.name;
                    });
                  },
                  child: Text(file_name)),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (image != null) {
                    var stream = new http.ByteStream(image!.openRead());
                    var length = await image!.length();

                    var uri =
                        Uri.parse('http://$server:8000/folder/create_record/');

                    var request = new http.MultipartRequest("POST", uri);
                    var multipartFile = new http.MultipartFile(
                        'image', stream, length,
                        filename: path.basename(image!.path));
                    //contentType: new MediaType('image', 'png'));
                    request.headers['Authorization'] = 'Token $token';
                    request.files.add(multipartFile);
                    request.fields['title'] = titleController.text.trim();
                    var response = await request.send();
                    print(response.statusCode);
                    response.stream.transform(utf8.decoder).listen((value) {
                      print(value);
                      random_fake_paramater++;
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Submit'),
              )
            ],
          )),
    );
  });
}
