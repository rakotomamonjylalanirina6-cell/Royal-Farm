
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_record.dart';

class HealthStorageService {
  static const String _storageKey = 'royal_farm_health_records';

  Future<List<HealthRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded
          .map((item) => HealthRecord.fromMap(
                Map<String, dynamic>.from(item),
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveRecords(List<HealthRecord> records) async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(
      records.map((record) => record.toMap()).toList(),
    );

    await prefs.setString(_storageKey, data);
  }

  Future<void> addRecord(HealthRecord record) async {
    final records = await getRecords();

    if (records.any((item) => item.id == record.id)) {
      throw Exception('Efa misy io laharana io.');
    }

    records.add(record);
    await saveRecords(records);
  }

  Future<void> deleteRecord(String id) async {
    final records = await getRecords();
    records.removeWhere((record) => record.id == id);
    await saveRecords(records);
  }
}
