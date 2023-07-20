import 'package:flutter/material.dart';
import 'package:scanerx/login.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}
var isKoneksiPutus = false;

var kodeUser = "";
var username = "";
var lokasi = "";
var idxMenu = "MenuUtama";
var idxPencarian = "Text";
var idxExpand = "DOWN";
var idxRekap = "rekap";

//var ip = "http://182.16.173.90/scanerx/";//
var idScanPanggil = "";
var namaCustomerPanggil = "";
var tanggalPanggil = "";
var pemakaiPanggil = "";
var sitePanggil = "";

var idScanQR = "";
var idBarangQR = "";
var namaBarangQR = "";

var kodeQR = "QR220611004311";
var kodeBarang = "99XXXXXXXX";
var namaBarang = "Nama Barang / Product Of Bernardi";
var expBarang = "??/??/??";

var dataTracer1 = "---";
var dataTracer2 = "---";
var dataTracer3 = "---";
var statusQR = "-";

var pancing = "";
late String? setTime;
String setDate1 = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: -7)));
String setDate2 = DateFormat('yyyy-MM-dd').format(DateTime.now());

late String hour, minute, time;

late String dateTime;

var petugasSOPanggil = "";
var noDocSOPanggil = "";
var noRakPanggil = "";
var nobarangPanggil = "";
var noNamabarangPanggil = "";

var periodeSO = "";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScanerX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}

