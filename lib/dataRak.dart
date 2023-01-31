import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scanerx/dataRakDetil.dart';
import 'main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Datarak extends StatefulWidget {
  const Datarak({Key? key}) : super(key: key);
  @override
  _DatarakState createState() => _DatarakState();
}

class _DatarakState extends State<Datarak> {
  String? email;
  String? token;
  

  final pencarianControler = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future _fetchListItems(path) async {
   try {
       BaseOptions options = new BaseOptions(
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );
      var dio = Dio(options);

    FormData formData = new FormData.fromMap({
      "kunci": pencarianControler.text,
       "noDoc": noDocSOPanggil,
    });

    Response response = await dio.post(
      ip + path + ".php", //endpoint api Login
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
   
    return Scaffold(
      appBar: new AppBar(
        title: Text("Pilih Rak Anda"),
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
          children: [
            // Container(
            //   color: Colors.transparent,
            //   child: Padding(
            //     padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * (30 / 100),left: MediaQuery.of(context).size.width * (30 / 100),top :MediaQuery.of(context).size.height * (2 / 100),bottom: MediaQuery.of(context).size.height * (2 / 100)),
            //     child: AutoSizeText(
            //       "Pilih Rak Anda",
            //       maxLines: 1,
            //       style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            //     ),
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
                      padding : EdgeInsets.only(top: 0, left: 15, right: 0),
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
                    )
                    ,
                  ),
                ],
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: _fetchListItems("dataRak"),
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
                                 
                                 noRakPanggil = listData[index]
                                                          ["rak"] ;
                    Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => (const dataRakDetil( ))));
                                },
                                splashColor: Color.fromARGB(255, 111, 54, 244),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black26,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * (5 / 100), 0, MediaQuery.of(context).size.width * (5 / 100), 16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: ListTile(
                                          leading: Icon(Icons.troubleshoot),
                                          title: Row(
                                            children: <Widget>[                                              
                                              Container(
                                                child: AutoSizeText(
                                                   listData[index]
                                                          ["rak"]  ,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    })),
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

