import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/user/login.dart';
import 'package:http/http.dart';
import 'globals.dart';
import 'package:intl/intl.dart';

class CreateProfile extends StatelessWidget {
  final String email;
  CreateProfile(this.email, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 100, 30, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Create Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Image.asset('assets/images/ui01.jpg'),
              SizedBox(
                height: 30,
              ),
              CreateProfileContainer(email),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateProfileContainer extends StatefulWidget {
  String email;
  CreateProfileContainer(this.email, {super.key});
  @override
  State<StatefulWidget> createState() => _CreateProfileContainer(email);
}

class _CreateProfileContainer extends State<CreateProfileContainer> {
  final email;
  final double? sizeBetweenElements = 10;
  final demandTypes = ['Patient', 'Medic', 'Nurse', 'Driver', 'Support'];
  final genders = ['Male', 'Female'];
  final bloodTypes = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
  String? demandType;
  String? gender;
  String? bloodType;
  _CreateProfileContainer(this.email);

  final birthdateController = TextEditingController();
  final titleController = TextEditingController();
  bool isUrgent = false;
  @override
  Widget build(BuildContext context) {
    return Column(
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
              onChanged: (value) => setState(() => demandType = value),
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
            border: OutlineInputBorder(),
            labelText: 'Title',
          ),
        ),
        SizedBox(
          height: sizeBetweenElements,
        ),
        TextField(
          controller: birthdateController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Birth Date',
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2100));

            if (pickedDate != null) {
              print(
                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              print(
                  formattedDate); //formatted date output using intl package =>  2021-03-16
              setState(() {
                birthdateController.text = formattedDate;
              });
            } else {}
          },
        ),
        SizedBox(
          height: sizeBetweenElements,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: genders.map(buildMenuItem).toList(),
              value: gender,
              hint: buildMenuItem('Gender'),
              onChanged: (value) => setState(() => gender = value),
              isExpanded: true,
            ),
          ),
        ),
        SizedBox(
          height: sizeBetweenElements,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: bloodTypes.map(buildMenuItem).toList(),
              value: bloodType,
              hint: buildMenuItem('Blood Type'),
              onChanged: (value) => setState(() => bloodType = value),
              isExpanded: true,
            ),
          ),
        ),
        SizedBox(
          height: sizeBetweenElements,
        ),
        ElevatedButton(
            onPressed: () async {
              try {
                int? _user = await createProfile(
                  demandType!,
                  birthdateController.text.trim(),
                  gender! == 'Male' ? 'M' : 'F',
                  bloodType!,
                  titleController.text.trim(),
                  email,
                );
                if (_user != null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,
                  );
                  final birthdateController = TextEditingController();
                  titleController.clear();
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
                        return errorMessage(
                            context, 'Timeout Error, try again!!');
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return errorMessage(
                            context, 'Invalid Information may be entered');
                      });
                }
              }
            },
            child: Text('Create'))
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));
}
