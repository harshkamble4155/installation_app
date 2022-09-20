import 'dart:developer';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:installation_app/api/pdf_api.dart';
import 'package:installation_app/api/pdf_invoice_api.dart';
import 'package:installation_app/models/db_installation_model.dart';
import 'package:installation_app/models/final_data_model.dart';
import 'package:installation_app/screens/fill_installaton_screen.dart';
import 'package:installation_app/utils/data.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}

class FillAnodeScreen extends StatefulWidget {
  TlpInstallModel tlpInstallModel;
  DbInstallationModel firstData;
  FillAnodeScreen(
      {Key? key, required this.tlpInstallModel, required this.firstData})
      : super(key: key);

  @override
  State<FillAnodeScreen> createState() => _FillAnodeScreenState();
}

class _FillAnodeScreenState extends State<FillAnodeScreen> {
  bool isVisible = true;

  bool cableTermination = false;
  final dentiNoCtrl = TextEditingController();
  final anodeLocCtrl = TextEditingController();
  final sacrificialAnode = TextEditingController();
  final edtsacrificialAnode = TextEditingController();
  final installationDept = TextEditingController();
  final distFromPipeline = TextEditingController();
  // String distFromPipeline = 'Select';
  String selectedAnode = 'Select';
  String selectedsacrificialAnode = 'Select';
  String tailCables = 'Select';
  String cableLengthSecond1 = 'Select';
  String strdentiNoctrl = "";
  final nspCtrl = TextEditingController();
  final pspCtrl = TextEditingController();
  final acCtrl = TextEditingController();
  final anodeCtrl = TextEditingController();
  final extraRemarks = TextEditingController();
  Map data = {};
  String strCoordinates = '';
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  bool positionStreamStarted = false;
  String selectedFile = 'No image uploaded';
  File? uploadedImageFile;
  final anodeKey = GlobalKey<FormState>();
  final anodekey2 = GlobalKey<FormState>();

  get child => null;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anode Installation"),
        actions: [
          IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: () {
              return showAlertDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: anodeKey,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Visibility(
                  visible: isVisible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: dentiNoCtrl,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Anode Dentification No.',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter data';
                          }
                          return null;
                        },
                      ),
                      // TextFormField(
                      //   controller: anodeLocCtrl,
                      //   decoration: InputDecoration(
                      //     labelText: 'Anode Location (Chainage in km)',
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter data';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.35,
                            child: DropdownSearch<dynamic>(
                              selectedItem: selectedAnode,
                              dropdownSearchDecoration: const InputDecoration(
                                  labelText: "Select Anode", hintText: "NIL"),
                              onChanged: (e) {
                                setState(() {
                                  selectedAnode = e.toString();
                                });
                              },
                              showSearchBox: true,
                              items: const ['MG', 'ZN'],
                              validator: (value) {
                                if (value == 'Select') {
                                  return 'Please select data';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.5,
                            child: DropdownSearch<dynamic>(
                              selectedItem: selectedsacrificialAnode,
                              dropdownSearchDecoration: const InputDecoration(
                                labelText: "Select Sacrificial Anode",
                              ),
                              onChanged: (e) {
                                setState(() {
                                  selectedsacrificialAnode = e.toString();
                                });
                              },
                              showSearchBox: true,
                              items: const ['5', '7.7', '10', '20', 'others'],
                              validator: (value) {
                                if (value == 'Select') {
                                  return 'Please select data';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      selectedsacrificialAnode == "others"
                          ? TextFormField(
                              controller: edtsacrificialAnode,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Others Scarifical Anode :',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter data';
                                }
                                return null;
                              },
                            )
                          : const SizedBox(),

                      TextFormField(
                        controller: installationDept,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Installation Dept(Mtrs)',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter data';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: distFromPipeline,
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Distance from Pipeline(Mtrs)',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter data';
                          }
                          return null;
                        },
                      ),

                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // DropdownSearch<dynamic>(
                      //   selectedItem: distFromPipeline,
                      //   dropdownSearchDecoration: const InputDecoration(
                      //     labelText: "Distance from Pipeline(Mtrs)",
                      //   ),
                      //   onChanged: (e) {
                      //     setState(() {
                      //       distFromPipeline = e.toString();
                      //     });
                      //   },
                      //   showSearchBox: true,
                      //   items: itemData,
                      //   validator: (value) {
                      //     if (value == 'Select') {
                      //       return 'Please select data';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // DropdownSearch<dynamic>(
                      //   selectedItem: tailCables,
                      //   dropdownSearchDecoration: const InputDecoration(
                      //     labelText: "Length of Tail cable(Mtrs)",
                      //   ),
                      //   onChanged: (e) {
                      //     setState(() {
                      //       tailCables = e.toString();
                      //     });
                      //   },
                      //   showSearchBox: true,
                      //   items: itemData,
                      //   validator: (value) {
                      //     if (value == 'Select') {
                      //       return 'Please select data';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: size.width * 0.6,
                        child: const Text(
                          "Length of Tail cable(Mtrs)",
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      DropdownSearch<dynamic>(
                        selectedItem: tailCables,
                        dropdownSearchDecoration: const InputDecoration(
                          labelText: "Size 1C X 06 SQ MM",
                        ),
                        onChanged: (e) {
                          setState(() {
                            tailCables = e.toString();
                          });
                        },
                        showSearchBox: true,
                        items: itemData,
                        validator: (value) {
                          if (value == 'Select') {
                            return 'Please select data';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.6,
                            child: const Text(
                              "Cable Termination with Test Station",
                            ),
                          ),
                          Switch(
                            value: cableTermination,
                            onChanged: (value) {
                              setState(() {
                                cableTermination = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: size.width * 0.6,
                        child: const Text(
                          "Remarks",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('NSP :- '),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: nspCtrl,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Missing";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Vdc;'),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('PSP :- '),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: pspCtrl,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Missing";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Vdc;'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('AC :- '),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: acCtrl,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Missing";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Vac;'),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Anode :- '),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: anodeCtrl,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Missing";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Vdc;'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: extraRemarks,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Extra Remarks',
                        ),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter remarks';
                        //   }
                        //   return null;
                        // }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.6,
                            child: Text(
                              selectedFile,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                // File uploadedImageFile;
                                // String selectedFile = 'No image attached';
                                var now = DateTime.now();
                                var formatter = DateFormat('yyyyMMdd_hhmmss');
                                String formattedDate1 = formatter.format(now);
                                File image = await clickImage();
                                Directory path =
                                    await getApplicationDocumentsDirectory();
                                // String path = await getExternalStorageDirectory.toString().;
                                if (!await path.exists()) {
                                  path.create();
                                  debugPrint('Path Created');
                                }

                                uploadedImageFile = await image
                                    .copy('${path.path}/$formattedDate1.jpg');
                                if (uploadedImageFile!.existsSync()) {
                                  setState(() {
                                    selectedFile = uploadedImageFile!.path
                                        .split('/')
                                        .last
                                        .toString();
                                  });
                                  Fluttertoast.showToast(msg: 'Image uploaded');
                                }
                                debugPrint(uploadedImageFile!.path);
                              } on Exception catch (e) {
                                Fluttertoast.showToast(msg: e.toString());
                                debugPrint(e.toString());
                              }
                            },
                            child: const Text("UPLOAD"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (anodeKey.currentState!.validate()) {
                            try {
                              _getCurrentPosition().then((coordinateData) {
                                if (coordinateData.isNotEmpty) {
                                  addDataToPdf(
                                      widget.firstData,
                                      widget.tlpInstallModel,
                                      size,
                                      coordinateData);
                                } else {
                                  addDataToPdfNew(widget.firstData,
                                      widget.tlpInstallModel, size, []);
                                }
                              });
                            } on Exception catch (e) {
                              Fluttertoast.showToast(
                                  msg: 'Error: ${e.toString()}');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            40,
                          ),
                        ),
                        child: const Text('Submit'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Form(
              key: anodekey2,
              child: Visibility(
                visible: !isVisible,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TextFormField(
                      //   enabled: false,
                      //   controller: dentiNoCtrl,
                      //   textCapitalization: TextCapitalization.characters,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Anode Dentification No.',

                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter data';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // TextFormField(
                      //   controller: anodeLocCtrl,
                      //   decoration: InputDecoration(
                      //     labelText: 'Anode Location (Chainage in km)',
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter data';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     SizedBox(
                      //       width: size.width * 0.35,
                      //       child: DropdownSearch<dynamic>(
                      //         selectedItem: selectedAnode,
                      //         enabled: false,
                      //         dropdownSearchDecoration: const InputDecoration(
                      //           labelText: "Select Anode",
                      //         ),
                      //         onChanged: (e) {
                      //           setState(() {
                      //             selectedAnode = e.toString();
                      //           });
                      //         },
                      //         showSearchBox: true,
                      //         items: const ['MG', 'ZN'],
                      //         validator: (value) {
                      //           if (value == 'Select') {
                      //             return 'Please select data';
                      //           }
                      //           return null;
                      //         },
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: size.width * 0.5,
                      //       child: DropdownSearch<dynamic>(
                      //         selectedItem: selectedsacrificialAnode,
                      //         enabled: false,
                      //         dropdownSearchDecoration: const InputDecoration(
                      //           labelText: "Select Sacrificial Anode",
                      //           enabled: false,
                      //         ),
                      //         onChanged: (e) {
                      //           setState(() {
                      //             selectedsacrificialAnode = e.toString();
                      //           });
                      //         },
                      //         showSearchBox: true,
                      //         items: const ['5', '7.7', '10', '20', 'others'],
                      //         validator: (value) {
                      //           if (value == 'Select') {
                      //             return 'Please select data';
                      //           }
                      //           return null;
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // TextFormField(
                      //   enabled: false,
                      //   controller: installationDept,
                      //   keyboardType: TextInputType.number,
                      //   textCapitalization: TextCapitalization.characters,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Installation Dept(Mtrs)',
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter data';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // TextFormField(
                      //   enabled: false,
                      //   controller: distFromPipeline,
                      //   textCapitalization: TextCapitalization.characters,
                      //   keyboardType: TextInputType.number,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Distance from Pipeline(Mtrs)',
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter data';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // DropdownSearch<dynamic>(
                      //   selectedItem: distFromPipeline,
                      //   dropdownSearchDecoration: const InputDecoration(
                      //     labelText: "Distance from Pipeline(Mtrs)",
                      //   ),
                      //   onChanged: (e) {
                      //     setState(() {
                      //       distFromPipeline = e.toString();
                      //     });
                      //   },
                      //   showSearchBox: true,
                      //   items: itemData,
                      //   validator: (value) {
                      //     if (value == 'Select') {
                      //       return 'Please select data';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // DropdownSearch<dynamic>(
                      //   selectedItem: tailCables,
                      //   dropdownSearchDecoration: const InputDecoration(
                      //     labelText: "Length of Tail cable(Mtrs)",
                      //   ),
                      //   onChanged: (e) {
                      //     setState(() {
                      //       tailCables = e.toString();
                      //     });
                      //   },
                      //   showSearchBox: true,
                      //   items: itemData,
                      //   validator: (value) {
                      //     if (value == 'Select') {
                      //       return 'Please select data';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // SizedBox(
                      //   width: size.width * 0.6,
                      //   child: const Text(
                      //     "Length of Tail cable(Mtrs)",
                      //   ),
                      // ),
                      // // const SizedBox(
                      // //   height: 10,
                      // // ),
                      // DropdownSearch<dynamic>(
                      //   selectedItem: tailCables,
                      //   enabled: false,
                      //   dropdownSearchDecoration: const InputDecoration(
                      //     labelText: "Size 1C X 06 SQ MM",
                      //   ),
                      //   onChanged: (e) {
                      //     setState(() {
                      //       tailCables = e.toString();
                      //     });
                      //   },
                      //   showSearchBox: true,
                      //   items: itemData,
                      //   validator: (value) {
                      //     if (value == 'Select') {
                      //       return 'Please select data';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     SizedBox(
                      //       width: size.width * 0.6,
                      //       child: const Text(
                      //         "Cable Termination with Test Station",
                      //       ),
                      //     ),
                      //     Switch(
                      //       value: cableTermination,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           cableTermination = value;
                      //         });
                      //       },
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      SizedBox(
                        width: size.width * 0.6,
                        child: const Text(
                          "Remarks",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('NSP :- '),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: nspCtrl,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Missing";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Vdc;'),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('PSP :- '),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: pspCtrl,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Missing";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Vdc;'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('AC :- '),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: acCtrl,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Missing";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Vac;'),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Anode :- '),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: anodeCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    enabled: false,
                                    hintText: '0.00',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Missing";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Vdc;'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: extraRemarks,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Extra Remarks',
                        ),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter remarks';
                        //   }
                        //   return null;
                        // }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.6,
                            child: Text(
                              selectedFile,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                // File uploadedImageFile;
                                // String selectedFile = 'No image attached';
                                var now = DateTime.now();
                                var formatter = DateFormat('yyyyMMdd_hhmmss');
                                String formattedDate1 = formatter.format(now);
                                File image = await clickImage();
                                Directory path =
                                    await getApplicationDocumentsDirectory();
                                // String path = await getExternalStorageDirectory.toString().;
                                if (!await path.exists()) {
                                  path.create();
                                  debugPrint('Path Created');
                                }

                                uploadedImageFile = await image
                                    .copy('${path.path}/$formattedDate1.jpg');
                                if (uploadedImageFile!.existsSync()) {
                                  setState(() {
                                    selectedFile = uploadedImageFile!.path
                                        .split('/')
                                        .last
                                        .toString();
                                  });
                                  Fluttertoast.showToast(msg: 'Image uploaded');
                                }
                                debugPrint(uploadedImageFile!.path);
                              } on Exception catch (e) {
                                Fluttertoast.showToast(msg: e.toString());
                                debugPrint(e.toString());
                              }
                            },
                            child: const Text("UPLOAD"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (anodeKey.currentState!.validate()) {
                            try {
                              _getCurrentPosition().then((coordinateData) {
                                if (coordinateData.isNotEmpty) {
                                  addDataToPdf(
                                      widget.firstData,
                                      widget.tlpInstallModel,
                                      size,
                                      coordinateData);
                                } else {
                                  addDataToPdfNew(widget.firstData,
                                      widget.tlpInstallModel, size, []);
                                }
                              });
                            } on Exception catch (e) {
                              Fluttertoast.showToast(
                                  msg: 'Error: ${e.toString()}');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            40,
                          ),
                        ),
                        child: const Text('Submit'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    Widget yesButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        setState(() {
          isVisible = !isVisible;
          Navigator.of(context).pop();
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Alert"),
      content: const Text("Do you Want to Skip this Anode Installation Part ?"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  addDataToPdfNew(
      DbInstallationModel firstData,
      TlpInstallModel tlpInstallModel,
      Size size,
      List<String> coordinateData) async {
    final finalInstallationData = FinalDataModel(
        widget.firstData.clientName,
        widget.firstData.diameter,
        widget.firstData.thickness,
        widget.firstData.project,
        widget.firstData.specification,
        widget.firstData.tpia,
        widget.firstData.contractor,
        widget.firstData.chainage,
        widget.firstData.km,
        widget.firstData.section,
        widget.firstData.location,
        widget.firstData.date,
        'Lat:  , Long:  ',
        widget.tlpInstallModel.identityNo,
        widget.tlpInstallModel.stnType,
        widget.tlpInstallModel.stnQty,
        widget.tlpInstallModel.foundation ? "OK" : "NOT OK",
        widget.tlpInstallModel.doorlock ? "OK" : "NOT OK",
        widget.tlpInstallModel.cableTermination ? "OK" : "NOT OK",
        widget.tlpInstallModel.cableLength1,
        widget.tlpInstallModel.cableLength2,
        widget.tlpInstallModel.cableLength3,
        widget.tlpInstallModel.thermitWelding1,
        widget.tlpInstallModel.thermitWelding2,
        widget.tlpInstallModel.thermitWelding3,
        widget.tlpInstallModel.restorationCheck ? "OK" : "NOT OK",
        widget.tlpInstallModel.continuityCheck ? "OK" : "NOT OK",
        dentiNoCtrl.text.isNotEmpty ? "" + dentiNoCtrl.text : "NIL",
        '$selectedAnode  $selectedsacrificialAnode KG',
        installationDept.text.isNotEmpty ? "" + installationDept.text : "NIL",
        distFromPipeline.text.isNotEmpty ? "" + distFromPipeline.text : "NIL",
        tailCables,
        cableTermination ? "OK" : "NOT OK",
        nspCtrl.text,
        pspCtrl.text,
        acCtrl.text,
        anodeCtrl.text,
        extraRemarks.text);
    final pdfFile = await PdfInvoiceApi.generate(
        context, size, finalInstallationData, uploadedImageFile!);
    PdfApi.openFile(pdfFile);
  }

  addDataToPdf(DbInstallationModel firstData, TlpInstallModel tlpInstallModel,
      Size size, List<String> coordinateData) async {
    String anodeAnswerProvided = "";
    if (selectedAnode == 'Select' && selectedsacrificialAnode == 'Select') {
      anodeAnswerProvided = 'NIL';
    } else if (selectedAnode != 'Select' &&
        selectedsacrificialAnode != 'others' &&
        selectedsacrificialAnode != 'Select') {
      anodeAnswerProvided = '$selectedAnode $selectedsacrificialAnode KG';
    } else if (selectedAnode != 'Select' &&
        selectedsacrificialAnode == 'others') {
      anodeAnswerProvided = '$selectedAnode ${edtsacrificialAnode.text} KG';
    }
    final finalInstallationData = FinalDataModel(
        widget.firstData.clientName,
        widget.firstData.diameter,
        widget.firstData.thickness,
        widget.firstData.project,
        widget.firstData.specification,
        widget.firstData.tpia,
        widget.firstData.contractor,
        widget.firstData.chainage,
        widget.firstData.km,
        widget.firstData.section,
        widget.firstData.location,
        widget.firstData.date,
        'Lat: ${coordinateData[1]}, Long: ${coordinateData[0]}',
        widget.tlpInstallModel.identityNo,
        widget.tlpInstallModel.stnType,
        widget.tlpInstallModel.stnQty,
        widget.tlpInstallModel.foundation ? "OK" : "NOT OK",
        widget.tlpInstallModel.doorlock ? "OK" : "NOT OK",
        widget.tlpInstallModel.cableTermination ? "OK" : "NOT OK",
        widget.tlpInstallModel.cableLength1,
        widget.tlpInstallModel.cableLength2,
        widget.tlpInstallModel.cableLength3,
        widget.tlpInstallModel.thermitWelding1,
        widget.tlpInstallModel.thermitWelding2,
        widget.tlpInstallModel.thermitWelding3,
        widget.tlpInstallModel.restorationCheck ? "OK" : "NOT OK",
        widget.tlpInstallModel.continuityCheck ? "OK" : "NOT OK",
        dentiNoCtrl.text.isNotEmpty ? "" + dentiNoCtrl.text : "NIL",
        anodeAnswerProvided != "" ? anodeAnswerProvided : 'NIL',
        installationDept.text.isNotEmpty ? "" + installationDept.text : "NIL",
        distFromPipeline.text.isNotEmpty ? "" + distFromPipeline.text : "NIL",
        tailCables,
        cableTermination ? "OK" : "NOT OK",
        nspCtrl.text,
        pspCtrl.text,
        acCtrl.text,
        anodeCtrl.text,
        extraRemarks.text);
    final pdfFile = await PdfInvoiceApi.generate(
        context, size, finalInstallationData, uploadedImageFile!);
    PdfApi.openFile(pdfFile);
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
  }

  Future<List<String>> _getCurrentPosition() async {
    List<String> data = [];
    final hasPermission = await _handlePermission();

    if (hasPermission) {
      final position = await _geolocatorPlatform.getCurrentPosition();
      data.insert(0, position.longitude.toString());
      data.insert(1, position.latitude.toString());
    }
    return data;
  }

  Future<File> clickImage() async {
    final _picker = ImagePicker();
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 300,
      imageQuality: 85,
    );
    return File(file!.path);
  }

  Future<Directory?> getPath() {
    return getExternalStorageDirectory();
  }
}
