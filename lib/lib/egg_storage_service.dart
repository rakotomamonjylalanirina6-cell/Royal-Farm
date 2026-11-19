
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/egg_record.dart';

class EggStorageService {
  static const String storageKey = 'royal_farm_eggs';

  Future<List<EggRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(storageKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(data);

      return decoded.map((item) {
        return EggRecord.fromMap(
          Map<String, dynamic>.from(item),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveRecords(List<EggRecord> records) async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(
      records.map((record) => record.toMap()).toList(),
    );

    await prefs.setString(storageKey, data);
  }

  Future<void> addRecord(EggRecord record) async {
    final records = await getRecords();

    final exists = records.any(
      (item) => item.id == record.id,
    );

    if (exists) {
      throw Exception('Efa misy io ID io.');
    }

    records.add(record);
    await saveRecords(records);
  }

  Future<void> deleteRecord(String id) async {
    final records = await getRecords();

    records.removeWhere(
      (record) => record.id == id,
    );

    await saveRecords(records);
  }
}
