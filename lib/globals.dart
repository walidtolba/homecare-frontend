import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/demand.dart';
import 'models/notification.dart';
import 'models/user.dart';

SharedPreferences? prefs;

String? token; // change this to another storage
User? myProfile;
String server = '192.168.233.163';
final google_api_key = 'AIzaSyC2OZmgxMEhS7U5BDWxWzMql41TcLmJTFg';
int random_fake_paramater = 0;

const willayas = [
  '01. Adrar',
  '02. Chlef',
  '03. Laghouat',
  '04. Oum El Bouaghi',
  '05. Batna',
  '06. Bejaia',
  '07. Biskra',
  '08. Bechar',
  '09. Blida',
  '10. Bouïra',
  '11. Tamanrasset ',
  '12. Tebessa ',
  '13. Tlemcen',
  '14. Tiaret',
  '15. Tizi Ouzou',
  '16. Algiers',
  '17. Djelfa',
  '18. Jijel',
  '19. Setif ',
  '20. Saïda',
  '21. Skikda',
  '22. Sidi Bel Abbes',
  '23. Annaba',
  '24. Guelma',
  '25. Constantine',
  '26. Medea',
  '27. Mostaganem',
  '28. M\'Sila ',
  '29. Mascara',
  '30. Ouargla',
  '31. Oran',
  '32. El Bayadh',
  '33. Illizi',
  '34. Bordj Bou Arreridj ',
  '35. Boumerdes',
  '36. El Tarf',
  '37. Tindouf',
  '38. Tissemsilt',
  '39. El Oued',
  '40. Khenchela ',
  '41. Souk Ahras',
  '42. Tipaza',
  '43. Mila',
  '44. Aïn Defla',
  '45. Naama ',
  '46. Aïn Témouchent',
  '47. Ghardaïa',
  '48. Relizane',
  '49. El M\'Ghair',
  '50. El Menia',
  '51. Ouled Djellal',
  '52. Bordj Baji Mokhtar',
  '53. Beni Abbes',
  '54. Timimoun',
  '55. Touggourt',
  '56. Djanet',
  '57. Ain Salah',
  '58. Ain Guezzam'
];

void getPrefs() async {
  prefs = await SharedPreferences.getInstance();
}

Future<String?> login(String email, String password) async {
  var url = Uri.parse('http://${server}:8000/users/login/');
  final response = await post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }));
  Map data = json.decode(response.body);
  prefs!.setString('token', data['token']);
  return data['token'];
}

Future<String?> signup(String email, String firstName, String lastName,
    String password, String confirmationPassword) async {
  var url = Uri.parse('http://${server}:8000/users/signup/');
  final response = await post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'cpassword': confirmationPassword,
      }));
  Map data = json.decode(response.body);
  print(data['email']);
  return data['email'];
}

Future<String?> verifyEmail(
    String n1, String n2, String n3, String n4, String n5, String email) async {
  var url = Uri.parse('http://${server}:8000/users/verify-signup/');
  final response = await post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'code': '$n1$n2$n3$n4$n5',
      }));
  print(email);
  print('$n1$n2$n3$n4$n5');
  Map data = json.decode(response.body);
  return data['email'];
}

Future<int?> createProfile(
  String type,
  String birthDate,
  String gender,
  String bloodType,
  String title,
  String email,
) async {
  var url = Uri.parse('http://${server}:8000/users/profile/');
  final response = await post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'type': type,
        'title': title,
        'birth_date': birthDate,
        'gender': gender,
        'blood_type': bloodType,
      }));
  Map data = json.decode(response.body);
  print(data);
  return data['user'];
}

Future<String?> askSupport(String email, String title, String content) async {
  var url = Uri.parse('http://${server}:8000/supports/ask/');
  final response = await post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'title': title,
        'content': content,
      }));
  Map data = json.decode(response.body);
  return data['email'];
}

Future<List<Demand>> getMyDemands() async {
  var url = Uri.parse('http://${server}:8000/tasks/my_demands/');
  final response = await get(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token ${token}'
    },
  );
  Map data = json.decode(response.body);
  print(data);
  return data['user'];
}

class Logo extends StatelessWidget {
  const Logo({super.key});
  @override
  build(BuildContext context) {
    return Container(
      child: Image.asset('assets/images/logo.webp'),
      width: MediaQuery.of(context).size.width * 0.5,
    );
  }
}

Future<void> fetchMyProfile() async {
  var url = Uri.parse('http://${server}:8000/users/my_profile/');
  final response = await get(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token ${token}'
    },
  );
  Map<String, dynamic> data = json.decode(response.body);
  myProfile = User.fromJson(data);
}

AssetImage typeToImage(String type) {
  if (type == 'Medic')
    return const AssetImage('assets/images/doctor_avatar.png');
  else if (type == 'Nurse')
    return const AssetImage('assets/images/nurse_avatar.png');
  else if (type == 'Driver')
    return const AssetImage('assets/images/driver_avatar.png');
  return AssetImage('');
}

Widget errorMessage(BuildContext context, String message) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 150,
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ERROR',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Text(message),
          ],
        )),
  );
}

Widget detailOthersDemand(Demand demand) {
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
            Text('User: ${demand.user ?? 'Self'}'),
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

Widget showNotifications(
    BuildContext context, List<NNotification> notifications) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 240,
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: SizedBox(
                height: 400,
                child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return ListTile(
                        title: Text(notification.content!),
                        subtitle: Text(
                            '${notification.creationDate!.year}-${notification.creationDate!.month}-${notification.creationDate!.day} ${notification.creationDate!.hour}:${notification.creationDate!.minute}'),
                      );
                    }),
              ),
            )
          ],
        )),
  );
}
