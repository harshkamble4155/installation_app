import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:installation_app/models/single_row_login_model.dart';
import 'package:installation_app/screens/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/common.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late String username, password, imeinum, name, status, role;
  List data = [];

  String selectedAnode = 'Select';
  String selectedRole = 'Select';
  String selectedsp = '';

  String split_name = '';
  String passwordstr = '';

  final _username = TextEditingController();
  final _password = TextEditingController();
  final _imei_num = TextEditingController();
  final _name = TextEditingController();
  final _role = TextEditingController();

  // final String url =
  //     "https://192.168.0.48:45460/home/SetInstallationRegistration";

  Future<void> registerData() async {
    try {
      var url = Uri.parse('${baseUrl}SetInstallationRegistration');
      var response = await http.post(url, body: {
        'username': _username.text,
        'password': _password.text,
        'ime_num': _imei_num.text,
        'name': _name.text,
        'status': selectedAnode,
        'role': selectedRole,
        'type': 'Insert',
      });
      final rowModel = singleRowLoginModelFromJson(response.body);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<String> FetchNewUserList() async {
    var url = Uri.parse('${baseUrl}GetNewUserData');
    var response = await http.post(url, body: {
      'Accept': 'application/json',
    });

    setState(() {
      Map<String, dynamic> map = json.decode(response.body);
      data = map["newuserlist"];
      print(data);
    });
    return "Success";
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    FetchNewUserList();
    super.initState();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel"), actions: [
        IconButton(
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Logout?'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        logoutUser();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false);
                      },
                      child: const Text('Okay'),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.power_settings_new),
        ),
      ]),
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
                  child: SizedBox(
                    height: 50,
                    child: DropdownButton<String>(
                      isExpanded: true,

                      hint: Text("Select Name :" + split_name),
                      items: data.map(
                        (item) {
                          return DropdownMenuItem<String>(
                            value: item['name'] +
                                "," +
                                item['uniqueid'] +
                                "," +
                                item['mobilenum'] +
                                "," +
                                item['Id'].toString(),
                            child: Text(item['name']),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(
                          () {
                            selectedsp = value.toString();
                            print("Selected Value:" + selectedsp);
                            final values = selectedsp.split(',');

                            _name.text = (values[0]);

                            _imei_num.text = (values[1]);
                            //Generating UserId
                            _username.text = "INS/000" + (values[3]);
                            //Generating Password
                            passwordstr = selectedsp.toString();
                            _password.text = (passwordstr.substring(1, 4)) +
                                (passwordstr.substring(10, 15));
                          },
                        );
                      },
                      // value: _mySelection,
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _username,
                    keyboardType: TextInputType.text,
                    enabled: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter UserName';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Generated UserName ",
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
                    controller: _password,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Generated Password ",
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
                    controller: _imei_num,
                    keyboardType: TextInputType.text,
                    enabled: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Device Unique Number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Deive Unique Number ",
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
                    controller: _name,
                    keyboardType: TextInputType.text,
                    enabled: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Name ';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Name ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                // Padding(
                //   padding:
                //       const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                //   child: TextFormField(
                //     controller: _status,
                //     keyboardType: TextInputType.text,
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Please enter Status ';
                //       }
                //       return null;
                //     },
                //     decoration: const InputDecoration(
                //       labelText: "Enter Status ",
                //       border: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           width: 0.5,
                //           color: Colors.black,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: SizedBox(
                    child: DropdownSearch<dynamic>(
                      selectedItem: selectedAnode,
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Select Status",
                      ),
                      onChanged: (e) {
                        setState(() {
                          selectedAnode = e.toString();
                        });
                      },
                      showSearchBox: true,
                      items: const ['Active', 'DeActive'],
                      validator: (value) {
                        if (value == 'Select') {
                          return 'Please select data';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Padding(
                //   padding:
                //       const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                //   child: TextFormField(
                //     controller: _role,
                //     keyboardType: TextInputType.text,
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Please enter Role ';
                //       }
                //       return null;
                //     },
                //     decoration: const InputDecoration(
                //       labelText: "Enter Role ",
                //       border: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           width: 0.5,
                //           color: Colors.black,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: SizedBox(
                    child: DropdownSearch<dynamic>(
                      selectedItem: selectedRole,
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Select Role",
                      ),
                      onChanged: (e) {
                        setState(() {
                          selectedRole = e.toString();
                        });
                      },
                      showSearchBox: true,
                      items: const ['Admin', 'Contractor'],
                      validator: (value) {
                        if (value == 'Select') {
                          return 'Please select data';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await registerData();
                    },
                    child: const Text("Register"),
                  ),
                ),
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
              child: const Text("Please wait...")),
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
