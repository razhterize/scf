import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String text = "a";

  List<Cell>? names;
  List<Cell>? dcIds;
  List<Cell>? tofIds;

  void init() async {
    final gsheet = GSheets(credential);
    final ss = await gsheet.spreadsheet('1zXKuifp4-TO7Rv3OIspaOO5gkkWSYedklQRPjfLSx5I');
    final sheet = ss.worksheetByTitle("Asia");
    names = await sheet?.cells.column(4, fromRow: 2, length: 140);
    dcIds = await sheet?.cells.column(3, fromRow: 2, length: 140);
    tofIds = await sheet?.cells.column(5, fromRow: 2, length: 140);
    print("Done Init");
  }

  void showValue() {
    int index = names!.length;
    print(index);
    for (int x = 0; x <= index - 1; x++) {
      if (names![x].value.isNotEmpty) print(names![x].value);
      if (dcIds![x].value.isNotEmpty) print(dcIds![x].value);
      if (tofIds![x].value.isNotEmpty) print(tofIds![x].value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SCF Management App",
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(text),
              MaterialButton(
                onPressed: init,
                child: const Text("Init GSheets API"),
              ),
              MaterialButton(
                onPressed: showValue,
                child: const Text("Print Entire Sheet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
