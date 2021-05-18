import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Solution(),
    );
  }
}

class Solution extends StatefulWidget {
  @override
  _SolutionState createState() => _SolutionState();
}

class _SolutionState extends State<Solution> {
  final keyController = TextEditingController();
  final valueController = TextEditingController();
  late InMemoryDataStore db;
  String result = "";
  List<TableRow> dataRows = [];

  @override
  void initState() {
    db = InMemoryDataStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    prepareDataRows();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.grey,
        title: Text("In-Memory DataBase"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              buildTextFields(),
              SizedBox(height: 10),
              buildButtons(),
              SizedBox(height: 10),
              Divider(thickness: 1.5),
              buildResult(),
              Divider(thickness: 1.5),
              buildTable(),
            ],
          ),
        ),
      ),
    );
  }

  void prepareDataRows() {
    dataRows.clear();
    if (db.values.isNotEmpty) {
      dataRows = [
        TableRow(
          children: [
            AppText("Key", fontWeight: FontWeight.bold),
            AppText("Value", fontWeight: FontWeight.bold),
          ],
        )
      ];
    }
    db.values.forEach((key, value) {
      dataRows.add(TableRow(
        children: [AppText(key), AppText(value)],
      ));
    });
  }

  Widget buildTextFields() {
    return Column(
      children: [
        TextField(
          controller: keyController,
          decoration: InputDecoration(
            hintText: "Enter Key",
            icon: Icon(Icons.vpn_key),
          ),
        ),
        TextField(
          controller: valueController,
          decoration: InputDecoration(
            hintText: "Enter Value",
            icon: Icon(Icons.insert_drive_file_outlined),
          ),
        ),
      ],
    );
  }

  Widget buildButtons() {
    return Wrap(
      spacing: 10,
      children: [
        AppButton(
          title: "Create",
          onPressed: () => setState(() => result = db.create(keyController.text.trim(), valueController.text.trim())),
        ),
        AppButton(
          title: "Read",
          onPressed: () => setState(() => result = db.read(keyController.text.trim())),
        ),
        AppButton(
          title: "Update",
          onPressed: () => setState(() => result = db.update(keyController.text.trim(), valueController.text.trim())),
        ),
        AppButton(
          title: "Delete",
          onPressed: () => setState(() => result = db.delete(keyController.text.trim())),
        ),
      ],
    );
  }

  Widget buildResult() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        result,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTable() {
    return Table(
      border: TableBorder.all(width: 0.5),
      children: dataRows,
    );
  }
}

class AppText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;

  AppText(this.text, {this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: fontWeight),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  AppButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: MaterialButton(
        height: 50,
        minWidth: (MediaQuery.of(context).size.width - 80) / 2,
        color: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Text(title),
        onPressed: () => onPressed(),
      ),
    );
  }
}

class InMemoryDataStore implements DataStore {
  static AppLogger _logger = AppLogger();
  static Map<String, String> _db = {};

  Map<String, String> get values => _db;

  @override
  String create(String key, String value) {
    _logger.write("Creating Entry");

    if (key.isEmpty) {
      _logger.write("Empty Key");
      return "Empty Key";
    }
    if (value.isEmpty) {
      _logger.write("Empty Value");
      return "Empty Value";
    }
    if (_db.containsKey(key)) {
      _logger.write("Key Already Exists");
      return "Key Already Exists";
    }

    _db[key] = value;

    _logger.write("Entry Created Successfully");
    return "Entry Created Successfully";
  }

  @override
  String update(String key, String newValue) {
    _logger.write("Updating Entry");

    if (key.isEmpty) {
      _logger.write("Empty Key");
      return "Empty Key";
    }
    if (newValue.isEmpty) {
      _logger.write("Empty Value");
      return "Empty Value";
    }
    if (!_db.containsKey(key)) {
      _logger.write("Key Not Found");
      return "Key Not Found";
    }
    if (_db[key] == newValue) {
      _logger.write("Value Not Changed");
      return "Value Not Changed";
    }

    _db[key] = newValue;

    _logger.write("Entry Updated Successfully");
    return "Entry Updated Successfully";
  }

  @override
  String delete(String key) {
    _logger.write("Removing Entry");

    if (key.isEmpty) {
      _logger.write("Empty Key");
      return "Empty Key";
    }
    if (!_db.containsKey(key)) {
      _logger.write("Key Not Found");
      return "Key Not Found";
    }

    _db.remove(key);

    _logger.write("Entry Removed Successfully");
    return "Entry Removed Successfully";
  }

  @override
  String read(String key) {
    _logger.write("Reading Entry");

    if (key.isEmpty) {
      _logger.write("Empty Key");
      return "Empty Key";
    }
    if (!_db.containsKey(key)) {
      _logger.write("Key Not Found");
      return "Key Not Found";
    }

    _logger.write("Entry Read Successfully");
    return _db[key]!;
  }
}

class AppLogger implements Logger {
  @override
  void write(String message) {
    print(message);
    return;
  }
}

abstract class DataStore {
  String create(String key, String value);

  String update(String key, String newValue);

  String read(String key);

  String delete(String key);
}

abstract class Logger {
  void write(String message);
}
