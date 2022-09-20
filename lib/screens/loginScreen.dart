import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:installation_app/models/single_row_login_model.dart';
import 'package:installation_app/screens/adminScreen.dart';
import 'package:installation_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/common.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
// import 'package:imei_plugin/imei_plugin.dart';
// import 'package:imei/imei.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String uniqueDeviceId = '';
  String finalstatus = '';
  final username = TextEditingController();
  final password = TextEditingController();
  final imeinum = TextEditingController();

  @override
  void initState() {
    getUniqueDeviceId();

    // getValidateUser().whenComplete(() async {
    //   Timer(Duration(seconds: 2), () => () {});
    // });
    super.initState();
  }

  Future<String> getUniqueDeviceId() async {
    uniqueDeviceId = '';

    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId =
          '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}'; // unique ID on iOS

    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId =
          '${androidDeviceInfo.device}${androidDeviceInfo.androidId}${androidDeviceInfo.id}'; // unique ID on Android

    }
    // print("DATATA :" + uniqueDeviceId);
    return uniqueDeviceId;
  }

  Future getValidateUser() async {
    final SharedPreferences sharedperferences =
        await SharedPreferences.getInstance();
    var isloggedIn = sharedperferences.getString("USERNAME");
    setState(() {
      finalstatus = isloggedIn!;
    });
    // print("Final Status " + finalstatus);
  }

  loginUser(String username, String password, String ime_num) async {
    showLoaderDialog(context);
    var url = Uri.parse('${baseUrl}SetInstallationUserLogin');
    var response = await http.post(url,
        body: {'username': username, 'password': password, 'ime_num': ime_num});
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final loginDataModel = singleRowLoginModelFromJson(response.body);
      // print(loginDataModel.userDetails.first.sts);

      if (loginDataModel.userDetails.first.sts == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString("USERNAME", loginDataModel.userDetails.first.username);
        prefs.setString("PASSWORD", loginDataModel.userDetails.first.password);
        prefs.setString("IMEINUM", loginDataModel.userDetails.first.ime_num);
        prefs.setInt("Role", loginDataModel.userDetails.first.sts);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Successfully"),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      } else if (loginDataModel.userDetails.first.sts == 2) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString("USERNAME", loginDataModel.userDetails.first.username);
        prefs.setString("PASSWORD", loginDataModel.userDetails.first.password);
        prefs.setString("IMEINUM", loginDataModel.userDetails.first.ime_num);
        prefs.setInt("Role", loginDataModel.userDetails.first.sts);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Successfully"),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AdminScreen()),
            (route) => false);
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Some error has occurred"),
          ),
        );
      }
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Some error has occurred"),
        ),
      );
    }
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login "),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: username,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter UserName';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Enter User Name ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Enter Password ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: Visibility(
                    visible: false,
                    child: TextFormField(
                      controller: imeinum,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter imei number';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Enter IMEI Number ",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => HomeScreen()));
                //   },
                //   child: const Text(
                //     "Login",
                //     style: TextStyle(
                //       color: Color.fromARGB(255, 0, 0, 0),
                //     ),
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     primary: Color.fromARGB(255, 25, 72, 226),
                //     minimumSize: const Size.fromHeight(40),
                //   ),
                // ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        loginUser(username.text, password.text, uniqueDeviceId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter all fields'),
                          ),
                        );
                      }
                      // print("onCLick" + uniqueDeviceId);
                      // if (_formkey.currentState!.validate()) {
                      //   print("Login  Successfully ");
                      // } else {
                      //   //   print("Please Check details you have Filled");
                      //   // }
                      //   // Navigator.of(context).push(MaterialPageRoute(
                      //   //     builder: (context) => HomeScreen()));
                      // }
                    },
                    child: const Text("Login"),
                  ),
                ),
                const SizedBox(
                  width: 200,
                  height: 20,
                ),
                const SizedBox(
                  width: 500,
                  height: 20,
                  child: Text(
                      "<--------------------------------OR-------------------------------->",
                      textAlign: TextAlign.center),
                ),
                const SizedBox(
                  width: 200,
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/NewUser");
                  },
                  child: const Text("Register", textAlign: TextAlign.center),
                ),
              ],
            )),
      )),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Text("Loading..."),
          ),
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
}
