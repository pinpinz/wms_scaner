import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:scanerx/main.dart';

import '../scanSO.dart';

scanSO form1 = new scanSO();

// PesanYaTidak(context, title, type) {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return Center(
//           child: Container(
//             height: 300,
//             width: 300,
//             child: Material(
//               color: Color.fromARGB(255, 255, 255, 255),
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     child: Text(
//                       title.toString(),
//                       style: TextStyle(
//                           fontSize: 25,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   Row(children: <Widget>[
//                     Container(
//                       margin: const EdgeInsets.only(top: 10),
//                       padding: const EdgeInsets.only(
//                           left: 30, right: 0, bottom: 10, top: 30),
//                       width: 140,
//                       child: MaterialButton(
//                         onPressed: () async {
//                           form1.fa(type);

//                         },
//                         child: const Text("Ya",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 16)),
//                         color: Color.fromARGB(255, 53, 48, 99),
//                         shape: const RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10))),
//                         padding: const EdgeInsets.all(16),
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(top: 10),
//                       padding: const EdgeInsets.only(
//                           left: 0, right: 30, bottom: 10, top: 30),
//                       width: 140,
//                       child: MaterialButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text("Tidak",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 16)),
//                         color: Color.fromARGB(255, 53, 48, 99),
//                         shape: const RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10))),
//                         padding: const EdgeInsets.all(16),
//                       ),
//                     ),
//                   ]),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

bunyi(x) async {
  ByteData bytes = await rootBundle.load(x); //load sound from assets
  Uint8List soundbytes =
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

  await player.playBytes(soundbytes, volume: 9.0);
}

prosesScaning() async {
  kodeQR = dataList[1];

  namaBarang = dataList[5];

  kodeBarangScan.add(dataList[4]);
  NamaBarangScan.add(dataList[5]);
  ExpBarangScan.add(dataList[6]);
  QRBarangScan.add(dataList[1]);

  urut = kodeBarangRekap.indexWhere((item) => item == dataList[4]);

  if (urut == -1) {
    kodeBarangRekap.add(dataList[4]);
    NamaBarangRekap.add(dataList[5]);
    BarangQty.add(1);
  } else {
    BarangQty[urut] = BarangQty[urut] + 1;
  }
  String kata = (QRBarangScan.length).toString();
}

Pesan(context, title) {
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
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(
                      left: 60, right: 60, bottom: 10, top: 30),
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    onPressed: () {
                      player.stop();
                      Navigator.pop(context);
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
