import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferencesHelper? _instance;
  SharedPreferences? _prefs;

  SharedPreferencesHelper._();

  static Future<SharedPreferencesHelper> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesHelper._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Salva uma lista de objetos no SharedPreferences
  Future<void> saveList<T>(String key, List<T> list) async {
    final List<String> encodedList =
        list.map((item) => json.encode(item)).toList();
    await _prefs!.setStringList(key, encodedList);
  }

  // Recupera uma lista de objetos do SharedPreferences
  Future<List<T>> getList<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    final List<String>? encodedList = _prefs!.getStringList(key);
    if (encodedList != null) {
      final List<T> decodedList = encodedList
          .map((encodedItem) => fromJson(json.decode(encodedItem)))
          .toList();
      return decodedList;
    } else {
      return [];
    }
  }

  // Registra a data e hora da última sincronização para um tipo de objeto
  void registerLastSyncTime<T>(String key) {
    final now = DateTime.now();
    _prefs!.setString('{$key}_last_sync_time', now.toIso8601String());
  }

  // Verifica se um tipo de objeto foi sincronizado nas últimas 48 horas

  bool hasRecentSync<T>(String key) {
    final lastSyncKey = '{$key}_last_sync_time'; // Correção
    final lastSyncTime = _prefs!.getString(lastSyncKey);
    if (lastSyncTime != null) {
      final lastSync = DateTime.parse(lastSyncTime);
      final now = DateTime.now();
      final difference = now.difference(lastSync);
      return difference.inHours < 48;
    }
    return false;
  }

  //String
  Future<void> saveString(String key, String value) async {
    await _prefs!.setString(key, value);
  }

  Future<String> getString(String key) async {
    return _prefs!.getString(key) ?? '';
  }

  //map
  Future<void> saveMap(String key, Map<String, dynamic> value) async {
    await _prefs!.setString(key, json.encode(value));
  }

  Future<Map<String, dynamic>> getMap(String key) async {
    final String? value = _prefs!.getString(key);
    if (value != null) {
      return json.decode(value);
    } else {
      return {};
    }
  }

  //limpar
  Future<void> clear(String key) async {
    await _prefs!.remove(key);
  }

//limpar tudo
  Future<void> clearAll() async {
    await _prefs!.clear();
  }
}
