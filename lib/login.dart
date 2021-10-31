import 'package:flutter/material.dart';

import 'home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _key = GlobalKey<FormState>();
  TextEditingController ipAddress = TextEditingController();
  TextEditingController port = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 1),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: 'IP address'),
                      controller: ipAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Boş qoymayın';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Port'),
                      controller: port,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Boş qoymayın';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.indigo,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                  ipAddress: ipAddress.text,
                                  port: port.text,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
