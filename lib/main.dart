import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tcp_test_app/tcp_socket_connection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Socket socket;
  List<String> listData = [];
  TextEditingController ipAddress = TextEditingController();
  TextEditingController port = TextEditingController();
  TextEditingController data = TextEditingController();
  TextEditingController indexCtrl = TextEditingController();
  TcpSocketConnection socketConnection;
  bool isConnect = false;
  final _key = GlobalKey<FormState>();
  int inputIndex = 86;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            Text(isConnect ? 'CONNECTED - index: $inputIndex' : 'NO CONNECTED'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Column(
          children: <Widget>[
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: 'IP address'),
                    controller: ipAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Boş qoymayın';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Port'),
                    controller: port,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Boş qoymayın';
                      }
                      return null;
                    },
                  ),
                  RaisedButton(
                    child: Text('Connect'),
                    onPressed: () {
                      connect();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(hintText: 'index'),
              controller: indexCtrl,
            ),
            RaisedButton(
              child: Text('Change index'),
              onPressed: () {
                inputIndex = int.parse(indexCtrl.text);
                setState(() {});
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(hintText: 'Data'),
              controller: data,
            ),
            RaisedButton(
              child: Text('Send Data'),
              onPressed: () {
                sendData();
              },
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    height: 30,
                    width: double.infinity,
                    child: Text(
                      listData[index],
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                itemCount: listData.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> connect() async {
    if (_key.currentState.validate()) {
      socketConnection =
          TcpSocketConnection(ipAddress.text, int.parse(port.text));
      socketConnection.enableConsolePrint(
          true); //use this to see in the console what's happening
      if (await socketConnection.canConnect(5000, attempts: 3)) {
        //check if it's possible to connect to the endpoint
        await socketConnection.connect(5000, messageReceived, attempts: 3);
        isConnect = true;
        setState(() {});
      }
    }
  }

  void messageReceived(List<int> event) {
    List<String> commandList = [];
    Uint8List uint8list = Uint8List.fromList(event);

    int input = uint8list[inputIndex];

    int onReady = 128;
    int onStart = 64;
    int onBurning = 32;
    int inWork = 16;
    int onStop = 8;
    int onTanking = 4;
    int onTankFull = 2;
    int onErrorCI = 1;

    if (input & onReady == onReady) {
      commandList.insert(0, 'Ready');
    }
    if (input & onStart == onStart) {
      commandList.insert(0, 'Start');
    }

    if (input & onBurning == onBurning) {
      commandList.insert(0, 'Burning');
    }

    if (input & inWork == inWork) {
      commandList.insert(0, 'inWork');
    }

    if (input & onStop == onStop) {
      commandList.insert(0, 'Stop');
    }

    if (input & onTanking == onTanking) {
      commandList.insert(0, 'Tanking');
    }

    if (input & onTankFull == onTankFull) {
      commandList.insert(0, 'Tank Full');
    }

    if (input & onErrorCI == onErrorCI) {
      commandList.insert(0, 'Error CPU Internal');
    }
    setState(() {
      listData = commandList;
    });
  }

  void sendData() {
    if (isConnect) {
      socketConnection.sendMessage(data.text);
      data.clear();
    }
  }
}
