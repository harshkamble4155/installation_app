import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:installation_app/models/db_installation_model.dart';
import 'package:installation_app/screens/fill_anode_screen.dart';
import 'package:installation_app/utils/data.dart';

class TlpInstallModel {
  String identityNo;
  String stnLocation;
  String stnType;
  String stnQty;
  String cableLength1;
  String cableLength2;
  String cableLength3;
  String thermitWelding1;
  String thermitWelding2;
  String thermitWelding3;
  bool foundation;
  bool doorlock;
  bool cableTermination;
  bool restorationCheck;
  bool continuityCheck;

  TlpInstallModel(
      {required this.identityNo,
      required this.stnLocation,
      required this.stnType,
      required this.stnQty,
      required this.cableLength1,
      required this.cableLength2,
      required this.cableLength3,
      required this.thermitWelding1,
      required this.thermitWelding2,
      required this.thermitWelding3,
      required this.foundation,
      required this.doorlock,
      required this.cableTermination,
      required this.restorationCheck,
      required this.continuityCheck});
}

class FillInstallationScreen extends StatefulWidget {
  DbInstallationModel firstData;
  FillInstallationScreen({Key? key, required this.firstData}) : super(key: key);

  @override
  State<FillInstallationScreen> createState() => _FillInstallationScreenState();
}

class _FillInstallationScreenState extends State<FillInstallationScreen> {
  final _tlpKey = GlobalKey<FormState>();
  bool foundationMounting = false;
  bool doorLocks = false;
  bool cableTermination = false;
  bool restorationCheck = false;
  bool continuityCheck = false;

  final identityNoCtrl = TextEditingController();
  final stnLocationCtrl = TextEditingController();
  final stnType = TextEditingController();
  final stnQty = TextEditingController();

  String cableLength1 = 'Select';
  String cableLength2 = 'Select';
  String cableLength3 = 'Select';
  String thermitWelding1 = 'Select';
  String thermitWelding2 = 'Select';
  String thermitWelding3 = 'Select';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("TLP Installation"),
      ),
      body: Form(
        key: _tlpKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: identityNoCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: "Test Station Identification No.",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the data';
                    }
                    return null;
                  },
                ),
                // TextFormField(
                //   controller: stnLocationCtrl,
                //   decoration: InputDecoration(
                //     labelText: "Test Station Location (Chainage in km)",
                //   ),
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Please enter the data';
                //     }
                //     return null;
                //   },
                // ),
                TextFormField(
                  controller: stnType,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: "Test Station Type ",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the data';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                TextFormField(
                  controller: stnQty,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Test Station Qty ",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the data';
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
                        "Foundation & Test Station Mounting",
                      ),
                    ),
                    Switch(
                      value: foundationMounting,
                      onChanged: (value) {
                        setState(() {
                          foundationMounting = value;
                        });
                      },
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.6,
                      child: const Text(
                        "Test Station Painting/Door/Locks/Gasket",
                      ),
                    ),
                    Switch(
                      value: doorLocks,
                      onChanged: (value) {
                        setState(() {
                          doorLocks = value;
                        });
                      },
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.6,
                      child: const Text(
                        "Cable Termination",
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
                  height: 10,
                ),

                SizedBox(
                  width: size.width * 0.6,
                  child: const Text(
                    "Length of cable(Mtrs)",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<dynamic>(
                  selectedItem: cableLength1,
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Size 1C X 06 SQ MM",
                  ),
                  onChanged: (e) {
                    setState(() {
                      cableLength1 = e.toString();
                    });
                  },
                  showSearchBox: true,
                  items: itemData,
                  validator: (value) {
                    if (value == 'Select') {
                      return 'Please select the data';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<dynamic>(
                  selectedItem: cableLength2,
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Size 1C X 10 SQ MM",
                  ),
                  onChanged: (e) {
                    setState(() {
                      cableLength2 = e.toString();
                    });
                  },
                  showSearchBox: true,
                  items: itemData,
                  validator: (value) {
                    if (value == 'Select') {
                      return 'Please select the data';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<dynamic>(
                  selectedItem: cableLength3,
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Size 1C X 25 SQ MM",
                  ),
                  onChanged: (e) {
                    setState(() {
                      cableLength3 = e.toString();
                    });
                  },
                  showSearchBox: true,
                  items: itemData,
                  validator: (value) {
                    if (value == 'Select') {
                      return 'Please select the data';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width * 0.6,
                  child: const Text(
                    "No. of Pipe to Cable connection(Thermit Welding)(Nos)",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<dynamic>(
                  selectedItem: thermitWelding1,
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Size 1C X 06 SQ MM",
                  ),
                  onChanged: (e) {
                    setState(() {
                      thermitWelding1 = e.toString();
                    });
                  },
                  showSearchBox: true,
                  items: itemData,
                  validator: (value) {
                    if (value == 'Select') {
                      return 'Please select the data';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<dynamic>(
                  selectedItem: thermitWelding2,
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Size 1C X 10 SQ MM",
                  ),
                  onChanged: (e) {
                    setState(() {
                      thermitWelding2 = e.toString();
                    });
                  },
                  showSearchBox: true,
                  items: itemData,
                  validator: (value) {
                    if (value == 'Select') {
                      return 'Please select the data';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<dynamic>(
                  selectedItem: thermitWelding3,
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Size 1C X 25 SQ MM",
                  ),
                  onChanged: (e) {
                    setState(() {
                      thermitWelding3 = e.toString();
                    });
                  },
                  showSearchBox: true,
                  items: itemData,
                  validator: (value) {
                    if (value == 'Select') {
                      return 'Please select the data';
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
                        "Restoration Check",
                      ),
                    ),
                    Switch(
                      value: restorationCheck,
                      onChanged: (value) {
                        setState(() {
                          restorationCheck = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.6,
                      child: const Text(
                        "Continuity Check",
                      ),
                    ),
                    Switch(
                      value: continuityCheck,
                      onChanged: (value) {
                        setState(() {
                          continuityCheck = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_tlpKey.currentState!.validate()) {
                      TlpInstallModel tlpInstallModel = TlpInstallModel(
                          identityNo: identityNoCtrl.text,
                          stnLocation: widget.firstData.chainage,
                          stnType: stnType.text,
                          stnQty: stnQty.text,
                          cableLength1: cableLength1,
                          cableLength2: cableLength2,
                          cableLength3: cableLength3,
                          thermitWelding1: thermitWelding1,
                          thermitWelding2: thermitWelding2,
                          thermitWelding3: thermitWelding3,
                          foundation: foundationMounting,
                          doorlock: doorLocks,
                          cableTermination: cableTermination,
                          restorationCheck: restorationCheck,
                          continuityCheck: continuityCheck);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FillAnodeScreen(
                                tlpInstallModel: tlpInstallModel,
                                firstData: widget.firstData,
                              )));
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
}
