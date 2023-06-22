import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget showAbout(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 470,
        padding: EdgeInsets.fromLTRB(40, 16, 40, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ABOUT',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/images/logo.webp',
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            SizedBox(
              height: 30,
            ),
            Text('This Application is end year project for NTIC students.'),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Created By:'),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Walid Tolba'),
                    SizedBox(
                      height: 4,
                    ),
                    Text('Manel Abdelaziz'),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Supervisor:'),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dr R. Mennour'),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Filter:          '),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SCI'),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            TextButton(
                child: Text('Rate us in google play'),
                onPressed: () async {
                  try {
                    Uri browserUri =
                        Uri(scheme: 'https', path: "play.google.com/");
                    await launchUrl(browserUri);
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                })
          ],
        )),
  );
}
