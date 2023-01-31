import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:scanerx/formUtama.dart';
import 'package:scanerx/scanSO.dart';
import 'main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FlutterTts flutterTts = FlutterTts();

  late bool obscureText;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    print("in here");
    obscureText = true; // jika trus password hidden
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // loadSharedPreference();
  }

  // loadSharedPreference() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     var userindex = jsonDecode(prefs.getString('user')!);

  //     try {
  //       // idUser = userindex["id"];
  //       emailController.text = userindex["namaUser"];
  //       passwordController.text = userindex["passWordNormal"];
  //     } catch (e) {}
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'aset/gambar/logoScanerx.png',
                      height: (MediaQuery.of(context).size.height * (20 / 100)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 3, top: 30),
                    child: Text(
                      'ScanerX',
                      style: const TextStyle(
                          fontSize: 35,
                          color: Colors.black,
                          fontFamily: "Avenir",
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 3),
                    child: Text(
                      'PT. Eloda Mitra',
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontFamily: "Avenir",
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 60, right: 60, bottom: 10),
                    child: Material(
                      color: Color.fromARGB(255, 235, 235, 235),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      elevation: 2,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Username',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 30)),
                              controller: emailController,
                              // autofocus: true,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.person,
                              color: !obscureText
                                  ? Colors.black.withOpacity(0.3)
                                  : Color.fromARGB(255, 138, 137, 137),
                            ),
                            onPressed: () {
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 60, right: 60, bottom: 10),
                    child: Material(
                      color: Color.fromARGB(255, 235, 235, 235),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      elevation: 2,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Password',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 30)),
                              controller: passwordController,
                              obscureText: obscureText,
                              // autofocus: true,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.lock,
                              color: !obscureText
                                  ? Colors.black.withOpacity(0.3)
                                  : Color.fromARGB(255, 138, 137, 137),
                            ),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding:
                        const EdgeInsets.only(left: 60, right: 60, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: MaterialButton(
                      onPressed: () async {
                        loginValidation(context);
                      },
                      child: const Text("Login",
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
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      'IT@Bernardi.co.id',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: "Avenir",
                          fontStyle: FontStyle.normal),
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

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      callback();
    });
  }

  bunyi(x) async {
    AudioPlayer player = AudioPlayer();
    String audioasset = x;
    ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
    Uint8List soundbytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    //  int result = await player.playBytes(soundbytes);
    await player.playBytes(soundbytes, volume: 10.0);
  }

  void loginValidation(BuildContext context) async {
    bool isLoginValid = true;
    FocusScope.of(context).requestFocus(FocusNode());

    if (emailController.text.isEmpty) {
      isLoginValid = false;
      _onWidgetDidBuild(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID Tidak Boleh Kosong'),
            // backgroundColor: Colors.red,
          ),
        );
      });
    }

    if (passwordController.text.isEmpty) {
      isLoginValid = false;
      _onWidgetDidBuild(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password Tidak Boleh Kosong'),
            // backgroundColor: Colors.red,
          ),
        );
      });
    }
    if (isLoginValid) {
      fetchLogin(context, emailController.text, passwordController.text);
    }
  }

  fetchLogin(BuildContext context, String email, String password) async {
    showLoaderDialog(context);
    try {
      BaseOptions options = new BaseOptions(
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );

      Response response;
      var dio = Dio(options);

      FormData formData = new FormData.fromMap({
        "username": email,
        "password": password,
      });

      response = await dio.post(
        ip + "login.php", //endpoint api Login
        data: formData,
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        //berhasil
        hideLoaderDialog(context);

        var hasil = jsonDecode(response.data);
        if (hasil["found"] == "ok") {
          // await prefs.setString('user', jsonEncode(hasil["user"]));
          _onWidgetDidBuild(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Berhasil'),
                backgroundColor: Colors.green,
              ),
            );
          });
          //homePage
          kodeUser = hasil["kodeUser"];
          periodeSO = hasil["periode"];
          username = emailController.text;
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => home()));
        } else {
          _onWidgetDidBuild(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Gagal'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
      }
    } on DioError catch (e) {
      hideLoaderDialog(context);
      _onWidgetDidBuild(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Gagal, Koneksi Ke Server Gagal (Time Out)'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }

    //   hideLoaderDialog(context);
    //   if (e.response?.statusCode == 400) {
    //     //gagal
    //     String errorMessage = e.response?.data['error'];
    //     _onWidgetDidBuild(() {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(errorMessage),
    //           backgroundColor: Colors.red,
    //         ),
    //       );
    //     });
    //   } else {
    //     // print(e.message);
    //   }
    // }
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

  hideLoaderDialog(BuildContext context) {
    return Navigator.pop(context);
  }
}
