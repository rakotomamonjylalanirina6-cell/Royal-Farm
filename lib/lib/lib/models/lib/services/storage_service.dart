
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bird.dart';

class StorageService {
  static const String _birdsKey = 'royal_farm_birds';

  Future<List<Bird>> getBirds() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_birdsKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(data);

    return decoded.map((item) {
      return Bird.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  Future<void> saveBirds(List<Bird> birds) async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(
      birds.map((bird) => bird.toMap()).toList(),
    );

    await prefs.setString(_birdsKey, data);
  }

  Future<void> addBird(Bird bird) async {
    final birds = await getBirds();
    birds.add(bird);
    await saveBirds(birds);
  }

  Future<void> deleteBird(String id) async {
    final birds = await getBirds();
    birds.removeWhere((bird) => bird.id == id);
    await saveBirds(birds);
  }
}
