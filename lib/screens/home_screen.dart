import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:installation_app/helpers/db_helper.dart';
import 'package:installation_app/models/db_installation_model.dart';
import 'package:installation_app/screens/fill_installaton_screen.dart';
import 'package:installation_app/screens/loginScreen.dart';
import 'package:installation_app/screens/view_data_screen.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserLoginModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List popupMenuList = [
    {
      "icon": const Icon(
        Icons.file_copy_sharp,
        color: Colors.black,
      ),
      "title": "View Data",
    },
    {
      "icon": const Icon(
        Icons.settings,
        color: Colors.black,
      ),
      "title": "Settings",
    },
    {
      "icon": const Icon(
        Icons.logout,
        color: Colors.black,
      ),
      "title": "Logout"
    }
  ];

  final clientCtrl = TextEditingController();
  final projectCtrl = TextEditingController();
  final tpiaCtrl = TextEditingController();
  final contractorCtrl = TextEditingController();
  final diameterCtrl = TextEditingController();
  final thicknessCtrl = TextEditingController();
  final specificationCtrl = TextEditingController();
  final chainageCtrl = TextEditingController();
  final kmCtrl = TextEditingController();
  final sectionCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;

  Future<UserLoginModel> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("USERNAME")!;
    String password = prefs.getString("PASSWORD")!;
    String imeinum = prefs.getString("IMEINUM")!;

    return UserLoginModel(
        username: username, password: password, imeinum: imeinum);
  }

  checkData() {
    dbHelper.queryRowCount().then((value) async {
      if (value! > 0) {
        List<Map<String, dynamic>> data = await dbHelper.fetchData();
        data.first['clientName'];
        clientCtrl.text = data.first['clientName'];
        projectCtrl.text = data.first['project'];
        tpiaCtrl.text = data.first['tpia'];
        contractorCtrl.text = data.first['contractor'];
        diameterCtrl.text = data.first['diameter'];
        thicknessCtrl.text = data.first['thickness'];
        specificationCtrl.text = data.first['specification'];
        chainageCtrl.text = data.first['chainage'];
        kmCtrl.text = data.first['km'];
        sectionCtrl.text = data.first['section'];
        locationCtrl.text = data.first['location'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkData();
    // getUserName();
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Installation App"),
        actions: [
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
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: clientCtrl,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter data';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Client Name",
                  ),
                ),
                TextFormField(
                  controller: projectCtrl,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter data';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Project Name",
                  ),
                ),
                TextFormField(
                  controller: tpiaCtrl,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter data';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "TPIA",
                  ),
                ),
                TextFormField(
                  controller: contractorCtrl,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter data';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Contractor",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      child: TextFormField(
                        controller: diameterCtrl,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter data';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Pipe Diameter(inches)",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: TextFormField(
                        controller: thicknessCtrl,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter data';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Pipe Thickness(mm)",
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: specificationCtrl,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter data';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Pipe Specification",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.25,
                      child: TextFormField(
                        controller: chainageCtrl,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter data';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Chainage(KM)",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.25,
                      child: TextFormField(
                        controller: sectionCtrl,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter data';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Section",
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: locationCtrl,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter data';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Location",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      dbHelper.queryRowCount().then((value) {
                        if (value! > 0) {
                          Future(() {
                            _update();
                          }).then((value) {
                            var now = DateTime.now();
                            var formatter = DateFormat('dd-MM-yyyy');
                            String formattedDate = formatter.format(now);
                            DbInstallationModel dbInstallationModel =
                                DbInstallationModel(
                                    clientName: clientCtrl.text,
                                    diameter: diameterCtrl.text,
                                    thickness: thicknessCtrl.text,
                                    tpia: tpiaCtrl.text,
                                    project: projectCtrl.text,
                                    specification: specificationCtrl.text,
                                    contractor: contractorCtrl.text,
                                    chainage: chainageCtrl.text,
                                    km: kmCtrl.text,
                                    section: sectionCtrl.text,
                                    location: locationCtrl.text,
                                    date: formattedDate);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FillInstallationScreen(
                                    firstData: dbInstallationModel)));
                          });
                        } else {
                          Future(() {
                            _insert();
                          }).then((value) {
                            DateTime now = DateTime.now();
                            String formattedDate =
                                DateFormat('yMd').format(now);
                            DbInstallationModel dbInstallationModel =
                                DbInstallationModel(
                                    clientName: clientCtrl.text,
                                    diameter: diameterCtrl.text,
                                    thickness: thicknessCtrl.text,
                                    tpia: tpiaCtrl.text,
                                    project: projectCtrl.text,
                                    specification: specificationCtrl.text,
                                    contractor: contractorCtrl.text,
                                    chainage: chainageCtrl.text,
                                    km: kmCtrl.text,
                                    section: sectionCtrl.text,
                                    location: locationCtrl.text,
                                    date: formattedDate);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FillInstallationScreen(
                                    firstData: dbInstallationModel)));
                          });
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                        double.infinity, 40), // <--- this line helped me
                  ),
                  child: const Text('Next'),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DbInstallationModel> _query() async {
    final allRows = await dbHelper.fetchData();
    final data = allRows.first;
    DbInstallationModel dbInstallationModel = DbInstallationModel(
        clientName: data['clientName'],
        diameter: data['diameter'],
        thickness: data['thickness'],
        project: data['project'],
        specification: data['specification'],
        tpia: data['tpia'],
        contractor: data['contractor'],
        chainage: data['chainage'],
        km: data['km'],
        section: data['section'],
        location: data['location'],
        date: data['date']);
    return dbInstallationModel;
  }

  void _update() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yMd').format(now);
    DbInstallationModel dbInstallationModel = DbInstallationModel(
        clientName: clientCtrl.text,
        diameter: diameterCtrl.text,
        thickness: thicknessCtrl.text,
        tpia: tpiaCtrl.text,
        project: projectCtrl.text,
        specification: specificationCtrl.text,
        contractor: contractorCtrl.text,
        chainage: chainageCtrl.text,
        km: kmCtrl.text,
        section: sectionCtrl.text,
        location: locationCtrl.text,
        date: formattedDate);
    final id = dbHelper.update(dbInstallationModel.toJson());
  }

  Future<void> _insert() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yMd').format(now);
    DbInstallationModel dbInstallationModel = DbInstallationModel(
        clientName: clientCtrl.text,
        diameter: diameterCtrl.text,
        thickness: thicknessCtrl.text,
        tpia: tpiaCtrl.text,
        project: projectCtrl.text,
        specification: specificationCtrl.text,
        contractor: contractorCtrl.text,
        chainage: chainageCtrl.text,
        km: kmCtrl.text,
        section: sectionCtrl.text,
        location: locationCtrl.text,
        date: formattedDate);
    final id = dbHelper.insertData(dbInstallationModel);
  }

  Future<File> clickImage() async {
    final _picker = ImagePicker();
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 600,
      imageQuality: 80,
    );
    return File(file!.path);
  }

  Future<Directory?> getPath() {
    return getExternalStorageDirectory();
  }
}
