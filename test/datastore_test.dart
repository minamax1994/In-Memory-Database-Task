import 'package:flutter_test/flutter_test.dart';
import 'package:revision_task/main.dart';

void main() {
  group('DataStore Tests', () {
    final db = InMemoryDataStore();

    test('Create Test', () {
      expect(db.create("", "Mina"), "Empty Key");
      expect(db.create("1", ""), "Empty Value");
      expect(db.create("1", "Mina"), "Entry Created Successfully");
      expect(db.create("1", "Mina"), "Key Already Exists");
    });

    test('Read Test', () {
      expect(db.read(""), "Empty Key");
      expect(db.read("2"), "Key Not Found");
      expect(db.read("1"), "Mina");
    });

    test('Update Test', () {
      expect(db.update("", "Mina"), "Empty Key");
      expect(db.update("1", ""), "Empty Value");
      expect(db.update("2", "Mina"), "Key Not Found");
      expect(db.update("1", "Mina"), "Value Not Changed");
      expect(db.update("1", "New Mina"), "Entry Updated Successfully");
    });

    test('Delete Test', () {
      expect(db.delete(""), "Empty Key");
      expect(db.delete("2"), "Key Not Found");
      expect(db.delete("1"), "Entry Removed Successfully");
    });
  });
}
