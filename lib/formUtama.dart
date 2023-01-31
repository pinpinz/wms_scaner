import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:scanerx/Login.dart';
import 'package:scanerx/dataLog.dart';
import 'package:scanerx/main.dart';
import 'package:scanerx/dataServer.dart';
import 'package:scanerx/DateTimePicker.dart';
import 'package:scanerx/scanBebas.dart';
import 'package:scanerx/scanSO.dart';
import 'package:scanerx/traceQR.dart';
import 'package:scanerx/tracerQRHistory.dart';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  String? email;
  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future _fetchListItems() async {
    var dio = Dio();
    print(ip + "userit.php");
    Response response = await dio.post(
      ip + "userit.php", //endpoint api Login
      data: {},
      options: Options(contentType: Headers.jsonContentType),
    );
    List<dynamic> kembalian = jsonDecode(response.data);
    return kembalian;
  }

  var direction;
  var titleList;
  var listData = [];

  @override
  Widget build(BuildContext context) {
    List<String> list = List.generate(10, (index) => "$index");
    return Scaffold(
      // appBar: new AppBar(
      //   title: const Text(
      //     "ScanerX v1.0",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: Color.fromARGB(255, 70, 70, 70),
      // ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            Container(
              child: Image.asset(
                'aset/gambar/Head.jpg',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 30),
              child: Row(children: <Widget>[
                Text("Officer : " + username,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Avenir",
                      fontStyle: FontStyle.normal,
                    ),
                    textAlign: TextAlign.left),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (idxMenu == "DetilQRMenu") ...[
                      Container(
                        height: 60,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: MaterialButton(
                          color: Color.fromARGB(255, 241, 237, 237),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(17),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.home),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Home Menu",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                              ),
                            ],
                          ),
                          onPressed: () {
                            idxMenu = "MenuUtama";
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        height: 60,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: MaterialButton(
                          color: Color.fromARGB(255, 241, 237, 237),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(17),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.qr_code),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Info QR (Lokasi WMS)",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                              ),
                            ],
                          ),
                          onPressed: () {
                            kodeQR = "QRxxxxxxxxxx";
                            kodeBarang = "99XXXXXXXX";
                            namaBarang = "Nama Barang / Product Of Bernardi";
                            expBarang = "??/??/??";

                            dataTracer1 = "---";
                            dataTracer2 = "---";
                            dataTracer3 = "---";
                            statusQR = "-";
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => (const tracerQR())));
                          },
                        ),
                      ),
                      Container(
                        height: 60,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: MaterialButton(
                          color: Color.fromARGB(255, 241, 237, 237),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(17),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.qr_code),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Info QR (History Scan)",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                              ),
                            ],
                          ),
                          onPressed: () {
                            kodeQR = "QRxxxxxxxxxx";
                            kodeBarang = "99XXXXXXXX";
                            namaBarang = "Nama Barang / Product Of Bernardi";
                            expBarang = "??/??/??";

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    (const tracerQRHistory())));
                          },
                        ),
                      ),
                    ] else if (idxMenu == "MenuUtama") ...[
                      Container(
                        height: 60,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: MaterialButton(
                          color: Color.fromARGB(255, 241, 237, 237),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(17),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.qr_code),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Info QR",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                              ),
                            ],
                          ),
                          onPressed: () {
                            idxMenu = "DetilQRMenu";
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 60,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: MaterialButton(
                          color: Color.fromARGB(255, 241, 237, 237),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(17),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.document_scanner),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Data Tersimpan Server",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => (const DataServer())));
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 60,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: MaterialButton(
                          color: Color.fromARGB(255, 241, 237, 237),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(17),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.bar_chart),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Scan Mode : Bebas",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => (scanSO())));
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 60,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: MaterialButton(
                          color: Color.fromARGB(255, 241, 237, 237),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(17),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.file_open),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Data Log Server",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => (const DataLOG())));
                          },
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 60, right: 60, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => (const Login())),
                      ModalRoute.withName('/'));
                },
                child: const Text("Sign Out",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                color: Color.fromARGB(255, 197, 84, 84),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Site Ware House :",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "Avenir",
                        fontStyle: FontStyle.normal,
                      ),
                      textAlign: TextAlign.left),
                  cit1(username),
                ],
              ),
            ),
            Container(
              child: Image.asset(
                'aset/gambar/Foot.jpg',
                width: (MediaQuery.of(context).size.width),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final FlutterTts flutterTts = FlutterTts();
Widget cit1(nama) {
  return TextButton(
    onPressed: () async {
      await flutterTts.setLanguage("id-ID");
      /*set suara cowok*/
      // await flutterTts
      //     .setVoice({"name": "id-id-x-dfz#male_3-local", "locale": "id-ID"});
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1);
      await flutterTts.speak("selamat datang" + nama);
      await flutterTts.speak("Balonku ada 5 rupa rupa warnanya");
    },
    child: Text("Admin",
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontFamily: "Avenir",
          fontStyle: FontStyle.normal,
        ),
        textAlign: TextAlign.left),
  );
}

showDialogFunc(context, title) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          height: 300,
          width: 300,
          child: Material(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    "Menu Belum Tersedia",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(
                      left: 60, right: 60, bottom: 10, top: 30),
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("Kembali",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    color: Color.fromARGB(255, 53, 48, 99),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
