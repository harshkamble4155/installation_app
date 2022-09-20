import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                Column(children: const [
                  Text(
                    'ADANI GAS',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ]),
                Column(children: const [
                  Text(
                    'TEST STATION LOCATION POINT & ANODE INSTALLATION',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  )
                ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Doc. No:. PRJ 216',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        'Rev. No:. 00',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        'Eff. Date:. 01.02.2018',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
