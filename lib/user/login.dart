import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/pateint/patient_home.dart';
import 'package:frontend/profile.dart';
import 'package:frontend/support/support_home.dart';
import 'package:frontend/user/verify_email_signup.dart';
import 'package:http/http.dart';
import '../driver/driver_home.dart';
import '../globals.dart';
import '../nurse/nurse_home.dart';
import 'signup.dart';
import 'support.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Logo(),
                SizedBox(
                  height: 50,
                ),
                LoginContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginContainer extends StatefulWidget {
  LoginContainer({super.key});
  static final double TEXTFIELDS_SPACE = 7;

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                hintText: 'Email',
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value!.isEmpty) {
                  return 'Please enter an email address';
                }
                bool isValid = RegExp(
                        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$')
                    .hasMatch(value!);
                if (!isValid) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(
              height: LoginContainer.TEXTFIELDS_SPACE,
            ),
            TextFormField(
              obscureText: _obscureText,
              controller: passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                suffixIcon: InkWell(
                  child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                border: OutlineInputBorder(),
                isDense: true,
                hintText: 'Password',
              ),
              validator: (value) {
                if (value == null || value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null; // Return null if the email is valid
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () async {
                try {
                  if (_formKey.currentState!.validate()) {
                    token = await login(emailController.text.trim(),
                        passwordController.text.trim());
                    if (token != null && token != 'verification') {
                      // ignore: await_only_futures
                      try {
                        await fetchMyProfile();
                        print('this happend');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    (myProfile!.type == 'Patient')
                                        ? PatinetHome()
                                        : (myProfile!.type == 'Driver')
                                            ? DriverHome()
                                            : (myProfile!.type == 'Support')
                                                ? SupportHome()
                                                : NurseHome())));
                      } catch (e) {
                        if (e is FormatException) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CreateProfile(
                                      emailController.text.trim()))));
                        } else if (e is TimeoutException) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return errorMessage(context, '');
                              });
                        }
                      }

                      passwordController.clear();
                    } else if (token == 'verification') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => VerifyEmail(
                                  email: emailController.text.trim()))));
                    }
                  }
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
                          return errorMessage(context,
                              'Invalid Email or Password, try again!!');
                        });
                  }
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                InkWell(
                  child: Text("Signup"),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: Text("Contact Support"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const ContanctSupport())));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  disopose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
