import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:installation_app/models/single_row_registration_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../utils/common.dart';

class NewUser extends StatefulWidget {
  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  String uniqueDeviceId = '';
  final _name = TextEditingController();
  final _mobilenumber = TextEditingController();
  String selectedAnode = 'Select';

  @override
  void initState() {
    super.initState();
    getUniqueDeviceId();
  }

  Future<String> getUniqueDeviceId() async {
    uniqueDeviceId = '';
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId =
          '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}';
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId =
          '${androidDeviceInfo.device}${androidDeviceInfo.androidId}${androidDeviceInfo.id}';
    }
    return uniqueDeviceId;
  }

  Future<void> AddNewUser() async {
    try {
      var url = Uri.parse('${baseUrl}SetInstallationNewUser');
      var response = await http.post(url, body: {
        'name': _name.text,
        'mobilenum': _mobilenumber.text,
        'uniqueid': uniqueDeviceId,
        'status': 'Active',
        'type': 'Insert',
      });
      print('First Response: ${response.body}');

      final rowModel = singleRowRegistrationModelFromJson(response.body);

      // return rowModel.first.sts;
      if (rowModel.first.sts == 1) {
        print("Registered Successfully");
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registered Successfully"),
          ),
        );
      } else if (rowModel.first.sts == 2) {
        print("Entered Mobile Number is Already Registered");
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Entered Mobile Number is Already Registered"),
          ),
        );
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New User"),
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
                    controller: _name,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Enter Name ",
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
                    controller: _mobilenumber,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Mobile Number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Enter Mobile Number ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      showLoaderDialog(context);
                      await AddNewUser();
                    },
                    child: const Text("Register"),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => LoginScreen()));
                //   },
                //   child: const Text(
                //     "Login",
                //     style: TextStyle(
                //       color: Colors.black,
                //     ),
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     primary: Color.fromARGB(255, 235, 228, 228),
                //     minimumSize: const Size.fromHeight(40),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
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
