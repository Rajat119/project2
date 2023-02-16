import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/firebase_authentication/auth.dart';
import 'package:flutter_application_1/screens/logout.dart';
import 'package:flutter_application_1/upload/dataupload.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class homepage extends StatefulWidget {
  homepage({super.key, required this.username, required this.password});
  String username, password;

  @override
  State<homepage> createState() => _homepageState(pass: password, username: username);
}

class _homepageState extends State<homepage> {
  _homepageState({required this.username, required this.pass});
  String username, pass;
  final User? user = Auth().currentUser;

  final _channel = WebSocketChannel.connect(
      Uri.parse('wss://simple-web-socket-echo-server.glitch.me/'));

  // TextEditingController qrdata = new TextEditingController();
  var qrdata = 'QR Code Result';

  void scanqrcode() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      if (!mounted) return;

      setState(() {
        qrdata = result;
        if (qrdata.isNotEmpty) {
          _channel.sink.add(qrdata + ":" + username + ":" + pass);
        }
      });

      print('QR Code result :- ');
      print(result);
    } on PlatformException {
      qrdata = 'Failed To Scan QR Code';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            onPressed: (() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DataUpload()));
            }),
            backgroundColor: Colors.blue.shade900,
            child: Container(
                padding: EdgeInsets.all(10),
                child: Image(image: AssetImage("assets/e.png"))),
            elevation: 20,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(15, 50, 0, 40),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Hello",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16.0)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  user?.email ?? 'User email',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Text("Your storage almost full.",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22.0)),
                          ])),
                  InkWell(
                    onTap: (() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => logout()));
                    }),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 25, 0),
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  //Just to show the scanned data
                  // StreamBuilder(
                  //   stream: _channel.stream,
                  //   builder: (context, snapshot) {
                  //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
                  //   },
                  // )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue.shade50),
                padding: EdgeInsets.all(22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Search file..",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.teal,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        // Text(qrscan.text),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const scanner()),
                            // );
                            setState(() {
                              scanqrcode();
                            });
                          },
                          child: Icon(
                            Icons.qr_code_scanner,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue.shade900),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: CircularPercentIndicator(
                        radius: 150,
                        lineWidth: 20,
                        percent: 0.4,
                        progressColor: Colors.blue,
                        backgroundColor: Colors.blue.shade100,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          "40%",
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10.0,
                              height: 10.0,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Used Space",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Container(
                              width: 10.0,
                              height: 10.0,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Remaning Space",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 22),
              Padding(
                padding: EdgeInsets.all(22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Folders",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900),
                    ),
                    Icon(Icons.more_horiz_outlined,
                        size: 35, color: Colors.grey),
                  ],
                ),
              ),
              SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image(
                                image: AssetImage("assets/f.jpg"),
                              ),
                              SizedBox(width: 55),
                              Icon(Icons.more_horiz_outlined,
                                  size: 35, color: Colors.grey),
                            ],
                          ),
                          SizedBox(height: 25),
                          Text(
                            "Downloads",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text("120 files",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 55),
                              Text("21GB",
                                  style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        ]),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image(
                                image: AssetImage("assets/s.jpg"),
                              ),
                              SizedBox(width: 55),
                              Icon(Icons.more_horiz_outlined,
                                  size: 35, color: Colors.grey),
                            ],
                          ),
                          SizedBox(height: 25),
                          Text(
                            "Secret Files",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text("2400 files",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 55),
                              Text("64GB",
                                  style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        ]),
                  )
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.all(22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Files",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900),
                    ),
                    Icon(Icons.more_horiz_outlined,
                        size: 35, color: Colors.grey),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image(image: AssetImage("assets/d.jpg")),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DOC_Revision_12.doc",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900),
                                ),
                                SizedBox(height: 10),
                                Text("7/14/2022 1:40 AM",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.more_horiz_outlined,
                            size: 35, color: Colors.grey),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image(image: AssetImage("assets/p.jpg")),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "One Piece Film RED.mp4",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900),
                                ),
                                SizedBox(height: 5),
                                Text("7/14/2022 3:38 AM",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.more_horiz_outlined,
                            size: 35, color: Colors.grey),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image(image: AssetImage("assets/d.jpg")),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "IMG_07142022_022056.jpg",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900),
                                ),
                                SizedBox(height: 5),
                                Text("7/14/2022 2:20 AM",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.more_horiz_outlined,
                            size: 35, color: Colors.grey),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ));
  }

  // void _sendmessage() {
  //   if (qrdata.isNotEmpty) {
  //     _channel.sink.add(qrdata);
  //   }
  // }

  // @override
  // void dispose() {
  //   _channel.sink.close();
  //   qrdata.dispose();
  //   super.dispose();
  // }
}
