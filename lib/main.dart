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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> stateCPU = [];
  List<String> internalError = [];
  List<String> curDI = [];
  List<String> curDO = [];
  TextEditingController ipAddress = TextEditingController();
  TextEditingController port = TextEditingController();
  TextEditingController data = TextEditingController();
  TextEditingController indexCtrl = TextEditingController();
  TcpSocketConnection socketConnection;
  bool isConnect = false;
  final _key = GlobalKey<FormState>();
  int inputIndex = 0;
  String blockStatus = 'Blokdadı';
  Color blockColor = Colors.red;
  bool sound = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          isConnect
              ? 'CONNECTED index: $inputIndex status: $blockStatus'
              : 'NO CONNECTED',
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: isConnect ? blockColor : Colors.teal,
        actions: isConnect
            ? [
                if (sound)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.volume_up,
                      size: 30,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.volume_off,
                      size: 30,
                    ),
                  )
              ]
            : [],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
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
            TextField(
              decoration: InputDecoration(hintText: 'Əlavə olunan index'),
              controller: indexCtrl,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text('Change'),
                  onPressed: () {
                    inputIndex = int.parse(indexCtrl.text);
                    setState(() {});
                  },
                ),
                RaisedButton(
                  child: Text('Clear'),
                  onPressed: () {
                    stateCPU.clear();
                    internalError.clear();
                    curDI.clear();
                    curDO.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
            // TextField(
            //   decoration: InputDecoration(hintText: 'Data'),
            //   controller: data,
            // ),
            // RaisedButton(
            //   child: Text('Send Data'),
            //   onPressed: () {
            //     sendData();
            //   },
            // ),
            Text('state CPU'),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    height: 30,
                    width: double.infinity,
                    child: Text(
                      stateCPU[index],
                      style: TextStyle(color: Colors.indigo, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                itemCount: stateCPU.length,
              ),
            ),
            Text('Internal Error'),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    height: 30,
                    width: double.infinity,
                    child: Text(
                      internalError[index],
                      style: TextStyle(color: Colors.redAccent, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                itemCount: internalError.length,
              ),
            ),
            Text('Cur DI'),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    height: 30,
                    width: double.infinity,
                    child: Text(
                      curDI[index],
                      style: TextStyle(color: Colors.teal, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                itemCount: curDI.length,
              ),
            ),
            Text('Cur DO'),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    height: 30,
                    width: double.infinity,
                    child: Text(
                      curDO[index],
                      style: TextStyle(color: Colors.teal, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                itemCount: curDO.length,
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
    Uint8List uint8list = Uint8List.fromList(event);
    Uint16List uint16list = Uint16List.fromList(event);

    ByteBuffer buffer8 = uint8list.buffer;
    ByteBuffer buffer16 = uint16list.buffer;

    ByteData data8 = new ByteData.view(buffer8);
    ByteData data16 = new ByteData.view(buffer16);
    int inputStateCPU = data8.getInt8(87 + inputIndex);
    int inputStateBlock = data8.getInt8(156 + inputIndex);
    int inputAudio = data8.getInt8(157 + inputIndex);
    int inputCurDI = data8.getInt8(88 + inputIndex);
    int inputCurDO = data8.getInt8(89 + inputIndex);
    int inputInternalError = data16.getInt16(146 + inputIndex, Endian.little);

    //state cpu
    int onReady = 1;
    int onStart = 2;
    int onBurning = 4;
    int inWork = 8;
    int onStop = 16;
    int onTanking = 32;
    int onTankFull = 64;
    int onErrorCI = 128;
    //curDI
    int lowLevelFuelTank = 1;
    int lowHightFuelTank = 2;
    int lowAlertFuelTank = 4;
    int fuelLeakage = 8;
    int fillingHatchOpen = 16;
    //stateBlock
    int openBlock = 0;
    //stateAudio
    int mute = 0;
    //curDO
    int tankOpenKey = 1;
    //InternalError
    int fleshMemory = 1;
    int tankTSF = 2;
    int evaporatorTSF = 4;
    int noseTSF = 8;
    int frontPanelTSF = 16;

    //block start
    if (inputStateBlock == openBlock) {
      blockColor = Colors.green;
      blockStatus = 'Blokdan Çıxarıldı';
    } else {
      blockStatus = 'Blokdadı';
      blockColor = Colors.red;
    }
    setState(() {});
    //block end

    //mute start
    if (inputAudio == mute) {
      sound = false;
    } else {
      sound = true;
    }
    setState(() {});
    //mute end

    //state Cpu start
    if (inputStateCPU & onReady == onReady) {
      stateCPU.insert(0, 'Ready - $inputIndex');
    }
    if (inputStateCPU & onStart == onStart) {
      stateCPU.insert(0, 'Start - $inputIndex');
    }

    if (inputStateCPU & onBurning == onBurning) {
      stateCPU.insert(0, 'Burning - $inputIndex');
    }

    if (inputStateCPU & inWork == inWork) {
      stateCPU.insert(0, 'inWork - $inputIndex');
    }

    if (inputStateCPU & onStop == onStop) {
      stateCPU.insert(0, 'Stop - $inputIndex');
    }

    if (inputStateCPU & onTanking == onTanking) {
      stateCPU.insert(0, 'Tanking - $inputIndex');
    }

    if (inputStateCPU & onTankFull == onTankFull) {
      stateCPU.insert(0, 'Tank Full - $inputIndex');
    }

    if (inputStateCPU & onErrorCI == onErrorCI) {
      //internal error start
      if (inputInternalError & fleshMemory == fleshMemory) {
        internalError.insert(0, 'Flash yaddaş mövcud deyil - $inputIndex');
      }
      if (inputInternalError & tankTSF == tankTSF) {
        internalError.insert(
            0, 'Tank temperatur sensörünün nasazlığı - $inputIndex');
      }
      if (inputInternalError & evaporatorTSF == evaporatorTSF) {
        internalError.insert(
            0, 'Buxarlayıcı temperatur sensörünün nasazlığı - $inputIndex');
      }
      if (inputInternalError & noseTSF == noseTSF) {
        internalError.insert(
            0, 'Burun temperatur sensörünün nasazlığı - $inputIndex');
      }
      if (inputInternalError & frontPanelTSF == frontPanelTSF) {
        internalError.insert(
            0, 'Ön panelin temperatur sensorunun nasazlığı - $inputIndex');
      }
      setState(() {});
      //internal error end
    }
    setState(() {});
    //state Cpu end

    //curDI start
    if (inputCurDI & lowLevelFuelTank == lowLevelFuelTank) {
      curDI.insert(0, 'çəndəki yanacağın aşağı səviyyəsi (L) - $inputIndex');
    }
    if (inputCurDI & lowHightFuelTank == lowHightFuelTank) {
      curDI.insert(0, 'çəndəki yanacağın yuxarı səviyyəsi (H) - $inputIndex');
    }
    if (inputCurDI & lowAlertFuelTank == lowAlertFuelTank) {
      curDI.insert(0, 'tankdakı təcili yanacaq səviyyəsi (H +) - $inputIndex');
    }
    if (inputCurDI & fuelLeakage == fuelLeakage) {
      curDI.insert(0, 'yanacaq sızması - $inputIndex');
    }
    if (inputCurDI & fillingHatchOpen == fillingHatchOpen) {
      curDI.insert(0, 'doldurma lyuku açıqdır - $inputIndex');
    }
    setState(() {});
    //curDi end
    curDO.clear();
    setState(() {});
    //curDO start
    if (inputCurDO & tankOpenKey == tankOpenKey) {
      curDO.insert(0, 'doldurma lyukunun kilidi açılıq - $inputIndex');
      setState(() {});
    }

    //curDO end
  }

  void sendData() {
    if (isConnect) {
      socketConnection.sendMessage(data.text);
      data.clear();
    }
  }
}
