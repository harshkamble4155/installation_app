import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:installation_app/api/pdf_api.dart';
import 'package:installation_app/models/final_data_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(
      context, size, FinalDataModel finalDataModel, File file) async {
    final image = MemoryImage(file.readAsBytesSync());
    if (finalDataModel.extraRemarks.isEmpty) {
      print('not exists');
    }
    if (finalDataModel.extraRemarks.isNotEmpty) {
      print('exists');
    }
    final pdf = Document(
      compress: true,
    );

    try {
      pdf.addPage(
        MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const EdgeInsets.all(30),
          build: (context) => [
            buildHeader(context, size, finalDataModel),
            buildHeader2(context, size, finalDataModel),
            insideHeader('TLP INSTALLATION'),
            middleColumn1(size, finalDataModel),
            middleColumn2('Length of cable(Mtrs)', size, finalDataModel),
            middleColumn25(
                'No. of Pipe to Cable connection (Thermit Welding)(Nos)',
                size,
                finalDataModel),
            middleColumn3(size, finalDataModel),
            insideHeader('ANODE INSTALLATION'),
            middleColumn4(size, finalDataModel),
            insideHeader(
                'Remarks :- NSP: ${finalDataModel.nsp} Vdc; PSP: ${finalDataModel.psp} Vdc; AC: ${finalDataModel.ac} Vac; Anode: ${finalDataModel.anode} Vdc. ${finalDataModel.extraRemarks}'),
            footerColumn(finalDataModel, pdf),
            addImageClicked(image),
            withImage(size, finalDataModel),
          ],
        ),
      );
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    var now = DateTime.now();
    var formatter = DateFormat('yyyyMMddhhmmss');
    String formattedDate1 = formatter.format(now);
    return PdfApi.saveDocument(fileName: '$formattedDate1.pdf', pdf: pdf);
  }

  static Widget addImageClicked(MemoryImage image) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image,
                  width: 300,
                  height: 400,
                ),
                SizedBox(
                  height: 5,
                ),
                Text('Possible image of TLP Installation'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget footerColumn(FinalDataModel finalDataModel, Document pdf) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  'Company',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  finalDataModel.contractor,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  finalDataModel.tpia,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  finalDataModel.clientName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  'Sign',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            Column(children: [
              Text(
                ' ',
                textAlign: TextAlign.center,
              ),
            ]),
            Column(children: [
              Text(
                ' ',
                textAlign: TextAlign.center,
              ),
            ]),
            Column(children: [
              Text(
                ' ',
                textAlign: TextAlign.center,
              ),
            ]),
          ],
        ),
        TableRow(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            Column(children: [
              Text(
                ' ',
                textAlign: TextAlign.center,
              ),
            ]),
            Column(children: [
              Text(
                ' ',
                textAlign: TextAlign.center,
              ),
            ]),
            Column(children: [
              Text(
                ' ',
                textAlign: TextAlign.center,
              ),
            ]),
          ],
        ),
        TableRow(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            Column(children: [
              Text(
                ' ' + finalDataModel.date,
                textAlign: TextAlign.center,
              ),
            ]),
            Column(children: [
              Text(
                ' ' + finalDataModel.date,
                textAlign: TextAlign.center,
              ),
            ]),
            Column(children: [
              Text(
                ' ' + finalDataModel.date,
                textAlign: TextAlign.center,
              ),
            ]),
          ],
        ),
      ],
    );
  }

  static Widget withImage(size, FinalDataModel finalDataModel) {
    return Table(
      border: TableBorder.all(),
      children: [
        // first row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Pipe Section Length :',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      'Ch ${finalDataModel.chainage} km ${finalDataModel.diameter}" Section ${finalDataModel.section}',
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Location :',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.location,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Date :',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.date,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Co-ordinate :',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.coordinate,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget middleColumn4(size, FinalDataModel finalDataModel) {
    return Table(
      border: TableBorder.all(),
      children: [
        // first row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Anode Dentification No',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.dentificationNo,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // 2nd row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Anode Location(Chainage of km)',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.chainage,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // third row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Type of Sacrificial Anode(Zinc/Mg Anode)',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.sacrificialAnode,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // here starts 2nd main row
        // first row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Installation Depth(Mtrs)',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.installationDept,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // 2nd row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Distance from Pipeline(Mtrs)',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.distanceFrmPipe,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Length of Tail Cables(Mtrs)',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.taileCable,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // third row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Cable Termination with Test Station',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.cableTerminationTest,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget middleColumn3(size, FinalDataModel finalDataModel) {
    return Table(border: TableBorder.all(), children: [
      TableRow(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  'Restoration Check',
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: SizedBox(
                  width: 50,
                  child: Text(
                    finalDataModel.restoration,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      // 2nd row
      TableRow(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  'Continuity Check',
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: SizedBox(
                  width: 50,
                  child: Text(
                    finalDataModel.continuity,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  static Widget middleColumn2(text, size, FinalDataModel finalDataModel) {
    return Table(
      border: TableBorder.all(),
      children: [
        // first row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              'Size 1C X 06 SQ MM',
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              'Size 1C X 10 SQ MM',
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              'Size 1C X 25 SQ MM',
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 50,
                            child: Text(
                              finalDataModel.cable1,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 50,
                            child: Text(
                              finalDataModel.cable2,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 50,
                            child: Text(
                              finalDataModel.cable3,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget middleColumn25(text, size, FinalDataModel finalDataModel) {
    return Table(
      border: TableBorder.all(),
      children: [
        // first row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              'Size 1C X 06 SQ MM',
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              'Size 1C X 10 SQ MM',
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              'Size 1C X 25 SQ MM',
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 50,
                            child: Text(
                              finalDataModel.thermitWelding1,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 50,
                            child: Text(
                              finalDataModel.thermitWelding2,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 50,
                            child: Text(
                              finalDataModel.thermitWelding3,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget middleColumn1(size, FinalDataModel finalDataModel) {
    return Table(
      border: TableBorder.all(),
      children: [
        // first row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Test Station Indentification No.',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.identificationNo,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // 2nd row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Test Station Location (Chainage in km)',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.chainage,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // third row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Test Station (Type & Qty)',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.typeQty +
                          "           " +
                          finalDataModel.typeQty2,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // TableRow(
        //   children: [
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(3),
        //           child: Text(
        //             'Type & Qty',
        //             style: const TextStyle(
        //               fontSize: 10,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),

        //   ],
        // ),
        // here starts 2nd main row
        // first row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Foundation & Test Station Mounting',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.foundationMounting,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // 2nd row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Test Station Painting / Doors / Locks / Gasket',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.doorLocks,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // third row
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Cable Termination',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      finalDataModel.termination,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget insideHeader(text) {
    return Table(border: TableBorder.all(), children: [
      TableRow(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  static Widget buildHeader(context, size, FinalDataModel finalDataModel) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      finalDataModel.clientName,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'TEST STATION LOCATION POINT & ANODE INSTALLATION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 5,
                      right: 5,
                    ),
                    child: Text(
                      'Doc. No:. PRJ 216',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 5,
                      right: 5,
                    ),
                    child: Text(
                      'Rev. No:. 00',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 5,
                      right: 5,
                      bottom: 5,
                    ),
                    child: Text(
                      'Eff. Date:. 01.02.2018',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildHeader2(context, size, FinalDataModel finalDataModel) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Client: ',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: size.width * 0.45,
                    child: Text(
                      finalDataModel.clientName,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Pipe Dia & Thickness: ',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    '${finalDataModel.diameter}" & ${finalDataModel.thickness}mm',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Project: ',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: size.width * 0.45,
                    child: Text(
                      finalDataModel.project,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Pipe Specification: ',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    finalDataModel.specification,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'TPIA: ',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: size.width * 0.45,
                    child: Text(
                      finalDataModel.tpia,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Pipe Section Length: ',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Ch ${finalDataModel.chainage} km ${finalDataModel.diameter}" Section ${finalDataModel.section}',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Contractor: ',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: size.width * 0.45,
                    child: Text(
                      finalDataModel.contractor,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Location: ',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    finalDataModel.location,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            //here
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Date: ',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SizedBox(
                    width: size.width * 0.45,
                    child: Text(
                      finalDataModel.date,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Co-ordinate: ',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    finalDataModel.coordinate,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
