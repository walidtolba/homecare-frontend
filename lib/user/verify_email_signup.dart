import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/profile.dart';
import 'package:http/http.dart';
import '../globals.dart';

class VerifyEmail extends StatefulWidget {
  String email;

  VerifyEmail({super.key, this.email: ''});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final key = GlobalKey();

  final n1 = TextEditingController();

  final n2 = TextEditingController();

  final n3 = TextEditingController();

  final n4 = TextEditingController();

  final n5 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Verification code',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 18,
              ),
              Text('We have sent the code verification'),
              SizedBox(
                height: 8,
              ),
              Text('to ${widget.email}'),
              SizedBox(
                height: 26,
              ),
              SizedBox(),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Image.asset('assets/images/email_OTP.jpg')),
              SizedBox(),
              Form(
                key: key,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 48,
                      width: 45,
                      child: TextFormField(
                        controller: n1,
                        style: Theme.of(context).textTheme.titleLarge,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.length == 1)
                            FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      height: 48,
                      width: 45,
                      child: TextFormField(
                        controller: n2,
                        style: Theme.of(context).textTheme.titleLarge,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.length == 1)
                            FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      height: 48,
                      width: 45,
                      child: TextFormField(
                        controller: n3,
                        style: Theme.of(context).textTheme.titleLarge,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.length == 1)
                            FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      height: 48,
                      width: 45,
                      child: TextFormField(
                        controller: n4,
                        style: Theme.of(context).textTheme.titleLarge,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.length == 1)
                            FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      height: 48,
                      width: 45,
                      child: TextFormField(
                        controller: n5,
                        style: Theme.of(context).textTheme.titleLarge,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.length == 1)
                            FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text('didn\'t recive the code'),
              SizedBox(
                height: 18,
              ),
              InkWell(
                child: Text('Resend code?'),
                onTap: () async {
                  try {
                    var url =
                        Uri.parse('http://${server}:8000/users/resend_code/');
                    final response = await post(url,
                        headers: {
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: json.encode({
                          'email': widget.email,
                        }));
                  } catch (e) {
                    print('${e.runtimeType}');
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
                                context, 'Unknown Error have been accured');
                          });
                    }
                  }
                },
              ),
              SizedBox(
                height: 26,
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      String? _email = await verifyEmail(
                          n1.text.trim(),
                          n2.text.trim(),
                          n3.text.trim(),
                          n4.text.trim(),
                          n5.text.trim(),
                          widget.email);
                      print(_email);
                      print(_email);

                      if (_email != null) {
                        print('useruseruser');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => CreateProfile(_email))));
                        n1.clear();
                        n2.clear();
                        n3.clear();
                        n4.clear();
                        n5.clear();
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return errorMessage(
                                  context, 'Please enter a valid code!!');
                            });
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
                                  context, 'Unknown Error has been occured!!');
                            });
                      }
                    }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    n1.dispose();
    n2.dispose();
    n3.dispose();
    n4.dispose();
    n5.dispose();
    super.dispose();
  }
}
