import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanerx/FormUtama.dart';
import 'package:scanerx/dataRak.dart';

import 'package:scanerx/dataServerDetil.dart';

import 'main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:scanerx/function/scanSO_function.dart';

class scanSO extends StatefulWidget {
  const scanSO({Key? key}) : super(key: key);

  @override
  _scanSOState createState() => _scanSOState();
}

var statusSimpan = "";
var idTrans = "";
var pathGambar = 'aset/gambar/box.png';
var barcodeScanRes = "";
var QRHapus = "";
var kodeHapus = "";
var flag = "0";

final textBox1 = TextEditingController();
final textBox2 = TextEditingController();
final textBox3 = TextEditingController();
final textBox4 = TextEditingController();
final textBox5 = TextEditingController();

var dataRespon;
var dataList;

FocusNode node1 = FocusNode();

AudioPlayer player = AudioPlayer();

List<String> kodeBarangScan = [];
List<String> NamaBarangScan = [];
List<String> ExpBarangScan = [];
List<String> QRBarangScan = [];
List<String> kodeBarangRekap = [];
List<String> NamaBarangRekap = [];
List<int> BarangQty = [];

int urut = 0;

class _scanSOState extends State<scanSO> {
  final FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dateController1.text = setDate1;
    dateController2.text = setDate2;

    textBox2.text = periodeSO;
    textBox3.text = username;

    flag = "0";
    textBox4.text = "";
    textBox5.text = "";

    kodeBarangScan.clear();
    NamaBarangScan.clear();
    QRBarangScan.clear();

    kodeBarangRekap.clear();
    NamaBarangRekap.clear();
    BarangQty.clear();

    pathGambar = 'aset/gambar/R.png';
    namaBarang = "Scan Lokasi Anda";
    _speak("silahkan scan lokasi anda", 0.5);
  }

  simpan() async {
    try {
      BaseOptions options = new BaseOptions(
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );
      var dio = Dio(options);
      isKoneksiPutus = false;
      statusSimpan = "gagal";
      FormData formData = new FormData.fromMap({
        "idTrans": textBox5.text,
        "noDoc": textBox2.text,
        "idUser": kodeUser,
        "petugas": textBox3.text,
        "rak": textBox4.text,
        "kodeBarang": dataList[4],
        "namaBarang": dataList[5],
        "QRbarang": dataList[1],
        "exp": dataList[6],
        "flag": flag,
      });

      showLoaderDialog(context);

      Response response = await dio.post(
        ip + "simpanScanSO.php", //endpoint api Login
        data: formData,
        options: Options(contentType: Headers.jsonContentType),
      );
      List<dynamic> kembalian = jsonDecode(response.data);

      dataRespon = jsonDecode(response.data);

      if (response.statusCode == 200) {
        Navigator.pop(context);
        statusSimpan = dataRespon[0]["status"];
        idTrans = dataRespon[0]["idTrans"];
      }
    } on DioError catch (e) {
      Navigator.pop(context);
      isKoneksiPutus = true;
    }
  }

  hapus() async {
    try {
      showLoaderDialog(context);

      BaseOptions options = new BaseOptions(
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );
      var dio = Dio(options);
      isKoneksiPutus = false;
      statusSimpan = "gagal";
      FormData formData = new FormData.fromMap({
        "noDoc": textBox2.text,
        "petugas": textBox3.text,
        "rak": textBox4.text,
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
                          left: 30, right: 0, bottom: 10, top: 30),
                      width: 140,
                      child: MaterialButton(
                        onPressed: () async {
                          fa(type);
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
                          left: 0, right: 30, bottom: 10, top: 30),
                      width: 140,
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

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  final Iterable<Duration> pauses2 = [
    const Duration(milliseconds: 300),
  ];

  fa(type) async {
    if (type == "hapus") {
      if (QRHapus == "") {
        Vibrate.vibrate();
        bunyi("assets/audio/tet_panjang.mp3");
        await Pesan(context, "Tidak ada QR\nyang dihapus");
      } else {
        await hapus();
        if (isKoneksiPutus) {
          Vibrate.vibrate();
          bunyi("assets/audio/tet_panjang.mp3");
          await Pesan(context, "Koneksi ke Server \nGagal");
        } else {
          Vibrate.vibrate();
          bunyi("assets/audio/tet_panjang.mp3");
          await Pesan(context, "QR : " + QRHapus + " \nberhasil dihapus");

          urut = QRBarangScan.indexWhere((item) => item == QRHapus);
          kodeBarangScan.removeAt(urut);
          NamaBarangScan.removeAt(urut);
          QRBarangScan.removeAt(urut);

          urut = kodeBarangRekap.indexWhere((item) => item == kodeHapus);
          BarangQty[urut] = BarangQty[urut] - 1;
        }
        QRHapus = "";
        kodeHapus = "";
      }
    }

    if (type == "ganti_rak") {
      flag = "0";
      textBox4.text = "";
      textBox5.text = "";

      kodeBarangScan.clear();
      NamaBarangScan.clear();
      QRBarangScan.clear();

      kodeBarangRekap.clear();
      NamaBarangRekap.clear();
      BarangQty.clear();

      pathGambar = 'aset/gambar/R.png';
      namaBarang = "Scan Lokasi Anda";

      _speak("silahkan scan lokasi anda", 0.5);

      setState(() {});
    }
    if (type == "back") {
      Navigator.pop(context);
    }
    setState(() {});
    Navigator.pop(context);
  }

  prosesSimpan(String x) async {
    if (textBox4.text == "") {
      Vibrate.vibrate();
      bunyi("assets/audio/tet.mp3");
      await Pesan(context, "Rak/Troly Belum diisi");
    } else {
      try {
        dataList = x.split("~");

        await simpan();
        if (isKoneksiPutus) {
          Vibrate.vibrate();
          bunyi("assets/audio/tet.mp3");
          pathGambar = 'aset/gambar/error.png';
          namaBarang = "Gagal konek ke Server";
        } else {
          if (statusSimpan == "sukses") {
            textBox5.text = idTrans;

            // bunyi("assets/audio/beeb.mp3");
            pathGambar = 'aset/gambar/aman.jpg';
            await prosesScaning();
            _speak(QRBarangScan.length.toString(), 1.0);
            print("ISI QR BARANG : ");
            print(QRBarangScan.length.toString());
            flag = "1";
          } else {
            Vibrate.vibrate();
            bunyi("assets/audio/tet.mp3");
            pathGambar = 'aset/gambar/error.png';
            namaBarang = "QR sudah pernah discan";
          }
        }
      } catch (e) {
        Vibrate.vibrate();
        bunyi("assets/audio/tet_panjang.mp3");
        await Pesan(context, "Erorr");
      }
      setState(() {});
    }
  }

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

  backToMenu() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => home()));
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  Future _speak(String ngomong, kecepatan) async {
    await flutterTts.setLanguage("id-ID");
    /*set suara cowok*/
    // await flutterTts
    //     .setVoice({"name": "id-id-x-dfz#male_3-local", "locale": "id-ID"});
    await flutterTts.setSpeechRate(kecepatan);
    await flutterTts.setPitch(1);
    await flutterTts.speak(ngomong);
    print(await flutterTts.getVoices);
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

  @override
  Widget build(BuildContext context) {
    List<String> list = List.generate(10, (index) => "$index");

    return Scaffold(
      // appBar: new AppBar(
      //   title: const Text(
      //     "Scan Bebas : Opname",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: Color.fromARGB(255, 70, 70, 70),
      // ),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        enablePullDown: true,
        // enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        // onLoading: _onLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 20,
              color: Color.fromARGB(221, 44, 44, 44),
            ),
            if (idxExpand == "DOWN") ...[
              Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromARGB(255, 223, 223, 224),
                  border: Border.all(color: Color.fromARGB(255, 243, 242, 242)),
                ),
                margin: EdgeInsets.only(top: 15, left: 40, right: 40),
                child: TextFormField(
                  style: TextStyle(fontSize: 11),
                  onFieldSubmitted: (value) async {},
                  textAlign: TextAlign.center,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'Dokumen SO',
                    border: InputBorder.none,
                  ),
                  controller: textBox2,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromARGB(255, 223, 223, 224),
                        border: Border.all(
                            color: Color.fromARGB(255, 243, 242, 242)),
                      ),
                      // margin: EdgeInsets.only(top: 15, left: 5, right: 5),
                      child: TextFormField(
                        style: TextStyle(fontSize: 11),
                        onFieldSubmitted: (value) async {},
                        textAlign: TextAlign.center,
                        enabled: false,
                        decoration: const InputDecoration(
                          hintText: 'Petugas',
                          border: InputBorder.none,
                        ),
                        controller: textBox3,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromARGB(255, 223, 223, 224),
                        border: Border.all(
                          color: Color.fromARGB(255, 223, 223, 224),
                        ),
                      ),
                      // margin: EdgeInsets.only(top: 15, left: 5, right: 5),
                      child: TextFormField(
                        style: TextStyle(fontSize: 11),
                        onFieldSubmitted: (value) async {
                          FocusScope.of(context).requestFocus(node1);
                        },
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Rak/Troly',
                          enabled: false,
                          border: InputBorder.none,
                        ),
                        controller: textBox4,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromARGB(255, 223, 223, 224),
                  border: Border.all(color: Color.fromARGB(255, 243, 242, 242)),
                ),
                margin: EdgeInsets.only(top: 5, left: 40, right: 40),
                child: TextFormField(
                  style: TextStyle(fontSize: 11),
                  onFieldSubmitted: (value) async {},
                  textAlign: TextAlign.center,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'id_Trans',
                    border: InputBorder.none,
                  ),
                  controller: textBox5,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ] else
              ...[],
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
                  pathGambar,
                ),
                iconSize: (MediaQuery.of(context).size.height * (13 / 100)),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AutoSizeText(
                      namaBarang,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Row(children: <Widget>[
              Container(
                width: 110,
                padding: const EdgeInsets.only(
                    left: 15, right: 0, bottom: 5, top: 5),
                child: MaterialButton(
                  onPressed: () async {
                    idxRekap = "detil";

                    setState(() {});
                  },
                  child: const Text(" Detil ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                  color: Color.fromARGB(255, 207, 207, 207),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, bottom: 5, top: 5),
                  child: MaterialButton(
                    onPressed: () async {
                      if (idxExpand == "UP") {
                        idxExpand = "DOWN";
                      } else {
                        idxExpand = "UP";
                      }
                      setState(() {});
                    },
                    child: const Text("EXPAND",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                    color: Color.fromARGB(255, 53, 52, 51),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.only(left: 16, right: 16),
                  ),
                ),
              ),
              Container(
                width: 110,
                padding: const EdgeInsets.only(
                    left: 0, right: 15, bottom: 5, top: 5),
                child: MaterialButton(
                  onPressed: () async {
                    idxRekap = "rekap";

                    setState(() {});
                  },
                  child: const Text(" Rekap ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                  color: Color.fromARGB(255, 207, 207, 207),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                ),
              ),
            ]),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10),
              color: Color.fromARGB(255, 82, 81, 81),
              height: 1,
            ),
            if (idxRekap == "detil") ...[
              Expanded(
                child: ListView.builder(
                    itemCount: kodeBarangScan.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          // QRHapus = QRBarangScan[index];
                          // kodeHapus = kodeBarangScan[index];
                          // await PesanYaTidak(
                          //     context,
                          //     "Yakin akan Hapus \nQR : " +
                          //         QRBarangScan[index] +
                          //         "?",
                          //     "hapus");
                        },
                        splashColor: Colors.red,
                        child: Container(
                          decoration: BoxDecoration(
                            // Red border with the width is equal to 5
                            border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 226, 226, 226)),
                            ),
                          ),
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Material(
                            child: ListTile(
                              // trailing: Icon(Icons.add_box),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        NamaBarangScan[index],
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 11,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      child: Text(
                                        QRBarangScan[index],
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 11,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ] else ...[
              Expanded(
                child: ListView.builder(
                    itemCount: kodeBarangRekap.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {},
                        splashColor: Colors.red,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Red border with the width is equal to 5
                            border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 226, 226, 226)),
                            ),
                          ),
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Material(
                            child: ListTile(
                              // trailing: Icon(Icons.add_box),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        NamaBarangRekap[index],
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 11,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      child: Text(
                                        BarangQty[index].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 11,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
            Container(
              padding:
                  const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Scan : " + QRBarangScan.length.toString(),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10),
              color: Color.fromARGB(255, 82, 81, 81),
              height: 1,
            ),
            Row(children: <Widget>[
              Container(
                width: 110,
                padding: const EdgeInsets.only(
                    left: 15, right: 0, bottom: 5, top: 5),
                child: MaterialButton(
                  onPressed: () async {
                    await PesanYaTidak(context, " Mau Keluar \nYakin?", "back");
                  },
                  child: const Text(" Back ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                  color: Color.fromARGB(255, 207, 207, 207),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, bottom: 5, top: 5),
                  child: MaterialButton(
                    onPressed: () async {
                      await PesanYaTidak(
                          context, " Ganti RAK \nYakin?", "ganti_rak");
                    },
                    child: const Text("< Finish >",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                    color: Color.fromARGB(255, 53, 52, 51),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.only(left: 12, right: 16),
                  ),
                ),
              ),
              Container(
                width: 110,
                padding: const EdgeInsets.only(
                    left: 0, right: 15, bottom: 5, top: 5),
                child: MaterialButton(
                  onPressed: () async {
                    petugasSOPanggil = textBox3.text;
                    noDocSOPanggil = textBox2.text;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => (const Datarak())));
                  },
                  child: const Text(" Data ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                  color: Color.fromARGB(255, 207, 207, 207),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                ),
              ),
            ]),
            if (idxPencarian == "Scan") ...[
              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.only(left: 60, right: 60),
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  onPressed: () async {
                    // FlutterBarcodeScanner.getBarcodeStreamReceiver(
                    //         '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
                    //     .listen((barcode) => print(barcode));

                    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                        "#ff6666", "Cancel", true, ScanMode.DEFAULT);

                    // barcodeScanRes =
                    //     "3CB3E498-2AE9-EC11-8426-D4AE52B321C4~QR220501002547~9FADBDDA-B551-4CD9-B177-F536F9EBF367~E09ACE34-4CA2-4C66-8C41-0FB911BD7408~9930109140~BND ROTI BGR WIJEN 6 BJ @18PK/BOX~2022-12-10~";

                    // barcodeScanRes =
                    //     "79633683-18FE-4D23-AC23-0CA6624D1652~B04.1";
                    idxExpand = "UP";
                    if (namaBarang == "Scan Lokasi Anda") {
                      try {
                        dataList = barcodeScanRes.split("~");
                        if (dataList[1].length <= 8) {
                          bunyi("assets/audio/beeb.mp3");
                          textBox4.text = dataList[1];
                          namaBarang = "Scan QR Barang Anda";
                          pathGambar = 'aset/gambar/box.png';
                          _speak("silahkan scan barang anda", 0.5);

                          setState(() {});
                        } else {
                          Vibrate.vibrate();
                          bunyi("assets/audio/tet_panjang.mp3");
                          await Pesan(
                              context, "Pastikan kode QR benar (QR Lokasi)");
                        }
                      } catch (e) {
                        Vibrate.vibrate();
                        bunyi("assets/audio/tet_panjang.mp3");
                        await Pesan(context, "QR tidak bisa kenali");
                      }
                    } else {
                      try {
                        dataList = barcodeScanRes.split("~");
                        pancing = dataList[1];

                        prosesSimpan(barcodeScanRes);
                      } catch (e) {
                        Vibrate.vibrate();
                        bunyi("assets/audio/tet_panjang.mp3");
                        await Pesan(context, "QR tidak bisa kenali");
                      }
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
                    idxExpand = "UP";

                    if (namaBarang == "Scan Lokasi Anda") {
                      try {
                        dataList = textBox1.text.split("~");
                        if (dataList[1].length <= 8) {
                          bunyi("assets/audio/beeb.mp3");
                          textBox4.text = dataList[1];
                          namaBarang = "Scan QR Barang Anda";
                          pathGambar = 'aset/gambar/box.png';
                          _speak("silahkan scan barang anda", 0.5);

                          setState(() {});
                        } else {
                          Vibrate.vibrate();
                          bunyi("assets/audio/tet_panjang.mp3");
                          await Pesan(
                              context, "Pastikan kode QR benar (QR Lokasi)");
                        }
                      } catch (e) {
                        Vibrate.vibrate();
                        bunyi("assets/audio/tet_panjang.mp3");
                        await Pesan(context, "QR tidak bisa kenali");
                      }
                    } else {
                      try {
                        dataList = textBox1.text.split("~");
                        pancing = dataList[1];

                        prosesSimpan(textBox1.text);
                      } catch (e) {
                        Vibrate.vibrate();
                        bunyi("assets/audio/tet_panjang.mp3");
                        await Pesan(context, "QR tidak bisa kenali");
                      }
                    }

                    textBox1.clear();
                    FocusScope.of(context).requestFocus(node1);
                  },
                  focusNode: node1,
                  obscureText: true,
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
