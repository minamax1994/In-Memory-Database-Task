import 'package:flutter_test/flutter_test.dart';
import 'package:revision_task/main.dart';

void main() {
  group('DataStore Tests', () {
    final db = InMemoryDataStore();

    test('Create Test', () {
      expect(db.create("1", "Mina"), "Mina");
    });

    test('Read Test', () {
      expect(db.read("1"), "Mina");
    });

    test('Update Test', () {
      expect(db.update("1", "New Mina"), "New Mina");
    });

    test('Delete Test', () {
      expect(db.delete("1"), "New Mina");
    });
  });
}
