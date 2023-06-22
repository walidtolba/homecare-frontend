import 'package:flutter/material.dart';
import 'package:frontend/globals.dart';
import 'package:http/http.dart';
import 'package:line_icons/line_icons.dart';

class SupportMessageContainter extends StatelessWidget {
  SupportMessageContainter({super.key});
  final titleController = TextEditingController();
  final emailController = TextEditingController();

  final messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.3,
                  child: Image.asset('assets/images/support.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Support Service'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.message),
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null; // Return null if the email is valid
                  },
                ),
                SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    labelText: 'Email',
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
                  height: 7,
                ),
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  minLines: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print('hi');
                      String? email = await askSupport(
                          emailController.text.trim(),
                          titleController.text.trim(),
                          messageController.text.trim());
                      print('end');
                      if (email != null) {
                        emailController.clear();
                        emailController.clear();
                        titleController.clear();
                        messageController.clear();
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContanctSupportUser extends StatelessWidget {
  const ContanctSupportUser({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SUPPORT', style: TextStyle(letterSpacing: 3)),
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
      body: SupportMessageContainter(),
    );
  }
}
