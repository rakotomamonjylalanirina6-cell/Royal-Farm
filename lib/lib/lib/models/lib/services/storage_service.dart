
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chick.dart';

class ChickStorageService {
  static const String storageKey = 'royal_farm_chicks';

  Future<List<Chick>> getChicks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(storageKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(data);

      return decoded.map((item) {
        return Chick.fromMap(
          Map<String, dynamic>.from(item),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveChicks(List<Chick> chicks) async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(
      chicks.map((chick) => chick.toMap()).toList(),
    );

    await prefs.setString(storageKey, data);
  }

  Future<void> addChick(Chick chick) async {
    final chicks = await getChicks();

    final exists = chicks.any((item) => item.id == chick.id);

    if (exists) {
      throw Exception('Efa misy io ID io.');
    }

    chicks.add(chick);
    await saveChicks(chicks);
  }

  Future<void> deleteChick(String id) async {
    final chicks = await getChicks();

    chicks.removeWhere((chick) => chick.id == id);

    await saveChicks(chicks);
  }
}
