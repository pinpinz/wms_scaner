import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scanerx/dataServerDetil.dart';

import 'main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataLOG extends StatefulWidget {
  const DataLOG({Key? key}) : super(key: key);

  @override
  _DataLOGState createState() => _DataLOGState();
}


class _DataLOGState extends State<DataLOG> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  

    dateController1.text = setDate1;
    dateController2.text = setDate2;
  }


  Future _fetchListItems() async {
     try {
 

      BaseOptions options = new BaseOptions(
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );
      var dio = Dio(options);

    FormData formData = new FormData.fromMap({
      "tgl1": dateController1.text,
      "tgl2": dateController2.text,
      "kunci": pencarianControler.text,
    });

    Response response = await dio.post(
      ip + "dataLog.php", //endpoint api Login
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

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      callback();
    });
  }
  var listData = [];

  //komponen untuk datepicker

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  final dateController1 = TextEditingController();
  final dateController2 = TextEditingController();
  final pencarianControler = TextEditingController();

  Future<Null> _selectDate(
      BuildContext context, TextEditingController datepick) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        datepick.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    List<String> list = List.generate(10, (index) => "$index");

    return Scaffold(
      appBar: new AppBar(
        title: const Text(
          "Catatan LOG Progam",
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
            //   color: Colors.transparent,
            //   child: Padding(
            //     padding: EdgeInsets.only(
            //         right: MediaQuery.of(context).size.width * (20 / 100),
            //         left: MediaQuery.of(context).size.width * (20 / 100),
            //         top: MediaQuery.of(context).size.height * (2 / 100),
            //         bottom: MediaQuery.of(context).size.height * (2 / 100)),
            //     child: AutoSizeText(
            //       "Catatan LOG Progam",
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
              child: Container(
                color: Colors.white,
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
                                  // idScanPanggil = listData[index]["idScan"];
                                  // namaCustomerPanggil =
                                  //     listData[index]["namaCustomer"];
                                  // tanggalPanggil = listData[index]["tanggal"];
                                  // pemakaiPanggil = listData[index]["pemakai"];
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         (const DetilDataServer())));
                                },
                                splashColor: Colors.red,
                                child: Container(
                                  // height: 90,
                                  padding: const EdgeInsets.only(bottom: 1),
                                  child: Material(
                                    child: ListTile(
                                      trailing: Icon(Icons.open_in_browser),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(children: <Widget>[
                                            Text(
                                              "idScan : " +
                                                  listData[index]["nomorDokumen"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ]),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width * (60 / 100),
                                              child: Text(
                                                listData[index]["catatan"],
                                                maxLines: 6,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                            )
                                            ,
                                          ]),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  "User : " +
                                                      listData[index]
                                                          ["namaUser"],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              Text(
                                                listData[index]["tanggal"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 11),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey,
                                            margin: EdgeInsets.only(top: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    }),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _selectDate(context, dateController1);
                    },
                    child: Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width * (40 / 100),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: dateController1,
                        onSaved: (String? val) {
                          setDate1 = val!;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Pilih Tangagl',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "s/d",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate(context, dateController2);
                    },
                    child: Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width * (40 / 100),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: dateController2,
                        onSaved: (String? val) {
                          setDate2 = val!;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Pilih Tangagl',
                          border: InputBorder.none,
                        ),
                      ),
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

