import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scanerx/dataServerDetilQR.dart';

class tracerQR extends StatefulWidget {
  const tracerQR({Key? key}) : super(key: key);

  @override
  _tracerQRState createState() => _tracerQRState();
}

class _tracerQRState extends State<tracerQR> {
  var barcodeScanRes = "";
  var dataRespon;
  var dataList;
  final textBox1 = TextEditingController();
  FocusNode nodeFirst = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 
  }


  Future _fetchListItems() async {
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
        ip + "tracerQR.php", //endpoint api Login
        data: formData,
        options: Options(contentType: Headers.jsonContentType),
      );
      List<dynamic> kembalian = jsonDecode(response.data);
      dataRespon = jsonDecode(response.data);
      if (response.statusCode == 200) {
      } else {
        namaBarang = "Gagal Konek Server";
      }
      Navigator.pop(context);
      return kembalian;
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
    namaBarang = "Memanggil data dari Server WMS";
    await _fetchListItems();

    setState(() {
      if (isKoneksiPutus) {
        namaBarang = "Koneksi Putus";
      } else {
        try {
          kodeBarang = dataRespon[0]["Kode1"];
          namaBarang = dataRespon[0]["Barang"];
          expBarang = dataRespon[0]["TanggalKedaluwarsa"];

          dataTracer1 = dataRespon[0]["Lokasi"];
          dataTracer2 = dataRespon[0]["Referensi_Jenis"] +
              "\n" +
              dataRespon[0]["Referensi_IdTransaksi"] +
              "\n" +
              dataRespon[0]["Referensi_WaktuProses_format"];
          dataTracer3 = dataRespon[0]["Operator"];
          statusQR = dataRespon[0]["StatusQR"];
        } catch (e) {
          namaBarang = "Tidak Ada Data Tersebut di Server";
        }
      }
    });
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
          "Informasi QR <WMS>",
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
            //         padding: const EdgeInsets.all(10.0),
            //         child: Text(
            //           "Informasi QR <WMS>",
            //           style:
            //               TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            //         ),
            //       ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 5, top: 10),
                    child: Text(
                      kodeQR,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(
                      onPressed: () async {
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
                          fontSize: 13, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 5, top: 5),
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
                        left: 35, right: 15, bottom: 0, top: 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Informasi : ",
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
                    margin: const EdgeInsets.only(right: 30, left: 30, top: 5),
                    color: Color.fromARGB(255, 82, 81, 81),
                    height: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 35, right: 35, bottom: 5, top: 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Lokasi Barang",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: Text(
                            dataTracer1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 35, right: 35, bottom: 5, top: 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Transaksi\nTerakhir",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: Text(
                            dataTracer2,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 35, right: 35, bottom: 5, top: 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Petugas",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: Text(
                            dataTracer3,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 35, right: 35, bottom: 5, top: 15),
                    child: Text(
                      statusQR,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal),
                    ),
                  ),
                 
                ]),
              ),
            ),
             Container(
                    margin: const EdgeInsets.only(right: 30, left: 30),
                    color: Color.fromARGB(255, 82, 81, 81),
                    height: 1,
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

showDialogFunc(context, title) {
  return showDialog(
      context: context,
      builder: (context) {
        var listData = [];
        var index2;
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: <Widget>[
                  Text(
                    listData[index2]["keteranganMasalah"].toString(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 70),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          color: Colors.red,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          padding: const EdgeInsets.all(10),
                        ),
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 25),
                        child: MaterialButton(
                          onPressed: () {},
                          child: const Text('Direction',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          color: Colors.blue,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          padding: const EdgeInsets.all(10),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
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
