import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/globals.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

import 'package:frontend/user/change_profile_picture.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class SettingsNurse extends StatelessWidget {
  const SettingsNurse({super.key});
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
                  leading: Icon(Icons.favorite),
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
                  leading: Icon(Icons.favorite),
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
                leading: Icon(Icons.favorite),
                title: (!myProfile!.isAbsent!)
                    ? Text('Declare Absance')
                    : Text('Remove Absance'),
                onTap: () {
                  if (!myProfile!.isAbsent!)
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return declareAbsance(context);
                        });
                  else
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return removeAbsance(context);
                        });
                },
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Verify Account'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return verifyAccount(context);
                        });
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

Widget verifyAccount(BuildContext context) {
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
                'VERIFY ACCOUNT',
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
                        Uri.parse('http://$server:8000/users/create_record/');

                    var request = new http.MultipartRequest("POST", uri);
                    var multipartFile = new http.MultipartFile(
                        'image', stream, length,
                        filename: path.basename(image!.path));
                    //contentType: new MediaType('image', 'png'));
                    request.headers['Authorization'] = 'Token $token';
                    request.files.add(multipartFile);
                    request.fields['type'] = titleController.text.trim();
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

Widget declareAbsance(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 170,
        width: 180,
        padding: EdgeInsets.fromLTRB(36, 16, 36, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DECLARE ABSANCEA',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Are you sure you want to declare absance?',
              style: TextStyle(height: 1.2),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var url =
                    Uri.parse('http://${server}:8000/users/declare_absance/');
                final response = await post(
                  url,
                  headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Token ${token}'
                  },
                );
                print(response.body);
                if (response.statusCode == 200) {
                  await fetchMyProfile();
                  Navigator.pop(context);
                }
              },
              child: Text('Confirm'),
            )
          ],
        )),
  );
}

Widget removeAbsance(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 170,
        width: 180,
        padding: EdgeInsets.fromLTRB(36, 16, 36, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REMOVE ABSANCE',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Are you sure you want to remove absance?',
              style: TextStyle(height: 1.2),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var url =
                    Uri.parse('http://${server}:8000/users/declare_absance/');
                final response = await delete(
                  url,
                  headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Token ${token}'
                  },
                );
                print(response.body);
                if (response.statusCode == 200) {
                  await fetchMyProfile();
                  Navigator.pop(context);
                }
              },
              child: Text('Confirm'),
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
