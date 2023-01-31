import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scanerx/dataRakDetilQR.dart';

import 'main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scanerx/dataServerDetilQR.dart';

class dataRakDetil extends StatefulWidget {
  const dataRakDetil({Key? key}) : super(key: key);

  @override
  _dataRakDetilState createState() => _dataRakDetilState();
}

class _dataRakDetilState extends State<dataRakDetil> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final pencarianControler = TextEditingController();
  List<dynamic>? respon ;
  int? JmlBaris ;
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
          "petugas": petugasSOPanggil,
      });

      Response response = await dio.post(
        ip + "dataRakDetil.php", //endpoint api Login
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
          "Informasi Rak",
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
            // Container(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Text(
            //     "Informasi Dokumen",
            //     style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            //   ),
            // ),
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
              padding: const EdgeInsets.only(
                  top: 5, right: 15, left: 15, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Nama Barang / Item",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                       Container(
                        width: 100,
                        child: Text(
                          "  Exp",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 50,
                        child: Text(
                          "  Qty",
                          textAlign: TextAlign.center,
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
                                onTap: () {
                                  nobarangPanggil = listData[index]["kodeBarang"];
                                  noNamabarangPanggil = listData[index]["namaBarang"] + " ( QTY : " + listData[index]["qty"] + " )";
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          (const dataRakDetilQR())));
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
                                              listData[index]["namaBarang"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            child: Text(
                                              listData[index]["exp"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                            width: 50,
                                            child: Text(
                                              listData[index]["qty"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                                      
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
