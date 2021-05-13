import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InMemoryDataStore db;
  String result = "";
  String key;
  String value;

  @override
  void initState() {
    db = InMemoryDataStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                key: Key("Key Widget"),
                decoration: InputDecoration(
                  hintText: "Enter Key",
                  icon: Icon(Icons.vpn_key),
                ),
                onChanged: (newKey) => setState(() {
                  key = newKey;
                }),
              ),
              TextFormField(
                key: Key("Value Widget"),
                decoration: InputDecoration(
                  hintText: "Enter Value",
                  icon: Icon(Icons.insert_drive_file_outlined),
                ),
                onChanged: (newValue) => setState(() {
                  value = newValue;
                }),
              ),
              SizedBox(height: 10),
              AppButton(
                title: "Create",
                onPressed: () {
                  setState(() {
                    result = db.create(key, value);
                  });
                },
                onException: (e) {
                  setState(() {
                    result = e;
                  });
                },
              ),
              AppButton(
                title: "Read",
                onPressed: () {
                  setState(() {
                    result = db.read(key);
                  });
                },
                onException: (e) {
                  setState(() {
                    result = e;
                  });
                },
              ),
              AppButton(
                title: "Update",
                onPressed: () {
                  setState(() {
                    result = db.update(key, value);
                  });
                },
                onException: (e) {
                  setState(() {
                    result = e;
                  });
                },
              ),
              AppButton(
                title: "Delete",
                onPressed: () {
                  setState(() {
                    result = db.delete(key);
                  });
                },
                onException: (e) {
                  setState(() {
                    result = e;
                  });
                },
              ),
              SizedBox(height: 10),
              Divider(thickness: 1.5),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  result,
                  key: Key("Result"),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Function(String) onException;

  AppButton({@required this.title, @required this.onPressed, @required this.onException});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: MaterialButton(
        key: Key(title),
        height: 50,
        minWidth: MediaQuery.of(context).size.width / 2,
        color: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Text(title),
        onPressed: () {
          try {
            onPressed();
          } catch (e) {
            onException(e.toString());
          }
        },
      ),
    );
  }
}

class Solution {}

class InMemoryDataStore implements DataStore {
  static AppLogger _logger = AppLogger();
  static Map<String, String> _db = {};

  // another option is setting the key internally through global counter to insure keys uniqueness
  @override
  String create(String key, String value) {
    _logger.write("Creating Entry");

    _checkKeyNotEmpty(key);
    _checkKeyNotExists(key);
    _checkValueNotEmpty(value);

    if (value == null || value.isEmpty) {
      _logger.write("Empty Key");
      throw Exception("Empty Key");
    }

    _db[key] = value;

    _logger.write("Entry Created Successfully");

    return _db[key];
  }

  @override
  String update(String key, String newValue) {
    _logger.write("Updating Entry");

    _checkKeyNotEmpty(key);
    _checkKeyExists(key);
    _checkValueNotEmpty(newValue);

    _db[key] = newValue;

    _logger.write("Entry Updated Successfully");

    return _db[key];
  }

  @override
  String delete(String key) {
    _logger.write("Removing Entry");

    _checkKeyNotEmpty(key);
    _checkKeyExists(key);

    var value = _db[key];
    _db.remove(key);

    _logger.write("Entry Removed Successfully");

    return value;
  }

  @override
  String read(String key) {
    _logger.write("Reading Entry");

    _checkKeyNotEmpty(key);
    _checkKeyExists(key);

    _logger.write("Entry Read Successfully");

    return _db[key];
  }

  void _checkKeyNotEmpty(key) {
    if (key == null || key.isEmpty) {
      _logger.write("Empty Key");
      throw Exception("Empty Key");
    }
  }

  void _checkValueNotEmpty(String value) {
    if (value == null || value.isEmpty) {
      _logger.write("Empty Value");
      throw Exception("Empty Value");
    }
  }

  void _checkKeyNotExists(String key) {
    if (_db.containsKey(key)) {
      _logger.write("Key Already Exists");
      throw Exception("Key Already Exists");
    }
  }

  void _checkKeyExists(String key) {
    if (!_db.containsKey(key)) {
      _logger.write("Key Not Found");
      throw Exception("Key Not Found");
    }
  }
}

class AppLogger implements Logger {
  @override
  Future<void> write(String message) async {
    log(message, time: DateTime.now());
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
  // I don't think this functions needs to return a future
  Future<void> write(String message);
}
