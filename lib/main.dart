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
  final credential = r'''
  {
    "type": "service_account",
    "project_id": "turuminder",
    "private_key_id": "94dcfb53f336270256674f4cfb97a7023e709c2c",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCPFdKe7xuTZItR\nrXAsOnFEPkX9hqli5V+JURKTSK5ssx+8AGZxvnBwIwBz0YE1Du9kh4zNdiaM6kUk\nC1mfUnSqbZBVfSEWzwNIQ9D4j0KLg9sXlV0wvqrGx6Inm07eQWW8gZOYf6cfuEUO\nAMFYCrpr55Te5McdC4mQxZhGHbIPDOda0N4PpKjWoHwouRB1Sk8/kEf1QDh7mHpW\nWxZSswhOIT4bEJLrVBTMVw1GwQEgZ5haF1hP+EwtkJ5fd010be7FIHKRS1qnmRDC\nyo0qNd1pBuOaigsfRg9rMqdy2SeBeXFBeD6xFAtrPKpX0SuXxn8lBG/Fmc+J+4if\nx64742w3AgMBAAECggEAOwA0qXTPWifLixKJfrNaoVlMYw50KmOK0YSstC70Pb5f\nB5bip2Rv2M2WEiwBq29NJ5b9aHufyduQRxynCBtoIB6ttZKzYkRahiHwuY3ZUs48\nOa1NkBwPL4iCRPK1wtAUs3Z69hctQtcpIm0NTNCfrn7/1CliMYfgYeIYuFDma224\nxxd1km5tDDELWClT0gA4dcA95BZZGEnoLI0ojU83XsiZSC6TIYP04Lm5MxuM6uS+\nSZ9yP9KDlnjyxsGBy7jrkzQeWQwJUMT1n9BE95bHOd6XTszYrDqOb7vHbnR8Xxrv\nglZ6OCa0yFAbA45/FvXGbA8wqSgWTvGuC2PJzTUVgQKBgQDGc4hK4OhOo7FLdIZT\nSJlHgmLNxndtFbknl08qw4IPZyq2tnC/wba70QY+/pgwO0OUuKP/p4uL4ZgK+srk\nvzUUmnnlrD0mT9v3dg021h6bydHYA4lLZggVhIYw5+bokYC5tEOEDEbdcRxzMbfN\nrbJBE7r+/L/QqQNOmx1ZvlAoswKBgQC4lBHj4AiYskU1xSEx7UwjRJkOhxvhijhw\n/7dL26j4d2iVe0kFLfFoZbr2LK4ySvqzUIjBs79S7i6/9RQATZlVIDH6qFRbx+qC\nSrafdjvyfyvJ1Wj1JDgdkuksobhlQBUS0mqRlODC07uKx7usEoB8zLl7Keykx7vH\ndbfsDNGIbQKBgB2AqX9wRjkCruXn0dxpy5fM84FiAvktpJQVM4jI/fnqPXhiUQrA\n8rijT4ln8hohhV+Dv6XPM7i89gyT0jwFjQ+eE4cofwLGFo6Id1hypqREcbTqeavC\n5GrGg+ibYUGr9/YjrXHhHVvoZ/FcL9Yc/4YbN86WprGPntU9zDQ+Tc5vAoGAKwja\n4vZpCrEF0fOUOb/J8K8dwHVf2sYPQslcQyOD0eqFR9TmwX5kuqJ9ZMgmFTPGH+i2\n+fKeuQcvfzH0590v0tkezgJRKNUDqD0jNyqp73AXFYfcYMuBCeQm2XEbPQAj6a+F\niUvc24/iOgk3iHcH3hEdbcnoksK+1VJs/2w9rkECgYASr4X1pVkoXtD48D29jkwd\nd8lCgM+r0BDRJxIJYCyL+7WNHRaq5e18Q61kQRNrFJWE+yxSXfAbzvA+X7VJORE6\nNbpOOxDIiC3ezF2oYPvOnQjYIZXIZheABf6j+EuRZxiJcrnHUSuND3w/eqrf9ANe\nGLJHRMhBD/uEFDkLFLnCNQ==\n-----END PRIVATE KEY-----\n",
    "client_email": "turu-46@turuminder.iam.gserviceaccount.com",
    "client_id": "100255595444404091866",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/turu-46%40turuminder.iam.gserviceaccount.com"
  }
  ''';
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
