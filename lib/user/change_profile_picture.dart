import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/globals.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

Widget changeProfilePicture(BuildContext context) {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 170,
        width: 180,
        padding: EdgeInsets.fromLTRB(26, 16, 26, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CHANGE PICTURE',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Use the media you want to use to upload the picture:',
              style: TextStyle(height: 1.2),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    image = await picker.pickImage(source: ImageSource.camera);
                    if (image == null) return;
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return confirmChangePicture(context, image!);
                        });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Camera'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    image = await picker.pickImage(source: ImageSource.gallery);
                    if (image == null) return;
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return confirmChangePicture(context, image!);
                        });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            )
          ],
        )),
  );
}

Widget confirmChangePicture(BuildContext context, XFile image) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 300,
        width: 180,
        padding: EdgeInsets.fromLTRB(26, 16, 26, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CHANGE PICTURE',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Are you sure you want to change your profile picture to:',
              style: TextStyle(height: 1.2),
            ),
            SizedBox(
              height: 16,
            ),
            CircleAvatar(
              backgroundImage: FileImage(
                File(image!.path),
              ),
              radius: 60,
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () async {
                  var stream = new http.ByteStream(image.openRead());
                  var length = await image.length();

                  var uri =
                      Uri.parse('http://$server:8000/users/profile_picture/');

                  var request = new http.MultipartRequest("POST", uri);
                  var multipartFile = new http.MultipartFile(
                      'picture', stream, length,
                      filename: path.basename(image.path));
                  //contentType: new MediaType('image', 'png'));
                  request.headers['Authorization'] = 'Token $token';
                  request.files.add(multipartFile);

                  var response = await request.send();
                  print(response.statusCode);
                  response.stream.transform(utf8.decoder).listen((value) {
                    print(value);
                    random_fake_paramater++;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Confirm'))
          ],
        )),
  );
}
