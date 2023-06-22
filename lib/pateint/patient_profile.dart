import 'package:flutter/material.dart';
import 'package:frontend/globals.dart';
import 'package:http/http.dart';
import 'package:line_icons/line_icons.dart';

class ProfilePatinet extends StatelessWidget {
  const ProfilePatinet({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('PROFILE', style: TextStyle(letterSpacing: 3)),
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
      body: ProfileContainer(),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({super.key});

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
              Text(myProfile!.email!, style: TextStyle(color: Colors.white))
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
                  Icons.work,
                  size: 35,
                ),
                title: Text('Type'),
                subtitle: Text(myProfile!.type!),
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                leading: Icon(
                  Icons.email,
                  size: 35,
                ),
                title: Text('Email'),
                subtitle: Text(myProfile!.email!),
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  size: 35,
                ),
                title: Text('First Name'),
                subtitle: Text(myProfile!.firstName!),
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  size: 35,
                ),
                title: Text('Last Name'),
                subtitle: Text(myProfile!.lastName!),
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                leading: Icon(
                  Icons.calendar_month,
                  size: 35,
                ),
                title: Text('Brith Date'),
                subtitle: Text(
                    '${myProfile!.birthDate!.year}-${myProfile!.birthDate!.month}-${myProfile!.birthDate!.day}'),
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                leading: Icon(
                  myProfile!.gender == 'M' ? Icons.male : Icons.female,
                  size: 35,
                ),
                title: Text('Gender'),
                subtitle: Text(myProfile!.gender!),
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                leading: Icon(
                  Icons.bloodtype,
                  size: 35,
                ),
                title: Text('Blood Type'),
                subtitle: Text(myProfile!.bloodType!),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
