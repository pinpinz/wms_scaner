import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scanerx/dataServerDetilQR.dart';

class tracerQRHistory extends StatefulWidget {
  const tracerQRHistory({Key? key}) : super(key: key);

  @override
  _tracerQRHistoryState createState() => _tracerQRHistoryState();
}

class _tracerQRHistoryState extends State<tracerQRHistory> {
  var barcodeScanRes = "";
  List<dynamic>  dataRespon = [];
  var dataList;

  final textBox1 = TextEditingController();
  FocusNode nodeFirst = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



   panggil() async {
    try {
      showLoaderDialog(context);

      BaseOptions options = new BaseOptions(
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );
      var dio = Dio(options);
      isKoneksiPutus = false;

      FormData formData = new FormData.fromMap({
        "QRTempel": kodeQR,
      });

      Response response = await dio.post(
        ip + "tracerQRhistory.php", //endpoint api Login
        data: formData,
        options: Options(contentType: Headers.jsonContentType),
      );
      List<dynamic> kembalian = jsonDecode(response.data);
      dataRespon = jsonDecode(response.data);
      Navigator.pop(context);

      if (response.statusCode == 200) {
      }
      
          
    } on DioError catch (e) {
      isKoneksiPutus = true;
      Navigator.pop(context);
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    listData.add((listData.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  olahData() async {
    namaBarang = "Memanggil data dari Server ScanerX";
    await panggil();

    setState(() {
       if (isKoneksiPutus) {
        namaBarang = "Koneksi Putus";
      } else {
      try {
        kodeQR = dataRespon[0]["QR"];
        kodeBarang = dataRespon[0]["idBarang"];
        namaBarang = dataRespon[0]["namaBarang"];
        expBarang = dataRespon[0]["exp"];
      } catch (e) {
        namaBarang = "Tidak Ada Data Tersebut di Server";
      }
    }});
  }

  var listData = [];
  var title = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    List<String> list = List.generate(10, (index) => "$index");
    return Scaffold(
      appBar: new AppBar(
        title: const Text(
          "Informasi QR <ScanerX>",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 70, 70, 70),
      ),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        enablePullDown: true,
        // enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Container(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Text(
            //     "Informasi QR <ScanerX>",
            //     style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 5, top: 10),
                      child: Text(
                        kodeQR,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: IconButton(
                        onPressed: () {
                          if (idxPencarian == "Scan") {
                            idxPencarian = "Text";
                          } else {
                            idxPencarian = "Scan";
                          }
                          setState(() {});
                        },
                        icon: Image.asset(
                          'aset/gambar/box.png',
                        ),
                        iconSize:
                            (MediaQuery.of(context).size.height * (13 / 100)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 5, top: 10),
                      child: Text(
                        kodeBarang,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, right: 13, bottom: 5, top: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              namaBarang,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 5, top: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "EXP : " + expBarang,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 35, right: 15, bottom: 5, top: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Informasi",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(right: 30, left: 30, top: 5),
                      color: Color.fromARGB(255, 82, 81, 81),
                      height: 1,
                    ),
                    Container(
                      height: 350,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child : ListView.builder(
                                  itemCount: dataRespon.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        // builder: (context) => ???????)));
                                      },
                                      splashColor:
                                          Color.fromARGB(255, 192, 98, 61),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 0,
                                            left: 15,
                                            right: 15),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              color: Color.fromARGB(
                                                  255, 211, 210, 210),
                                              margin: EdgeInsets.only(top: 10),
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      dataRespon[index]["idScan"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    child: Text(
                                                      dataRespon[index]
                                                          ["tanggal"],
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: Color.fromARGB(
                                                  255, 238, 236, 236),
                                              margin: EdgeInsets.only(top: 5),
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      dataRespon[index]["Lokasi"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    child: Text(
                                                      dataRespon[index]
                                                          ["pemakai"],
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 30, left: 30),
                      color: Color.fromARGB(255, 82, 81, 81),
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
            if (idxPencarian == "Scan") ...[
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.only(left: 60, right: 60, bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  onPressed: () async {
                    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                        "#ff6666", "Cancel", true, ScanMode.DEFAULT);

                    // barcodeScanRes = "3CB3E498-2AE9-EC11-8426-D4AE52B321C4~QR220701002065~9FADBDDA-B551-4CD9-B177-F536F9EBF367~E09ACE34-4CA2-4C66-8C41-0FB911BD7408~9930109137~BND ROTI BGR WIJEN 6 BJ @18PK\/BOX~2022-12-10~";
                    try {
                    dataList = barcodeScanRes.split("~");
                    kodeQR = dataList[1];

                      await olahData();
                    } catch (e) {
                      namaBarang = "QR tidak bisa dikenali (Bukan QR WMS)";
                       Navigator.pop(context);
                    }
                  },
                  child: const Text("Scan",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                  color: Color.fromARGB(255, 53, 48, 99),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                ),
              ),
            ] else if (idxPencarian == "Text") ...[
              Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromARGB(255, 223, 223, 224),
                  border: Border.all(color: Color.fromARGB(255, 243, 242, 242)),
                ),
                margin: EdgeInsets.only(top: 5, left: 40, right: 40),
                child: TextFormField(
                  style: TextStyle(fontSize: 14),
                  onFieldSubmitted: (value) async {
                    try {
                      if (textBox1.text.length > 20) {
                        dataList = textBox1.text.split("~");
                        kodeQR = dataList[1];
                      } else {
                        kodeQR = textBox1.text;
                      }

                      await olahData();
                    } catch (e) {
                      namaBarang = "QR tidak bisa dikenali (Bukan QR WMS)";
                       Navigator.pop(context);
                    }

                    textBox1.clear();
                    FocusScope.of(context).requestFocus(nodeFirst);
                  },
                  focusNode: nodeFirst,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'Input QR disini',
                    border: InputBorder.none,
                    // contentPadding: EdgeInsets.only(left: 30)
                  ),
                  controller: textBox1,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
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

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
