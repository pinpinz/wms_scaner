import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DetilDataServerQR extends StatefulWidget {
  const DetilDataServerQR({Key? key}) : super(key: key);

  @override
  _DetilDataServerQRState createState() => _DetilDataServerQRState();
}

class _DetilDataServerQRState extends State<DetilDataServerQR> {
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 
  }



  Future _fetchListItems() async {
    try {
       BaseOptions options = new BaseOptions(
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );
      var dio = Dio(options);

    FormData formData = new FormData.fromMap({
      "idScan": idScanQR,
      "idBarang": idBarangQR,
    });

    Response response = await dio.post(
      ip + "detilDataServerQR.php", //endpoint api Login
      data: formData,
      options: Options(contentType: Headers.jsonContentType),
    );
    List<dynamic> kembalian = jsonDecode(response.data);
    return kembalian;
     } on DioError catch (e) {    
    
       _onWidgetDidBuild(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Load Data Gagal, Koneksi Ke Server Gagal (Time Out)'),
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
          "Detil Informasi QR",
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
            //     "Detil Informasi QR",
            //     style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            //   ),
            // ),
           
            Container(
              padding: const EdgeInsets.only(left:15,right: 15,bottom: 5,top: 30),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                       idScanQR,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Text(
                    tanggalPanggil,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Container(
             padding: const EdgeInsets.only(left:15,right: 15,bottom: 5,top: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                       namaBarangQR,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 15, right: 15, left: 15, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "QR Item",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                                         Container(
                        width: 150,
                        child: Text(
                          "  Exp",
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
              margin: const EdgeInsets.only(right: 15, left: 10),
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
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  // builder: (context) => ???????)));
                                },
                                splashColor: Colors.red,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 0, left: 15, right: 15),
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              listData[index]["QR"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                            ),
                                          ),
                                         
                                          Container(
                                            width: 150,
                                            child: Text(
                                              listData[index]["exp"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                            ),
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
              padding: const EdgeInsets.only(
                  top: 10, right: 15, left: 15, bottom: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Petugas Scan : " + pemakaiPanggil,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
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
