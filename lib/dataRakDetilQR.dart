import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scanerx/scanBebas.dart';

import 'main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scanerx/dataServerDetilQR.dart';

class dataRakDetilQR extends StatefulWidget {
  const dataRakDetilQR({Key? key}) : super(key: key);

  @override
  _dataRakDetilQRState createState() => _dataRakDetilQRState();
}

class _dataRakDetilQRState extends State<dataRakDetilQR> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final pencarianControler = TextEditingController();

  Future _fetchListItems() async {
    try {
      BaseOptions options = new BaseOptions(
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );
      var dio = Dio(options);

      FormData formData = new FormData.fromMap({
        "noDoc": noDocSOPanggil,
        "rak": noRakPanggil,
        "kunci": pencarianControler.text,
        "kodeBarang": nobarangPanggil,
          "petugas": petugasSOPanggil,
      });

      Response response = await dio.post(
        ip + "dataRakDetilQR.php", //endpoint api Login
        data: formData,
        options: Options(contentType: Headers.jsonContentType),
      );
      List<dynamic> kembalian = jsonDecode(response.data);
      return kembalian;
    } on DioError catch (e) {
      _onWidgetDidBuild(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Load Data Gagal, Koneksi Ke Server Gagal (Time Out)'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  var dataRespon;
  hapus() async {
    try {
      showLoaderDialog(context);

      BaseOptions options = new BaseOptions(
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );
      var dio = Dio(options);
      isKoneksiPutus = false;

      FormData formData = new FormData.fromMap({
        "noDoc": noDocSOPanggil,
        "petugas": petugasSOPanggil,
        "rak": noRakPanggil,
        "QRbarang": QRHapus,
      });

      Response response = await dio.post(
        ip + "hapusScanSO.php", //endpoint api Login
        data: formData,
        options: Options(contentType: Headers.jsonContentType),
      );
      List<dynamic> kembalian = jsonDecode(response.data);

      dataRespon = jsonDecode(response.data);

      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
    } on DioError catch (e) {
      Navigator.pop(context);
      isKoneksiPutus = true;
    }
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      callback();
    });
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
          "Informasi QR Barang",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 70, 70, 70),
      ),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                noNamabarangPanggil,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 35,
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * (5 / 100),
                  20,
                  MediaQuery.of(context).size.width * (5 / 100),
                  16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: Colors.black26),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * (2 / 100)),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.search),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 0, left: 15, right: 0),
                      child: TextFormField(
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Cari disini',
                          border: InputBorder.none,
                        ),
                        controller: pencarianControler,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.only(top: 5, right: 15, left: 15, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "QR",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 10),
              color: Color.fromARGB(255, 82, 81, 81),
              height: 1,
            ),
            Expanded(
              child: Container(
                color: Color.fromARGB(255, 255, 255, 255),
                child: FutureBuilder(
                    future: _fetchListItems(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        listData = snapshot.data;
                        return ListView.builder(
                            itemCount: listData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () async {
                                  // QRHapus = listData[index]["QR"];
                                  // kodeHapus = listData[index]["kodeBarang"];
                                  // await PesanYaTidak(
                                  //     context,
                                  //     "Yakin akan Hapus \nQR : " +
                                  //         listData[index]["QR"] +
                                  //         "?",
                                  //     "hapus");
                                },
                                splashColor: Colors.red,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 15, right: 15),
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              (index + 1).toString() + ". " + listData[index]["QR"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Text(
                                              listData[index]["exp"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    }),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15, left: 10),
              color: Color.fromARGB(255, 82, 81, 81),
              height: 1,
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

  PesanYaTidak(context, title, type) {
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
                      title.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(
                          left: 30, right: 10, bottom: 10, top: 30),
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: MaterialButton(
                        onPressed: () async {
                          if (type == "hapus") {
                            if (QRHapus == "") {
                              await Pesan(
                                  context, "Tidak ada QR\nyang dihapus");
                            } else {
                              await hapus();
                              if (isKoneksiPutus) {
                                await Pesan(
                                    context, "Koneksi ke Server \nGagal");
                              } else {
                                await Pesan(context,
                                    "QR : " + QRHapus + " \nberhasil dihapus");
                              }
                              QRHapus = "";
                              kodeHapus = "";
                            }
                          }

                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text("Ya",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        color: Color.fromARGB(255, 53, 48, 99),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(
                          left: 10, right: 30, bottom: 10, top: 30),
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Tidak",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        color: Color.fromARGB(255, 53, 48, 99),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
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
