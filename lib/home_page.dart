import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tcp_test_app/tcp_socket_connection.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.ipAddress, required this.port})
      : super(key: key);
  final String ipAddress;
  final String port;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> stateCPU = [];
  List<String> internalError = [];
  List<String> errorCPU = [];
  List<String> curDI = [];
  String curDO = '';
  TcpSocketConnection? socketConnection;
  bool isConnect = false;
  String blockStatus = 'Blokdadı';
  Color blockColor = Colors.red;
  bool sound = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          isConnect ? 'CONNECTED status: $blockStatus' : 'NO CONNECTED',
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
            Container(
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        'Start/Stop',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      onPressed: () {
                        Uint8List uint8list = Uint8List(164);
                        ByteBuffer buffer8 = uint8list.buffer;
                        ByteData data8 = new ByteData.view(buffer8);
                        data8.setInt8(0, 126);
                        data8.setInt8(1, 8);
                        data8.setInt8(2, 1);
                        data8.setInt8(162, 153);
                        data8.setInt8(163, 178);

                        Uint8List uint8Send = data8.buffer.asUint8List();
                        List<int> sendMessage = uint8Send.toList();
                        sendData(sendMessage);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: RaisedButton(
                      color: Colors.indigo,
                      child: Text(
                        'Blok et/Çıxar',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      onPressed: () {
                        Uint8List uint8list = Uint8List(164);
                        ByteBuffer buffer8 = uint8list.buffer;
                        ByteData data8 = new ByteData.view(buffer8);
                        data8.setInt8(0, 126);
                        data8.setInt8(1, 8);
                        data8.setInt8(2, 9);
                        data8.setInt8(162, 158);
                        data8.setInt8(163, 78);

                        Uint8List uint8Send = data8.buffer.asUint8List();
                        List<int> sendMessage = uint8Send.toList();
                        sendData(sendMessage);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: RaisedButton(
                      color: Colors.cyan,
                      child: Text(
                        'Sound enable/disable',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      onPressed: () {
                        Uint8List uint8list = Uint8List(164);
                        ByteBuffer buffer8 = uint8list.buffer;
                        ByteData data8 = new ByteData.view(buffer8);
                        data8.setInt8(0, 126);
                        data8.setInt8(1, 8);
                        data8.setInt8(2, 4);
                        data8.setInt8(162, 166);
                        data8.setInt8(163, 106);

                        Uint8List uint8Send = data8.buffer.asUint8List();
                        List<int> sendMessage = uint8Send.toList();
                        sendData(sendMessage);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: RaisedButton(
                      color: Colors.orange,
                      child: Text(
                        'Hatch open',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      onPressed: () {
                        Uint8List uint8list = Uint8List(164);
                        ByteBuffer buffer8 = uint8list.buffer;
                        ByteData data8 = new ByteData.view(buffer8);
                        data8.setInt8(0, 126);
                        data8.setInt8(1, 8);
                        data8.setInt8(2, 5);
                        data8.setInt8(162, 148);
                        data8.setInt8(163, 10);

                        Uint8List uint8Send = data8.buffer.asUint8List();
                        List<int> sendMessage = uint8Send.toList();
                        sendData(sendMessage);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: RaisedButton(
                      color: Colors.orange,
                      child: Text(
                        '+',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Uint8List uint8list = Uint8List(164);
                        ByteBuffer buffer8 = uint8list.buffer;
                        ByteData data8 = new ByteData.view(buffer8);
                        data8.setInt8(0, 126);
                        data8.setInt8(1, 8);
                        data8.setInt8(2, 12);
                        data8.setInt8(162, 161);
                        data8.setInt8(163, 150);

                        Uint8List uint8Send = data8.buffer.asUint8List();
                        List<int> sendMessage = uint8Send.toList();
                        sendData(sendMessage);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: RaisedButton(
                      color: Colors.orange,
                      child: Text(
                        '-',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Uint8List uint8list = Uint8List(164);
                        ByteBuffer buffer8 = uint8list.buffer;
                        ByteData data8 = new ByteData.view(buffer8);
                        data8.setInt8(0, 126);
                        data8.setInt8(1, 8);
                        data8.setInt8(2, 6);
                        data8.setInt8(162, 191);
                        data8.setInt8(163, 90);

                        Uint8List uint8Send = data8.buffer.asUint8List();
                        List<int> sendMessage = uint8Send.toList();
                        sendData(sendMessage);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: Colors.green,
                  child: Text(
                    'Connect',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    connect();
                  },
                ),
                RaisedButton(
                  color: Colors.red[400],
                  child: Text(
                    'Clear',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    stateCPU.clear();
                    internalError.clear();
                    curDI.clear();
                    curDO = '';
                    errorCPU.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
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
            Text('Cpu Error'),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    height: 30,
                    width: double.infinity,
                    child: Text(
                      errorCPU[index],
                      style: TextStyle(color: Colors.redAccent, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                itemCount: errorCPU.length,
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
            Text(
              curDO,
              style: TextStyle(color: Colors.teal, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> connect() async {
    if (widget.port.isNotEmpty && widget.ipAddress.isNotEmpty) {
      socketConnection =
          TcpSocketConnection(widget.ipAddress, int.parse(widget.port));
      socketConnection!.enableConsolePrint(
          true); //use this to see in the console what's happening
      if (await socketConnection!.canConnect(5000, attempts: 3)) {
        //check if it's possible to connect to the endpoint
        await socketConnection!.connect(5000, messageReceived, attempts: 3);
        isConnect = true;
        setState(() {});
      }
    }
  }

  void messageReceived(List<int> event) {
    Uint8List uint8list = Uint8List.fromList(event);
    ByteBuffer buffer8 = uint8list.buffer;
    ByteData data8 = new ByteData.view(buffer8);

    int inputStateCPU = data8.getInt8(87);
    int inputStateBlock = data8.getInt8(156);
    int inputAudio = data8.getInt8(157);
    int inputCurDI = data8.getInt8(88);
    int inputCurDO = data8.getInt8(89);

    int inputInternalError = data8.getInt16(146, Endian.little);
    int inputCPUError = data8.getInt32(105, Endian.little);

    //state cpu
    int onReady = 1;
    int onStart = 2;
    int onBurning = 4;
    int inWork = 8;
    int onStop = 16;
    int onTanking = 32;
    int onTankFull = 64;
    int onErrorCI = 128;
    //error Cpu
    int intErr = 1;
    int fuelLow = 2;
    int tooHotBur = 4;
    int hotTank = 8;
    int extT_Abnorm_Err = 16;
    int fuelAlarm = 32;
    int doorOpenErr = 64;
    int burnFail = 128;
    int evapFail = 256;
    int cO2Err = 512;
    int erPanel = 1024;
    int blowOut = 2048;
    int fuelSpillAlarmD = 4096;
    int tooHotEvap = 8192;
    int erOutT = 16384;
    int fuelSpillAlarmS = 32768;
    int erAdPump = 65536;
    int erSenLevel = 131072;
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
      stateCPU.insert(0, 'Ready');
    }
    if (inputStateCPU & onStart == onStart) {
      stateCPU.insert(0, 'Start');
    }

    if (inputStateCPU & onBurning == onBurning) {
      stateCPU.insert(0, 'Burning');
    }

    if (inputStateCPU & inWork == inWork) {
      stateCPU.insert(0, 'inWork');
    }

    if (inputStateCPU & onStop == onStop) {
      stateCPU.insert(0, 'Stop');
    }

    if (inputStateCPU & onTanking == onTanking) {
      stateCPU.insert(0, 'Tanking');
    }

    if (inputStateCPU & onTankFull == onTankFull) {
      stateCPU.insert(0, 'Tank Full');
    }
    setState(() {});

    if (inputStateCPU & onErrorCI == onErrorCI) {
      stateCPU.insert(0, 'Bilinməyən error baş verdi');
      setState(() {});
      //internal error start
      if (inputInternalError & fleshMemory == fleshMemory) {
        internalError.insert(0, 'Flash yaddaş mövcud deyil');
      }
      if (inputInternalError & tankTSF == tankTSF) {
        internalError.insert(0, 'Tank temperatur sensörünün nasazlığı');
      }
      if (inputInternalError & evaporatorTSF == evaporatorTSF) {
        internalError.insert(0, 'Buxarlayıcı temperatur sensörünün nasazlığı');
      }
      if (inputInternalError & noseTSF == noseTSF) {
        internalError.insert(0, 'Burun temperatur sensörünün nasazlığı');
      }
      if (inputInternalError & frontPanelTSF == frontPanelTSF) {
        internalError.insert(0, 'Ön panelin temperatur sensorunun nasazlığı');
      }
      setState(() {});
      //internal error end

      //errorCpu start
      if (inputCPUError & intErr == intErr) {
        errorCPU.insert(0, 'intErr');
      }
      if (inputCPUError & fuelLow == fuelLow) {
        errorCPU.insert(0, 'fuelLow');
      }
      if (inputCPUError & tooHotBur == tooHotBur) {
        errorCPU.insert(0, 'tooHotBur');
      }
      if (inputCPUError & hotTank == hotTank) {
        errorCPU.insert(0, 'hotTank');
      }
      if (inputCPUError & extT_Abnorm_Err == extT_Abnorm_Err) {
        errorCPU.insert(0, 'extT_Abnorm_Err');
      }
      if (inputCPUError & fuelAlarm == fuelAlarm) {
        errorCPU.insert(0, 'fuelAlarm');
      }
      if (inputCPUError & doorOpenErr == doorOpenErr) {
        errorCPU.insert(0, 'doorOpenErr');
      }
      if (inputCPUError & burnFail == burnFail) {
        errorCPU.insert(0, 'burnFail');
      }
      if (inputCPUError & evapFail == evapFail) {
        errorCPU.insert(0, 'evapFail');
      }
      if (inputCPUError & cO2Err == cO2Err) {
        errorCPU.insert(0, 'cO2Err');
      }
      if (inputCPUError & erPanel == erPanel) {
        errorCPU.insert(0, 'erPanel');
      }
      if (inputCPUError & blowOut == blowOut) {
        errorCPU.insert(0, 'blowOut');
      }
      if (inputCPUError & fuelSpillAlarmD == fuelSpillAlarmD) {
        errorCPU.insert(0, 'Yanacağın dağılması');
      }
      if (inputCPUError & tooHotEvap == tooHotEvap) {
        errorCPU.insert(0, 'tooHotEvap');
      }
      if (inputCPUError & erOutT == erOutT) {
        errorCPU.insert(0, 'erOutT');
      }
      if (inputCPUError & fuelSpillAlarmS == fuelSpillAlarmS) {
        errorCPU.insert(0, 'Yanacaq sızması');
      }
      if (inputCPUError & erAdPump == erAdPump) {
        errorCPU.insert(0, 'erAdPump');
      }
      if (inputCPUError & erSenLevel == erSenLevel) {
        errorCPU.insert(0, 'erSenLevel');
      }
      setState(() {});
      //errorCPu end

    }
    //state Cpu end

    //curDI start
    if (inputCurDI & lowLevelFuelTank == lowLevelFuelTank) {
      curDI.insert(0, 'çəndəki yanacağın aşağı səviyyəsi (L)');
    }
    if (inputCurDI & lowHightFuelTank == lowHightFuelTank) {
      curDI.insert(0, 'çəndəki yanacağın yuxarı səviyyəsi (H)');
    }
    if (inputCurDI & lowAlertFuelTank == lowAlertFuelTank) {
      curDI.insert(0, 'tankdakı təcili yanacaq səviyyəsi (H +)');
    }
    if (inputCurDI & fuelLeakage == fuelLeakage) {
      curDI.insert(0, 'yanacaq sızması');
    }
    if (inputCurDI & fillingHatchOpen == fillingHatchOpen) {
      curDI.insert(0, 'doldurma lyuku açıqdır');
    }
    setState(() {});
    //curDi end

    //curDO start
    if (inputCurDO & tankOpenKey == tankOpenKey) {
      curDO = 'doldurma lyukunun kilidi açıq';
    }
    if (inputCurDO == 0) {
      curDO = 'doldurma lyukunun kilidi bağlı';
    }
    setState(() {});
    //curDO end
  }

  void sendData(List<int> sendMessage) {
    if (isConnect) {
      socketConnection!.sendMessage(sendMessage);
    }
  }
}
